import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_unity_widget_example/speech_to_text_service.dart';
import 'package:provider/provider.dart';

SpeechToTextService useSpeechToText() {
  final context = useContext();
  return context.watch<SpeechToTextService>();
}
