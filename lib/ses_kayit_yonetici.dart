import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SesKayitYonetici {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  String? _dosyaYolu;

  Future<void> hazirla() async {
    await Permission.microphone.request();
    await Permission.storage.request();
    await _recorder.openRecorder();

    final dizin = await getApplicationDocumentsDirectory();
    _dosyaYolu = '${dizin.path}/kayit.wav';
  }

  Future<void> baslat() async {
    if (_dosyaYolu == null) return;
    await _recorder.startRecorder(toFile:_dosyaYolu, codec: Codec.pcm16WAV);
  }

  Future<String?> durdur() async {
    await _recorder.stopRecorder();
    return _dosyaYolu;
  }

  void temizle() {
    _recorder.closeRecorder();
  }
}
