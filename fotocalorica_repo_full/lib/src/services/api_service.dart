import 'dart:io';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://seu-servidor.com')); // coloque sua URL pública

  Future<Map<String, dynamic>> analyzeImage(File imageFile, {double portionMultiplier = 1.0}) async {
    FormData form = FormData.fromMap({
      'photo': await MultipartFile.fromFile(imageFile.path, filename: 'photo.jpg'),
      'portion_multiplier': portionMultiplier.toString()
    });
    final resp = await _dio.post('/api/infer', data: form, options: Options(headers: {
      'Content-Type': 'multipart/form-data'
    }));
    return resp.data;
  }
}
