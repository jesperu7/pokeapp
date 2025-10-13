import 'package:dio/dio.dart';

class NetworkClient {
  final Dio _dio;

  static const String _baseUrl = 'https://pokeapi.co/api/v2';

  NetworkClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    _dio.interceptors.add(
      LogInterceptor(request: true, requestBody: true, responseBody: true, error: true),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _dio.get(path, queryParameters: queryParameters, options: options);
    return response;
  }
}

extension DioResponseJson on Response {
  Map<String, dynamic> get json => data as Map<String, dynamic>;
}
