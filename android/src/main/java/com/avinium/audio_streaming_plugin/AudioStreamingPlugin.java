package com.avinium.audio_streaming_plugin;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import android.media.*;
import java.util.concurrent.Executor;

/** AudioStreamingPlugin */
public class AudioStreamingPlugin implements MethodCallHandler {

  private Executor _executor;
  private MethodChannel _channel;
  private AudioTrack _audio;

  public AudioStreamingPlugin(MethodChannel channel, Executor executor) {
    this._channel = channel;
    this._executor = executor;
  }
  
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "audio_streaming_plugin");
    Executor executor = registrar.activeContext().getMainExecutor();
    channel.setMethodCallHandler(new AudioStreamingPlugin(channel, executor));
  }

  private void create(byte[] data, boolean mono, int samplingRate) {

    int bufsize = AudioTrack.getMinBufferSize(
      samplingRate,
      mono ? AudioFormat.CHANNEL_OUT_MONO : AudioFormat.CHANNEL_OUT_STEREO,
      AudioFormat.ENCODING_PCM_16BIT
    );
    AudioAttributes attr = 
      new AudioAttributes.Builder()
          .setUsage(AudioAttributes.USAGE_MEDIA)
          .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
          .build();
    AudioFormat.Builder formatBuilder = 
      new AudioFormat.Builder()
          .setSampleRate(samplingRate)
          .setEncoding(AudioFormat.ENCODING_PCM_16BIT);
    
    if(mono) {
      formatBuilder.setChannelMask(AudioFormat.CHANNEL_OUT_MONO).build();
    } else {
      formatBuilder.setChannelMask(AudioFormat.CHANNEL_OUT_STEREO).build();
    }

    AudioFormat fmt = formatBuilder.build();
    
    this._audio = new AudioTrack(
      attr,
      fmt,
      data.length, 
      AudioTrack.MODE_STATIC,
      AudioManager.AUDIO_SESSION_ID_GENERATE);

    int res = _audio.write(data, 0, data.length);
    this._audio.play();
    
    // EventCallback callback = new EventCallback(this._channel);
    //_audio.registerStreamEventCallback(this._executor, callback);
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("play")) {
      if(this._audio == null) {
        byte[] data = (byte[])call.argument("data");
        boolean mono = (boolean)call.argument("mono");
        int samplingRate = (int)call.argument("samplingRate");
        this.create(data, mono, samplingRate);
      } 
      result.success(true);
    } else if (call.method.equals("pause")) {
      this._audio.pause();
      result.success(true);
    }
    else {
      result.notImplemented();
    }
  }

  // private class EventCallback extends AudioTrack.StreamEventCallback  {
  //   private MethodChannel _methodChannel;
    
  //   EventCallback(MethodChannel methodChannel) {
  //     this._methodChannel = methodChannel;
  //   }

  //   public void onDataRequest(AudioTrack track, int sizeInFrames) {

  //   }

  //   public void onPresentationEnded(AudioTrack track) {
  //     this._methodChannel.invokeMethod("complete", null);
  //   }

  //   public void onTearDown(AudioTrack track) {

  //   }
  // }
}
