import 'package:dio/dio.dart';
import 'package:groovy_inventory/app/constants/app_constants.dart';
import 'package:groovy_inventory/core/network/api_response.dart';
import 'package:groovy_inventory/core/utils/app_logger.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._();
  static ApiClient get instance => _instance;

  late final Dio _dio;

  String? _token;

  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          log.d('${options.method} ${options.path}');
          handler.next(options);
        },
        onError: (error, handler) {
          log.e('API Error: ${error.message}', error);
          handler.next(error);
        },
      ),
    );
  }

  void setToken(String? token) => _token = token;

  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromData,
  }) async {
    return _request(
      () => _dio.get(path, queryParameters: queryParameters),
      fromData: fromData,
    );
  }

  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? fromData,
  }) async {
    return _request(
      () => _dio.post(path, data: data),
      fromData: fromData,
    );
  }

  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? fromData,
  }) async {
    return _request(
      () => _dio.put(path, data: data),
      fromData: fromData,
    );
  }

  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? fromData,
  }) async {
    return _request(
      () => _dio.patch(path, data: data),
      fromData: fromData,
    );
  }

  Future<ApiResponse<T>> delete<T>(
    String path, {
    T Function(dynamic)? fromData,
  }) async {
    return _request(
      () => _dio.delete(path),
      fromData: fromData,
    );
  }

  Future<ApiResponse<T>> _request<T>(
    Future<Response> Function() request, {
    T Function(dynamic)? fromData,
  }) async {
    try {
      final response = await request();
      return ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        fromData,
      );
    } on DioException catch (e) {
      if (e.response?.data is Map<String, dynamic>) {
        return ApiResponse.fromJson(
          e.response!.data as Map<String, dynamic>,
          fromData,
        );
      }
      return ApiResponse(
        success: false,
        message: e.message ?? 'Something went wrong',
      );
    }
  }
}

final api = ApiClient.instance;
