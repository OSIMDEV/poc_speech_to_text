// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_speech/google_speech.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:sound_stream/sound_stream.dart';
//
// class GoogleStream extends StatefulWidget {
//   const GoogleStream({Key? key}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => _GoogleStreamState();
// }
//
// class _GoogleStreamState extends State<GoogleStream> {
//   final RecorderStream _recorder = RecorderStream();
//
//   bool recognizing = false;
//   bool recognizeFinished = false;
//   String text = '';
//   StreamSubscription<List<int>>? _audioStreamSubscription;
//   BehaviorSubject<List<int>>? _audioStream;
//
//   @override
//   void initState() {
//     super.initState();
//     // setPermission();
//     _recorder.initialize();
//   }
//
//   // void setPermission() async {
//   //   await Permission.manageExternalStorage.request();
//   //   await Permission.storage.request();
//   // }
//
//   void streamingRecognize() async {
//     _audioStream = BehaviorSubject<List<int>>();
//     _audioStreamSubscription = _recorder.audioStream.listen((event) {
//       _audioStream!.add(event);
//     });
//
//     await _recorder.start();
//
//     setState(() {
//       recognizing = true;
//     });
//
//     // Authentication
//     final file =
//         await rootBundle.loadString('assets/john-osim-95873a6065d6.json');
//     final serviceAccount = ServiceAccount.fromString(file);
//
//     final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
//     final config = _getConfig();
//
//     final responseStream = speechToText.streamingRecognize(
//         StreamingRecognitionConfig(config: config, interimResults: true),
//         _audioStream!);
//
//     var responseText = '';
//
//     responseStream.listen((data) {
//       final currentText =
//           data.results.map((e) => e.alternatives.first.transcript).join('\n');
//
//       if (data.results.first.isFinal) {
//         responseText += '\n' + currentText;
//         setState(() {
//           text = responseText;
//           recognizeFinished = true;
//         });
//       } else {
//         setState(() {
//           text = responseText + '\n' + currentText;
//           recognizeFinished = true;
//         });
//       }
//     }, onDone: () {
//       setState(() {
//         recognizing = false;
//       });
//     });
//   }
//
//   void stopRecording() async {
//     await _recorder.stop();
//     await _audioStreamSubscription?.cancel();
//     await _audioStream?.close();
//     setState(() {
//       recognizing = false;
//     });
//   }
//
//   RecognitionConfig _getConfig() => RecognitionConfig(
//         encoding: AudioEncoding.LINEAR16,
//         model: RecognitionModel.basic,
//         enableAutomaticPunctuation: true,
//         sampleRateHertz: 16000,
//         // languageCode: 'zh',
//         languageCode: 'en-US',
//       );
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Audio File Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: <Widget>[
//             if (recognizeFinished)
//               _RecognizeContent(
//                 text: text,
//               ),
//             ElevatedButton(
//               onPressed: recognizing ? stopRecording : streamingRecognize,
//               child: recognizing
//                   ? const Text('Stop recording')
//                   : const Text('Start Streaming from mic'),
//             ),
//           ],
//         ),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
//
// class _RecognizeContent extends StatelessWidget {
//   final String? text;
//
//   const _RecognizeContent({Key? key, this.text}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: <Widget>[
//           const Text(
//             'The text recognized by the Google Speech Api:',
//           ),
//           const SizedBox(
//             height: 16.0,
//           ),
//           Text(
//             text ?? '---',
//             style: Theme.of(context).textTheme.bodyText1,
//           ),
//         ],
//       ),
//     );
//   }
// }
