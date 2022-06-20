import 'dart:convert';

import 'package:http/http.dart' as http;

class Luis {
  static Future<String> predictUserIntent(String message) async {
    var headers = {
      'Ocp-Apim-Subscription-Key': 'ed48561317a44c9e9c2c672567dc6dae'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
          'https://southeastasia.api.cognitive.microsoft.com/luis/prediction/v3.0/apps/139922d7-9dfb-4f3c-baed-ff0e87edee88/slots/production/predict?query=$message&subscription-key=ed48561317a44c9e9c2c672567dc6dae',
        ));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String result = await response.stream.bytesToString();
      final json = jsonDecode(result);
      print('[John] Prediction $json');
      final text = json['prediction']['topIntent'];
      return text;
    } else {
      return 'Error';
    }
  }
}
