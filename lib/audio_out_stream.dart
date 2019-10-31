import 'dart:typed_data';

import 'package:flutter/services.dart';

class AudioOutStream {
  
  Uint8List _data;
  int _samplingRate;
  bool _mono;
  MethodChannel _channel;
  bool _playing;
  bool get playing => _playing;

  AudioOutStream(
    this._data, 
    this._samplingRate,
    this._mono,
    this._channel) {
    this._channel.setMethodCallHandler((MethodCall call) {
      if(call.method == "complete") {
        _playing = false;
        // todo
      }
      return Future.value(null);
    });
  }

  void play() {
    _playing = true;
    try {
      this._channel.invokeMethod("play", {"data":this._data, "mono":this._mono, "samplingRate":this._samplingRate});
    } catch(err) {
      _playing = false;
    }
  }
  
  void stop() {
    try {
      this._channel.invokeMethod("stop");
    } catch(err) {
      print("ERROR: " + err);
    }
  }

  void pause() {
    try {
      this._channel.invokeMethod("pause");
    } catch(err) {
      print("ERROR: " + err);
    }
  }

}