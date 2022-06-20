import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MicrosoftPlugin extends StatefulWidget {
  const MicrosoftPlugin({Key? key}) : super(key: key);

  @override
  _MicrosoftPluginState createState() => _MicrosoftPluginState();
}

class _MicrosoftPluginState extends State<MicrosoftPlugin> {
  static const MethodChannel _channel =
      const MethodChannel('azure_speech_recognition');

  @override
  void initState() {
    _channel.setMethodCallHandler(_platformCallHandler);
    super.initState();
  }

  Future _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "speech.onRecognitionStarted":
        break;
      case "speech.onSpeech":
        break;
      case "speech.onFinalResponse":
        break;
      case "speech.onStartAvailable":
        break;
      case "speech.onRecognitionStopped":
        break;
      case "speech.onException":
        break;
      default:
        print("Error: method called not found");
    }
  }

  void micStream() {
    _channel.invokeMethod('micStream');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  micStream();
                },
                child: Text(
                  'Open Micc',
                ))
          ],
        ),
      ),
    );
  }
}
