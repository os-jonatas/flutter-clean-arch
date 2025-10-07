import 'package:dio/dio.dart';

abstract class IHttpClient {
  Future<Response> get(String path);
  Future<Response> post(String path, Map<String, dynamic> body);
}
