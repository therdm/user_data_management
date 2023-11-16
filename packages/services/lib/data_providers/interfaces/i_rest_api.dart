import 'package:dio/dio.dart';

abstract class IRestApi {
  Future<Response<dynamic>?> post(
    String path, {
    String apiVersion = '',
    String? baseUrl,
    required dynamic body,
    bool attachToken = true,
  });

  Future<Response<dynamic>?> get(
    String path, {
    String apiVersion = '',
    String? baseUrl,
    Map<String, dynamic>? queryParameters,
    bool attachToken = true,
  });

  Future<Response<dynamic>?> put(
    String path, {
    String apiVersion = '',
    String? baseUrl,
    required dynamic body,
    bool attachToken = true,
  });

  Future<Response<dynamic>?> patch(
    String path, {
    String apiVersion = '',
    String? baseUrl,
    required dynamic body,
    bool attachToken = true,
  });

  Future<Response<dynamic>?> delete(
    String path, {
    String apiVersion = '',
    String? baseUrl,
    required dynamic body,
    bool attachToken = true,
  });
}
