import 'package:dio/dio.dart';
import 'package:nu_test/core/api/i_http_client.dart';

class Client implements IHttpClient {
  final Dio dio;

  Client({required this.dio});

  @override
  Future<Response> get(String path) async {
    final response = await dio.get(path);
    return response.statusCode == 200 || response.statusCode == 201
        ? response
        : throw Exception('Failed to load data');
  }

  @override
  Future<Response> post(String path, Map<String, dynamic> body) async {
    final response = await dio.post(path, data: body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return response;
    }

    return throw Exception('Failed to post data');
  }
}
