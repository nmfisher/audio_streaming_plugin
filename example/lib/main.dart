import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:audio_streaming_plugin/audio_streaming_plugin.dart';
import 'package:audio_streaming_plugin/audio_out_stream.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  AudioOutStream _player;

  void loadFile() async {
    ByteData data = await rootBundle.load('assets/test.wav');
    _player = AudioStreamingPlugin.createPlayer(data.buffer.asUint8List(), 22050, true);
  }
  @override
  void initState() {
    super.initState();
    initPlatformState();
    loadFile();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await AudioStreamingPlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: RaisedButton(
            onPressed: () {
              _player.play();
            },
            child:Text('Play'),
        ),
      ),
    ));
  }
}
