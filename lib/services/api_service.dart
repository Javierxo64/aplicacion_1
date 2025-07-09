import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.sebastian.cl/restaurant/v1',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));

  Future<Response> get(String endpoint, String token) async {
    try {
      return await _dio.get(
        endpoint,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'accept': 'application/json',
        }),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String endpoint, String token, dynamic data) async {
    try {
      return await _dio.post(
        endpoint,
        data: data,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'accept': 'application/json',
          'Content-Type': 'application/json',
        }),
      );
    } catch (e) {
      rethrow;
    }
  }
}