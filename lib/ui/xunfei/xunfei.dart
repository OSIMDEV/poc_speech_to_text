import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Xunfei extends StatefulWidget {
  const Xunfei({Key? key}) : super(key: key);

  @override
  _XunfeiState createState() => _XunfeiState();
}

class _XunfeiState extends State<Xunfei> {
  final TextEditingController _controller = TextEditingController();

  StreamController<String> streamController =
      StreamController.broadcast(sync: true);

  late WebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ifly'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TextButton(
            //   onPressed: () async {
            //     Uint8List encoded = binaryCodec.encode({"end": true});
            //     _channel.sink.add(encoded);
            //   },
            //   child: Text('Disconnect'),
            // ),
            //
            // TextButton(
            //   onPressed: () async {
            //     // final data = await _getAudio();
            //     // _channel.sink.add(data);
            //   },
            //   child: Text('Send Audio'),
            // ),

            StreamBuilder(
              stream: streamController.stream,
              builder: (context, snapshot) {
                return Text(snapshot.hasData ? '${snapshot.data}' : '');
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _init,
        tooltip: 'Init',
        child: const Icon(Icons.send),
      ),
    );
  }

  void _init() {
    var appId = '3e729cc0';
    var ts =
        DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond;
    var baseString = '$appId$ts';
    var signa = generateSigna(baseString);

    _channel = WebSocketChannel.connect(
      Uri.parse('ws://rtasr.xfyun.cn/v1/ws?appid=$appId&ts=$ts&signa=$signa'),
    );

    _channel.stream.listen((message) {
      print('[John] ${message.toString()}');
      streamController.add(message);
    });
  }

  String generateSigna(String baseString) {
    var bytes = utf8.encode(baseString);
    var data = md5.convert(bytes).toString();
    var key = 'b3f4a1a4379cad795702c66460c9e6ef';
    var hmacSha1 = Hmac(sha1, utf8.encode(key));
    var result = hmacSha1.convert(utf8.encode(data));
    return base64Encode(result.bytes);
  }

  Future<Uint8List> _getAudio() async {
    String path = '';
    Directory? downloadsDirectory =
        await DownloadsPathProvider.downloadsDirectory;
    path = downloadsDirectory!.path + '/test.wav';
    return File(path).readAsBytesSync();
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}
