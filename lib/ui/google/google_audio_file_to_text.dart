import 'dart:async';
import 'dart:io';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';
import 'package:permission_handler/permission_handler.dart';

class GoogleAPI extends StatefulWidget {
  const GoogleAPI({Key? key}) : super(key: key);

  @override
  _GoogleAPIState createState() => _GoogleAPIState();
}

class _GoogleAPIState extends State<GoogleAPI> {
  String? transcribeText;
  bool isTranscribing = false;

  late SpeechToText speechToText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(transcribeText ?? 'Your text will appear here'),
            ElevatedButton(
              onPressed: isTranscribing ? null : _transcribe,
              child: const Text('Transcribe test.wav audio to text'),
            ),
          ],
        ),
      ),
    );
  }

  void _transcribe() async {
    setState(() {
      isTranscribing = true;
    });

    // Configuration
    final config = RecognitionConfig(
        encoding: AudioEncoding.LINEAR16,
        model: RecognitionModel.basic,
        enableAutomaticPunctuation: true,
        sampleRateHertz: 48000,
        languageCode: 'en-US');

    // Get the contents of the audio file
    final audio = await _getAudioContent('test.wav');

    // send the request
    await speechToText.recognize(config, audio).then((value) {
      setState(() {
        transcribeText = value.results
            .map((e) => e.alternatives.first.transcript)
            .join('\n');
      });
    }).whenComplete(() {
      setState(() {
        isTranscribing = false;
      });
    });
  }

  Future<List<int>> _getAudioContent(String audioName) async {
    String path = '';
    Directory? downloadsDirectory =
        await DownloadsPathProvider.downloadsDirectory;
    path = downloadsDirectory!.path + '/test.wav';
    return File(path).readAsBytesSync().toList();
  }

  @override
  void initState() {
    setPermission();
    initGoogleApi();
    super.initState();
  }

  void setPermission() async {
    await Permission.manageExternalStorage.request();
    await Permission.storage.request();
  }

  void initGoogleApi() async {
    // Authentication
    final file =
        await rootBundle.loadString('assets/john-osim-95873a6065d6.json');
    final serviceAccount = ServiceAccount.fromString(file);

    // Initialize SpeechToText
    speechToText = SpeechToText.viaServiceAccount(serviceAccount);
  }
}
