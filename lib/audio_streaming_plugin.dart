import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

import 'audio_out_stream.dart';

class AudioStreamingPlugin {
  static const MethodChannel _channel =
      const MethodChannel('audio_streaming_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static AudioOutStream createPlayer(Uint8List data, int samplingRate, bool mono) {
    return AudioOutStream(data, samplingRate, mono, _channel);
  }

}
