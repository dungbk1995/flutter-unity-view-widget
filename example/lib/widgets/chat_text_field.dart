
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_unity_widget_example/use_speech_to_text.dart';
import 'package:flutter_unity_widget_example/values.dart';

typedef MessageCallback = void Function(String text);

class ChatTextField extends HookWidget {
  const ChatTextField({
    this.focusNode,
    required this.onMessage,
    this.displaySpeechToText = true,
    this.autocomplete = true,
  });

  /// The focus node to use for this field.
  final FocusNode? focusNode;

  /// Callback when the user submits a new message.
  final MessageCallback onMessage;

  final bool displaySpeechToText;
  final bool autocomplete;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final text = useValueListenable(controller).text.trim();
    final speechToText = useSpeechToText();
    final clearMessage = useCallback(() {
      controller.clear();
    }, [controller]);

    print('rebuild');
    final sendMessage = useCallback(() {
      print('again');

      if (text.isEmpty) {
        return;
      }

      onMessage(text);
      clearMessage();
    }, [controller, text]);

    final runSpeechToText = useCallback(() {
      final future = speechToText.listen().forEach((words) {
        controller.text = words;
      });

      return () => future.ignore();
    }, [controller, speechToText]);

    return Row(
      children: [
        // const CircularProgressIndicator(
        //   color: Colors.blueAccent,
        // ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: BackdropFilter(
              filter: F.BACKGROUND_BLUR,
              child: TextField(
                autocorrect: autocomplete,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                controller: controller,
                focusNode: focusNode,
                onSubmitted: (_) => sendMessage(),
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: S.x5,
                    vertical: S.x3,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                  hintText: '   Aa',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: Color(0x99C1B9B9),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (text.isNotEmpty && !speechToText.isActive) ...[
                        InkWell(
                          onTap: () => clearMessage(),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: S.x1),
                            padding: EdgeInsets.all(S.x2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(R.x3),
                              boxShadow: [SHADOW_CARD],
                            ),
                            child: Icon(
                              Icons.close,
                              size: 24,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => sendMessage(),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: S.x1),
                            padding: EdgeInsets.all(S.x2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(R.x3),
                              boxShadow: [SHADOW_CARD],
                            ),
                            child: Icon(
                              Icons.arrow_upward_rounded,
                              size: 24,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                      if (displaySpeechToText &&
                          speechToText.isReady &&
                          (text.isEmpty || speechToText.isActive)) //
                        Row(
                          children: [
                            const CircularProgressIndicator(
                              color: Colors.blueAccent,
                            ),
                            const SizedBox(width: 10.0),

                            InkWell(
                              onTap: () {
                                if (!speechToText.isActive) {
                                  print('Mic pressed! - ${DateTime.now().millisecondsSinceEpoch}');
                                  runSpeechToText();

                                  // sleep(Duration(seconds: 5));
                                  print('Mic done! - ${DateTime.now().millisecondsSinceEpoch}');
                                } else {
                                  speechToText.stop();
                                }
                              },
                              child: Container(
                                margin:
                                EdgeInsets.symmetric(horizontal: S.x1),
                                decoration: BoxDecoration(
                                  color: C.GENIUS_PRIMARY,
                                  borderRadius: BorderRadius.circular(R.x5),
                                  boxShadow: [SHADOW_CARD],
                                ),
                                child: !speechToText.isActive
                                    ? Padding(
                                  padding: EdgeInsets.all(S.x2),
                                  child: Icon(
                                    Icons.mic_sharp,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                )
                                    : Padding(
                                  padding: EdgeInsets.all(S.x3),
                                  child: SpinKitWave(
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      SizedBox(width: S.x3),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
