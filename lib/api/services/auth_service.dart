import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../dio_client.dart';
import '../models/user.dart';
import '../models/login_response.dart';

class AuthService {
  final Dio _dio = DioClient().dio;

  Future<LoginResponse> login(String code) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'code': code,
      });
      return LoginResponse.fromJson(response.data);
    } on DioException {
      rethrow;
    }
  }

  Future<User> getProfile() async {
    try {
      final response = await _dio.get('/auth/profile');
      if (kDebugMode) {
        print('Profile API Response: ${response.data}');
      }

      if (response.data['user'] == null) {
        throw Exception('User data is null in response');
      }

      final userData = response.data['user'] as Map<String, dynamic>;
      if (kDebugMode) {
        print('User data to parse: $userData');
      }

      return User.fromJson(userData);
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
}
