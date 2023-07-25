import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:flutter_unity_widget_example/widgets/chat_text_field.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class SimpleScreen extends HookWidget {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  UnityWidgetController? _unityWidgetController;

  @override
  Widget build(BuildContext context) {
    final _sliderValue = useState(0.0);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Simple Screen'),
      ),
      body: Card(
          margin: const EdgeInsets.all(0),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            children: [
              UnityWidget(
                onUnityCreated: _onUnityCreated,
                onUnityMessage: onUnityMessage,
                onUnitySceneLoaded: onUnitySceneLoaded,
                useAndroidViewSurface: false,
                borderRadius: const BorderRadius.all(Radius.circular(70)),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [

                    ChatTextField(onMessage: (msg) => print('msg: $msg')),

                    const SizedBox(height: 10),
                    PointerInterceptor(
                      child: Card(
                        elevation: 10,
                        child: Column(
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text("Rotation speed:"),
                            ),
                            Slider(
                              onChanged: (value) {
                                _sliderValue.value = value;
                                setRotationSpeed(value.toString());
                              },
                              value: _sliderValue.value,
                              min: 0.0,
                              max: 1.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  void setRotationSpeed(String speed) {
    _unityWidgetController?.postMessage(
      'Cube',
      'SetRotationSpeed',
      speed,
    );
  }

  void onUnityMessage(message) {
    print('Received message from unity: ${message.toString()}');
  }

  void onUnitySceneLoaded(SceneLoaded? scene) {
    if (scene != null) {
      print('Received scene loaded from unity: ${scene.name}');
      print('Received scene loaded from unity buildIndex: ${scene.buildIndex}');
    } else {
      print('Received scene loaded from unity: null');
    }
  }

  // Callback that connects the created controller to the unity controller
  void _onUnityCreated(controller) {
    controller.resume();
    _unityWidgetController = controller;
  }
}
