import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:audio_streaming_plugin/audio_streaming_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('audio_streaming_plugin');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await AudioStreamingPlugin.platformVersion, '42');
  });

  test('playAudio', () async {
    var testFile = new File('assets/test.wav');
    testFile.readAsBytesSync();
    var player = AudioStreamingPlugin.createPlayer(testFile.readAsBytesSync());
    player.play();
    expect(player.playing, true);
  });
}
