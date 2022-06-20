import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:poc_speech_to_text/ml_luis/luis_api.dart';
import 'package:poc_speech_to_text/substring_highlighted.dart';
import 'package:poc_speech_to_text/utils.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTestPlugin extends StatefulWidget {
  const SpeechToTestPlugin({Key? key}) : super(key: key);

  @override
  _SpeechToTestPluginState createState() => _SpeechToTestPluginState();
}

class _SpeechToTestPluginState extends State<SpeechToTestPlugin> {
  String text = 'Press the button and start speaking';
  String? userIntent;
  bool isListening = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Speech to Text Plugin'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            reverse: true,
            padding: const EdgeInsets.all(30).copyWith(bottom: 150),
            child: Column(
              children: [
                if (userIntent != null) ...[
                  Text('User Intent:  $userIntent'),
                ],
                SubstringHighlight(
                  text: text,
                  terms: Command.all,
                  textStyle: TextStyle(
                    fontSize: 32.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  textStyleHighlight: TextStyle(
                    fontSize: 32.0,
                    color: Colors.red,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          animate: isListening,
          endRadius: 75,
          glowColor: Theme.of(context).primaryColor,
          child: FloatingActionButton(
            child: Icon(isListening ? Icons.mic : Icons.mic_none, size: 36),
            onPressed: toggleRecording,
          ),
        ),
      );

  Future toggleRecording() => SpeechApi.toggleRecording(
        onResult: (text) => setState(() {
          this.text = text;
          userIntent = null;
        }),
        onListening: (isListening) async {
          setState(() => this.isListening = isListening);

          if (!isListening) {
            Future.delayed(Duration(seconds: 1), () {
              Utils.scanText(text);
            });
          }

          if (!isListening && text != '') {
            String intent = await Luis.predictUserIntent(text);

            setState(() {
              userIntent = intent;
            });
          }
        },
      );
}

class SpeechApi {
  static final _speech = SpeechToText();

  static Future<bool> toggleRecording({
    required Function(String text) onResult,
    required ValueChanged<bool> onListening,
  }) async {
    if (_speech.isListening) {
      _speech.stop();
      return true;
    }

    final isAvailable = await _speech.initialize(
      onStatus: (status) => onListening(_speech.isListening),
      onError: (e) => print('Error: $e'),
      debugLogging: true,
      options: [SpeechToText.androidIntentLookup],
    );

    if (isAvailable) {
      _speech.listen(
        // localeId: 'zh',
        localeId: 'en-US',
        onResult: (value) => onResult(value.recognizedWords),
      );
    }

    return isAvailable;
  }
}
