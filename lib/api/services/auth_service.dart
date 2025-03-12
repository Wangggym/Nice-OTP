import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:two_factor_authentication/api/models/api_response.dart';
import '../dio_client.dart';
import '../models/user.dart';
import '../models/login_response.dart';

class AuthService {
  final Dio _dio = DioClient().dio;

  Future<ApiResponse<LoginResponse>> login(String code) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'code': code,
      });
      return ApiResponse.fromJson(
        response.data,
        (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
      );
    } on DioException {
      rethrow;
    }
  }

  Future<ApiResponse<User>> getProfile() async {
    try {
      final response = await _dio.get('/auth/profile');
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
      final response = await _dio.post('/auth/toggle-sync', data: {});
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
