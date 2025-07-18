// lib/services/voice_evaluation_service.dart

import 'package:dio/dio.dart';
import 'dart:io';


class VoiceEvaluationService {
  final Dio _dio = Dio();
  

  Future<List<Map<String, dynamic>>> uploadAudioAndText({
    required File audioFile,
    required String text,
  }) async {
    final url = 'http://127.0.0.1:5000/recognize';

    final formData = FormData.fromMap({
      'audio': await MultipartFile.fromFile(audioFile.path, filename: 'audio.wav'),
      'text': text,
    });

    try {
      final response = await _dio.post(url, data: formData);
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Sunucu hatası: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API bağlantı hatası: $e');
    }
  }
}
