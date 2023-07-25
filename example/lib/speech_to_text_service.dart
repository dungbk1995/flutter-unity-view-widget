import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_unity_widget_example/logger.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/subjects.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:collection/collection.dart';

/// Provides an interface for speech-to-text configuration and operations.
class SpeechToTextService extends ChangeNotifier {
  factory SpeechToTextService() => _instance;

  static final SpeechToTextService _instance = SpeechToTextService._internal();

  SpeechToTextService._internal() {
    _initialize();
  }

  final Logger _logger = Logger(
    printer: createSimplePrefixPrinter(
      PrettyPrinter(methodCount: 3),
      prefix: '[Speech-to-Text]',
    ),
  );

  final SpeechToText _speechToText = SpeechToText();

  Timer? _silenceTimer = null;
  static const Duration _silenceDuration = Duration(seconds: 5);
  var _availableLocales = <LocaleName>[];

  /// The available speech-to-text locales on this device.
  List<LocaleName> get availableLocales => _availableLocales;

  var _isInitialized = false;

  /// Whether or not the speech-to-text service has loaded and a locale may be set.
  bool get isInitialized => _isInitialized;

  var _isActive = false;

  /// Whether or not speech-to-text is currently executing.
  bool get isActive => _isActive;

  var _isDone = false;

  /// Whether or not speech-to-text has finished executing.
  bool get isDone => _isDone;

  LocaleName? _locale;

  /// The current active speech-to-text locale, configured using [setLanguage].
  LocaleName? get locale => _locale;

  /// Whether or not [speechToText] can be used successfully. Requires initialization and a valid locale.
  bool get isReady => _speechToText.isAvailable && locale != null;

  Future<void> _initialize() async {
    try {
      _logger.i('Speech-to-text trying to initialize');
      // TODO: Executing this pops a permission dialog, so might want to have UI for it in the future.
      final success = await _speechToText.initialize(
        onStatus: (status) {
          _isActive = status == SpeechToText.listeningStatus;
          notifyListeners();
          _logger.i('Speech-to-text status changed to $status.');
        },
        onError: (error) {},
      );

      if (success) {
        _logger.i('Speech-to-text initialized successfully.');
        _isInitialized = true;
        // Theoretically this never fails if initialization worked.
        _availableLocales = await _speechToText.locales();
        setLanguage('en');
      } else {
        _logger.i('Speech-to-text failed to initialize.');
      }
    } catch (error) {
      _logger.e('Speech-to-text failed to initialize and produced an error.', error);
    }
  }

  /// Sets the speech-to-text language. Returns true if a locale was found for the language, false otherwise.
  /// TODO: There should be some in-app guidance on how to install a speech-to-text locale for the device.
  bool setLanguage(String language) {
    // Locales haven't loaded yet, try again later when they're ready.
    if (availableLocales.isEmpty) {
      return false;
    }

    // Not entirely sure how to map the Unity language to a locale ID, but this seems to work for now.
    final locale =
        availableLocales.firstWhereOrNull((locale) => locale.localeId.startsWith(language));

    if (locale != null) {
      _logger.i(
        'Now using speech-to-text locale ${locale.name} (${locale.localeId}), '
        'mapped from language "$language".',
      );

      _locale = locale;
    } else {
      _logger.w(
        'Failed to find a speech-to-text locale for language "$language". '
        'Available locales are: ${availableLocales.map((locale) => "${locale.name} (${locale.localeId})").join(', ')}.',
      );

      _locale = null;
    }

    notifyListeners();
    return _locale != null;
  }

  /// Performs speech-to-text, streaming the result as the user speaks.
  Stream<String> listen() {
    _isDone = false;
    if (!_speechToText.isAvailable) {
      throw StateError('Speech-to-text is not ready yet.');
    }

    _isActive = true;
    notifyListeners();

    // Analytics.trackSpeechToText();
    final subject = PublishSubject<String>();

    _speechToText.listen(
      localeId: _locale?.localeId,
      listenMode: ListenMode.deviceDefault,
      pauseFor: _silenceDuration,
      sampleRate: 44100,
      cancelOnError: true,
      partialResults: true,
      onResult: (result) {
        _logger.i('Speech-to-text result: ${result.recognizedWords}');
        _logger.i('Speech-to-text isFinal: ${result.finalResult}');
        subject.add(result.recognizedWords);

        if (result.finalResult) {
          subject.close();
        }
      },
    );

    return subject.stream;
  }

  // Stop listening to speech-to-text.
  void stop() {
    _isDone = true;
    _isActive = false;
    notifyListeners();
    _speechToText.stop();
  }
}
