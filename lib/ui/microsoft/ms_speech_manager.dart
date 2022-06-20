// //
// // Copyright 2022 Picovoice Inc.
// //
// // You may not use this file except in compliance with the license. A copy of the license is located in the "LICENSE"
// // file accompanying this source.
// //
// // Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on
// // an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
// // specific language governing permissions and limitations under the License.
// //
//
// import 'dart:async';
//
// import 'package:rxdart/rxdart.dart';
// import 'package:sound_stream/sound_stream.dart';
//
// typedef TranscriptCallback = Function(String transcript);
//
// typedef ProcessErrorCallback = Function(Exception error);
//
// class MsSpeechManager {
//   final RecorderStream _recorder = RecorderStream();
//
//   final String token;
//   final TranscriptCallback _transcriptCallback;
//   final ProcessErrorCallback _processErrorCallback;
//
//   StreamSubscription<List<int>>? _audioStreamSubscription;
//   BehaviorSubject<List<int>>? _audioStream;
//
//   static MsSpeechManager create(
//       String token,
//       TranscriptCallback transcriptCallback,
//       ProcessErrorCallback processErrorCallback) {
//     return MsSpeechManager._(token, transcriptCallback, processErrorCallback);
//   }
//
//   MsSpeechManager._(
//     this.token,
//     this._transcriptCallback,
//     this._processErrorCallback,
//   ) {
//     _recorder.initialize();
//   }
//
//   Future<void> startProcess() async {
//     _audioStream = BehaviorSubject<List<int>>();
//     _audioStreamSubscription = _recorder.audioStream.listen((event) async {
//       _audioStream!.add(event);
//
//       // await MsApiService().microphone(token, _audioStream?.stream.value);
//     });
//
//     await _recorder.start();
//   }
//
//   Future<void> stopProcess() async {
//     await _recorder.stop();
//     await _audioStreamSubscription?.cancel();
//     await _audioStream?.close();
//
//     // if (_voiceProcessor == null) {
//     //   throw Exception(
//     //       "Cannot start Cheetah - resources have already been released");
//     // }
//     //
//     // if (_voiceProcessor?.isRecording ?? false) {
//     //   await _voiceProcessor!.stop();
//     //   // CheetahTranscript cheetahTranscript = await _cheetah!.flush();
//     //   // _transcriptCallback((cheetahTranscript.transcript) + " ");
//     // }
//   }
//
//   Future<void> delete() async {
//     // if (_voiceProcessor?.isRecording ?? false) {
//     //   await _voiceProcessor!.stop();
//     // }
//     // _removeVoiceProcessorListener?.call();
//     // _removeErrorListener?.call();
//   }
// }
