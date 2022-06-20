// import 'dart:async';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:sound_stream/sound_stream.dart';
//
// import 'ms_api.dart';
//
// // class MsHomePage extends StatefulWidget {
// //   const MsHomePage({Key? key}) : super(key: key);
// //
// //   @override
// //   _MsHomePageState createState() => _MsHomePageState();
// // }
// //
// // class _MsHomePageState extends State<MsHomePage> {
// //   String? _token;
// //   String? _audioText;
// //
// //   late MsSpeechManager _msSpeechManager;
// //
// //   @override
// //   Widget build(BuildContext context) => Scaffold(
// //       appBar: AppBar(
// //         title: Text('MS Plugin'),
// //         centerTitle: true,
// //       ),
// //       body: Container(
// //         width: double.infinity,
// //         height: double.infinity,
// //         child: SingleChildScrollView(
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.center,
// //             children: [
// //               Text('Token: $_token'),
// //               ElevatedButton(
// //                 onPressed: () async {
// //                   String? token = await MsApiService().getToken();
// //                   setState(() {
// //                     _token = token;
// //                     _msSpeechManager = MsSpeechManager.create(
// //                         _token!, (transcript) {}, (error) {});
// //                   });
// //                 },
// //                 child: const Text('Get Token'),
// //               ),
// //               Text('Convert Audio to MP3: $_audioText'),
// //               ElevatedButton(
// //                 onPressed: () async {
// //                   String? audioText = await MsApiService().audioFile(_token!);
// //                   setState(() {
// //                     _audioText = audioText;
// //                   });
// //                 },
// //                 child: const Text('Get Text from Audio'),
// //               ),
// //               Text('Microphone: '),
// //               ElevatedButton(
// //                 onPressed: () async {
// //                   await _msSpeechManager.startProcess();
// //
// //                   // setState(() {
// //                   //   _audioText = audioText;
// //                   // });
// //                 },
// //                 child: const Text('Get Text from Audio'),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ));
// // }
//
// class MircosoftApp extends StatefulWidget {
//   @override
//   _MircosoftAppState createState() => _MircosoftAppState();
// }
//
// class _MircosoftAppState extends State<MircosoftApp> {
//   RecorderStream _recorder = RecorderStream();
//   PlayerStream _player = PlayerStream();
//
//   List<Uint8List> _micChunks = [];
//   bool _isRecording = false;
//   bool _isPlaying = false;
//
//   String? _token;
//
//   StreamSubscription? _recorderStatus;
//   StreamSubscription? _playerStatus;
//   StreamSubscription? _audioStream;
//
//   Timer? _timer;
//
//   @override
//   void initState() {
//     super.initState();
//     initPlugin();
//   }
//
//   @override
//   void dispose() {
//     _recorderStatus?.cancel();
//     _playerStatus?.cancel();
//     _audioStream?.cancel();
//     super.dispose();
//   }
//
//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlugin() async {
//     _recorderStatus = _recorder.status.listen((status) {
//       if (mounted) {
//         setState(() {
//           _isRecording = status == SoundStreamStatus.Playing;
//         });
//       }
//     });
//
//     _audioStream = _recorder.audioStream.listen((data) {
//       if (_isPlaying) {
//         _player.writeChunk(data);
//       } else {
//         _micChunks.add(data);
//       }
//     });
//
//     _playerStatus = _player.status.listen((status) {
//       if (mounted) {
//         setState(() {
//           _isPlaying = status == SoundStreamStatus.Playing;
//         });
//       }
//     });
//
//     await Future.wait([
//       _recorder.initialize(),
//       _player.initialize(),
//     ]);
//
//     _timer?.cancel();
//     _timer = Timer.periodic(Duration(milliseconds: 1000), (_) async {
//       if (_micChunks.isEmpty) return;
//
//       // final data = Uint8List.fromList(List<int>.from(_micChunks));
//
//       _micChunks.clear();
//
//       await MsApiService().microphone(_token!, _micChunks);
//     });
//   }
//
//   void _play() async {
//     await _player.start();
//
//     if (_micChunks.isNotEmpty) {
//       for (var chunk in _micChunks) {
//         await _player.writeChunk(chunk);
//       }
//       _micChunks.clear();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: Column(
//           children: [
//             Text('Token: $_token'),
//             ElevatedButton(
//               onPressed: () async {
//                 String? token = await MsApiService().getToken();
//                 setState(() {
//                   _token = token;
//                 });
//               },
//               child: const Text('Get Token'),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 IconButton(
//                   iconSize: 96.0,
//                   icon: Icon(_isRecording ? Icons.mic_off : Icons.mic),
//                   onPressed: _isRecording ? _recorder.stop : _recorder.start,
//                 ),
//                 IconButton(
//                   iconSize: 96.0,
//                   icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
//                   onPressed: _isPlaying ? _player.stop : _play,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
