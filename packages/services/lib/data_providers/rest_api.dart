import 'dart:developer';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:services/data_providers/interfaces/i_rest_api.dart';
import 'package:services/utils/logger.dart';

export 'package:dio/dio.dart';
export 'package:services/network_state_manager/extensions/response_to_map.dart';
export 'package:services/network_state_manager/network_response/service_response.dart';

enum _RestApiMethod { get, put, post, patch, delete }

class RestApi implements IRestApi {
  RestApi._();

  static final instance = RestApi._();

  static String _baseUrl = '';
  static String _apiVersion = '';
  static bool _showApiLog = false;

  CookieManager? cookieManager;

  void logout() {
    cookieManager?.cookieJar.deleteAll();
  }

  Future<void> initialize(
      {required String baseUrl, required bool showApiLog, required String apiVersion}) async {
    RestApi._baseUrl = baseUrl;
    RestApi._showApiLog = showApiLog;
    RestApi._apiVersion = apiVersion;
    dio = Dio(BaseOptions(baseUrl: _baseUrl));
    if (!kIsWeb) {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String appDocPath = appDocDir.path;
      final jar = PersistCookieJar(storage: FileStorage('$appDocPath/.cookies/'));
      cookieManager = CookieManager(jar);
      dio.interceptors.add(cookieManager!);
    }
  }

  Dio dio = Dio(BaseOptions(baseUrl: _baseUrl));

  Future<Map<String, dynamic>> getHeader() async {
    // String? bToken = LocalStorage.instance.readString(LocalStorageKeys.bearerToken);
    final Map<String, dynamic> headers = {
      // 'Authorization': bToken ?? "",
      'Access-Control-Allow-Headers': true,
      'Content-Type': 'application/json',
    };
    return headers;
  }

  // void _apiLog(
  //   String path, {
  //   required String apiVersion,
  //   required _RestApiMethod apiMethod,
  //   dynamic body = const <Map<String, String>>{},
  //   Map<String, dynamic>? queryParameters,
  //   Response<dynamic>? response,
  // }) {
  //   ///logging the RESPONSE details
  //   if (_showApiLog) {
  //     ///logging the POST endpoint and PAYLOAD
  //     print('[$apiMethod] ${dio.options.baseUrl}$path');
  //     // print('[HEADER] ${dio.options.headers}');
  //     if (body is! FormData) {
  //       print('[BODY] ${body}');
  //     }
  //     print('[RESPONSE] ${response?.data}');
  //     print('[STATUS CODE] ${response?.statusCode}');
  //   }
  // }
  _apiLog(
    String path, {
    required String apiVersion,
    required _RestApiMethod apiMethod,
    dynamic body = const <Map<String, String>>{},
    Map<String, dynamic>? queryParameters,
    Response<dynamic>? response,
    Map<String, dynamic>? header,
    bool isError = false,
  }) {
    if (!kIsWeb && _showApiLog) {
      const separator =
          '-----------------------------------------------------------------------------------\n';
      String apiCallDetails = 'END POINT » ${dio.options.baseUrl}$path\n';
      apiCallDetails = apiCallDetails + separator;
      apiCallDetails = '${apiCallDetails}HEADERS » ${header ?? dio.options.headers}\n$separator';
      if (body is! FormData && body != {}) {
        apiCallDetails = '${apiCallDetails}PAYLOAD » ${LogMaster.prettyJson(body)}\n';
        apiCallDetails = apiCallDetails + separator;
      }
      apiCallDetails = '${apiCallDetails}RESPONSE » \n${LogMaster.prettyJson(response?.data)}\n$separator';
      if (!isError) {
        apiCallDetails = '${apiCallDetails}STATUS CODE » ${response?.statusCode}\n';
      } else {
        apiCallDetails = '${apiCallDetails}ERROR STATUS CODE » ${response?.statusCode}\n';
        apiCallDetails = '${apiCallDetails}ERROR STATUS MESSAGE » ${response?.statusMessage}\n';
      }
      LogMaster.info(
        apiCallDetails,
        tag: '${apiMethod.name.toUpperCase()} API',
        printLeftLine: true,
        stackTraceLevel: 3,
      );
    }
  }

