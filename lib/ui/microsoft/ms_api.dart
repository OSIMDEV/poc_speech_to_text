import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:http/http.dart' as http;

class MsApiService {
  Future<String?> getToken() async {
    try {
      var url = Uri.parse(ApiConstants.tokenUrl);
      var response = await http.post(url, headers: {
        'Ocp-Apim-Subscription-Key': '49b045d8050048f292bb22051931fcae'
      });
      if (response.statusCode == 200) {
        var token = response.body;
        return token;
      }
    } catch (e) {
      log('[John] Error' + e.toString());
    }
  }

  Future<String> audioFile(String token) async {
    try {
      var headers = {
        'Content-type': 'audio/wav',
        'Authorization': 'Bearer $token'
      };
      var request = http.Request(
          'POST',
          Uri.parse(
              'https://eastasia.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=en-US'));

      var audioContent = await _getAudioContent();
      request.bodyBytes = audioContent;
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String result = await response.stream.bytesToString();
        final json = jsonDecode(result);
        final text = json['DisplayText'];
        return text;
      } else {
        return '[John] Error ${response.reasonPhrase}';
      }
    } catch (e) {
      return '[John] Error' + e.toString();
    }
  }

  Future<List<int>> _getAudioContent() async {
    String path = '';
    Directory? downloadsDirectory =
        await DownloadsPathProvider.downloadsDirectory;
    path = downloadsDirectory!.path + '/test.wav';
    return File(path).readAsBytesSync();
  }

  Future<String> microphone(String token, List<Uint8List> audioBytes) async {
    try {
      var headers = {
        'Content-type': 'audio/wav',
        'Authorization': 'Bearer $token',
      };
      var request = http.Request(
          'POST',
          Uri.parse(
              'https://eastasia.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=en-US'));

      request.bodyBytes = audioBytes.cast<int>();
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String result = await response.stream.bytesToString();
        final json = jsonDecode(result);
        print('[John] JSON ${json}');

        final text = json['DisplayText'];
        return text;
      } else {
        print('[John] Error ${response.reasonPhrase}');
        return '[John] Error ${response.reasonPhrase}';
      }
    } catch (e) {
      return '[John] Error' + e.toString();
    }
  }
}

class ApiConstants {
  static String tokenUrl =
      'https://eastasia.api.cognitive.microsoft.com/sts/v1.0/issueToken';

  static String audioFileToTextUrl =
      'https://eastasia.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=en-US';
}
