import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:two_factor_authentication/api/models/api_response.dart';
import '../dio_client.dart';
import '../models/user.dart';
import '../models/login_response.dart';

class AuthService {
  final Dio _dio = DioClient().dio;

  Future<LoginResponse> login(String code) async {
    try {
      if (kDebugMode) {
        print('[AuthService] 发送登录请求，code: $code');
      }
      final response = await _dio.post('/auth/wechat/login', data: {
        'code': code,
      });
      if (kDebugMode) {
        print('[AuthService] 登录响应状态: ${response.statusCode}');
        print('[AuthService] 登录响应数据: ${response.data}');
      }
      // 后端直接返回 LoginResponse，不是包装在 ApiResponse 中
      return LoginResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (kDebugMode) {
        print('[AuthService] 登录请求失败: ${e.message}');
        print('[AuthService] 错误响应: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<ApiResponse<User>> getProfile() async {
    try {
      final response = await _dio.get('/otp/auth/profile');
      if (kDebugMode) {
        print('Profile API Response: ${response.data}');
      }

      return ApiResponse.fromJson(
        response.data,
        (json) {
          final userData = (json as Map<String, dynamic>)['user'];
          if (userData == null) {
            throw Exception('User data is null in response');
          }
          return User.fromJson(userData as Map<String, dynamic>);
        },
      );
    } on DioException catch (e) {
      if (kDebugMode) {
        print('DioException in getProfile: $e');
        print('Response data: ${e.response?.data}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing user data: $e');
      }
      rethrow;
    }
  }

  Future<ApiResponse<ToggleSyncResponse>> toggleSync() async {
    try {
      final response = await _dio.post('/otp/auth/toggle-sync', data: {});
      return ApiResponse.fromJson(
        response.data,
        (json) => ToggleSyncResponse.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Failed to toggle sync: $e');
      }
      rethrow;
    }
  }
}
