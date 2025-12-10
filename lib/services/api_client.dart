import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api_config.dart';

class ApiClient {
  static ApiClient? _instance;
  late final Dio _dio;
  String? _authToken;
  String? _baseUrl;

  static const _tokenKey = 'auth_token';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ApiClient._();

  static ApiClient get instance {
    _instance ??= ApiClient._();
    return _instance!;
  }

  Future<void> initialize() async {
    _baseUrl = await ApiConfig.resolveBaseUrl();

    if (kDebugMode) {
      print('=== API Client Initialization ===');
      print('Base URL: $_baseUrl');
      print('Environment: ${ApiConfig.isProduction ? "Production" : "Development"}');
    }

    // 保存されたトークンを読み込む
    _authToken = await _secureStorage.read(key: _tokenKey);
    if (kDebugMode && _authToken != null) {
      print('Loaded saved auth token');
    }

    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl!,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_authToken != null) {
            options.headers['Authorization'] = 'Token $_authToken';
          }
          if (kDebugMode) {
            print('API Request: ${options.method} ${options.uri}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('API Response: ${response.statusCode} ${response.requestOptions.uri}');
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            print('=== API Error ===');
            print('URL: ${error.requestOptions.uri}');
            print('Method: ${error.requestOptions.method}');
            print('Status Code: ${error.response?.statusCode}');
            print('Error Type: ${error.type}');
            print('Error Message: ${error.message}');
            print('Response Data: ${error.response?.data}');
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<void> setAuthToken(String? token) async {
    _authToken = token;
    if (token != null) {
      await _secureStorage.write(key: _tokenKey, value: token);
    } else {
      await _secureStorage.delete(key: _tokenKey);
    }
  }

  String? get authToken => _authToken;
  bool get isAuthenticated => _authToken != null;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