  Future<Response<dynamic>> _restApi(
    String path, {
    String? baseUrl,
    required String apiVersion,
    required _RestApiMethod apiMethod,
    dynamic body = const <Map<String, String>>{},
    Map<String, dynamic>? header,
    Map<String, dynamic>? queryParameters,
    ResponseType? responseType,
    bool attachToken = true,
  }) async {
    try {
      if (baseUrl != null) {
        dio.options.baseUrl = baseUrl + apiVersion;
      } else {
        dio.options.baseUrl = _baseUrl + _apiVersion;
      }

      // if (InternetConnectionManager.instance.isInternetConnected) {
      //   return Response<Map<String, dynamic>?>(
      //     requestOptions: RequestOptions(path: path),
      //     statusCode: 418,
      //     statusMessage: 'No Internet Connection',
      //   );
      // }

      Response<dynamic> response;

      final options = header != null
          ? Options(headers: header, responseType: responseType)
          : (attachToken ? Options(headers: await getHeader(), responseType: responseType) : null);
      switch (apiMethod) {
        case _RestApiMethod.get:
          response = await dio.get(path, options: options, queryParameters: queryParameters);
          break;
        case _RestApiMethod.put:
          response = await dio.put(path, data: body, options: options);
          break;
        case _RestApiMethod.post:
          response = await dio.post(path, data: body, options: options);
          break;
        case _RestApiMethod.patch:
          response = await dio.patch(path, data: body, options: options);
          break;
        case _RestApiMethod.delete:
          response = await dio.delete(path, data: body, options: options);
          break;
      }

      _apiLog(
        path,
        apiVersion: apiVersion,
        apiMethod: apiMethod,
        body: body,
        header: response.requestOptions.headers,
        queryParameters: queryParameters,
        response: response,
      );
      return response;
    } on DioException catch (e) {
      ///if exception show the error
      if (e.error.toString().contains('FormatException')) {
        return Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          statusCode: 272,
          statusMessage: 'Success',
        );
      }

      Response<dynamic> response;
      if (e.response is Response<Map<String, dynamic>?>) {
        response = e.response as Response<Map<String, dynamic>?>;
      } else {
        final data = e.response?.data;
        response = Response<dynamic>(
          requestOptions: RequestOptions(path: path),
          statusCode: e.response?.statusCode ?? -101,
          statusMessage: (data is Map) ? data['message'].toString() : (e.message ?? 'Something went wrong..'),
        );
      }
      log('${e.error}', name: 'DIO EXCEPTION ERROR');
      log('${e.response?.data}', name: 'DIO EXCEPTION DATA');
      log('${e.stackTrace}', name: 'DIO EXCEPTION STACK');
      log('${e.response?.statusCode}', name: 'DIO EXCEPTION STATUS CODE');
      log('${e.response?.statusMessage}', name: 'DIO EXCEPTION message');
      _apiLog(
        path,
        apiVersion: apiVersion,
        apiMethod: apiMethod,
        body: body,
        header: e.response?.requestOptions.headers,
        queryParameters: queryParameters,
        response: e.response,
      );
      return response;
    }
  }

  @override
  Future<Response<dynamic>> delete(
    String path, {
    String apiVersion = '',
    String? baseUrl,
    required dynamic body,
    bool attachToken = true,
  }) {
    return _restApi(
      path,
      apiVersion: apiVersion,
      baseUrl: baseUrl,
      body: body,
      attachToken: attachToken,
      apiMethod: _RestApiMethod.delete,
    );
  }

  @override
  Future<Response<dynamic>> get(
    String path, {
    String apiVersion = '',
    String? baseUrl,
    bool attachToken = true,
    Map<String, dynamic>? queryParameters,
  }) {
    return _restApi(
      path,
      apiVersion: apiVersion,
      baseUrl: baseUrl,
      attachToken: attachToken,
      queryParameters: queryParameters,
      apiMethod: _RestApiMethod.get,
    );
  }

  @override
  Future<Response<dynamic>> patch(
    String path, {
    String apiVersion = '',
    String? baseUrl,
    required body,
    bool attachToken = true,
  }) {
    return _restApi(
      path,
      apiVersion: apiVersion,
      baseUrl: baseUrl,
      body: body,
      attachToken: attachToken,
      apiMethod: _RestApiMethod.patch,
    );
  }

  @override
  Future<Response<dynamic>> post(
    String path, {
    String apiVersion = '',
    String? baseUrl,
    required body,
    Map<String, dynamic>? header,
    bool attachToken = true,
    ResponseType? responseType,
  }) {
    return _restApi(
      path,
      apiVersion: apiVersion,
      baseUrl: baseUrl,
      header: header,
      body: body,
      attachToken: attachToken,
      responseType: responseType,
      apiMethod: _RestApiMethod.post,
    );
  }

  @override
  Future<Response<dynamic>> put(
    String path, {
    String apiVersion = '',
    String? baseUrl,
    required body,
    bool attachToken = true,
  }) {
    return _restApi(
      path,
      apiVersion: apiVersion,
      baseUrl: baseUrl,
      body: body,
      attachToken: attachToken,
      apiMethod: _RestApiMethod.put,
    );
  }
}

Future<Response<Map<String, dynamic>?>> simulateLocalResponse(Map<String, dynamic>? result,
    {bool isError = false}) async {
  await Future<void>.delayed(const Duration(seconds: 1));
  return Response<Map<String, dynamic>?>(
    requestOptions: RequestOptions(path: 'path'),
    data: result,
    statusCode: isError ? 502 : 200,
    statusMessage: isError ? 'error' : 'success',
  );
}
