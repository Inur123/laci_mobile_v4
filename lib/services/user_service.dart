import 'package:dio/dio.dart';
import 'package:laci_mobile/models/user_model.dart';
import 'package:laci_mobile/services/api_service.dart';

class UserService {
  final ApiService _apiService = ApiService();

  Future<List<UserModel>> getFilterOptions() async {
    try {
      final response = await _apiService.dio.get('/users/filter-options');
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load users');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to load users');
      }
      throw Exception('Terjadi kesalahan jaringan');
    }
  }

  Future<UserStatsModel> getUsersStats() async {
    try {
      final response = await _apiService.dio.get('/users/stats');
      if (response.statusCode == 200 && response.data['success'] == true) {
        return UserStatsModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load stats');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Terjadi kesalahan jaringan');
    }
  }

  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _apiService.dio.get('/users');
      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load users');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Terjadi kesalahan jaringan');
    }
  }

  Future<Map<String, dynamic>> getMeStats() async {
    try {
      final response = await _apiService.dio.get('/me/stats');
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data']['statsAktivitas'] ?? {};
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load user stats');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Terjadi kesalahan jaringan');
    }
  }

  Future<UserDetailModel> getUserDetail(String id) async {
    try {
      final response = await _apiService.dio.get('/users/$id/detail');
      if (response.statusCode == 200 && response.data['success'] == true) {
        return UserDetailModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load user detail');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Terjadi kesalahan jaringan');
    }
  }

  Future<String> updateUserStatus(String id, bool isActive) async {
    try {
      final response = await _apiService.dio.patch(
        '/users/$id/status',
        data: {'isActive': isActive},
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['message'] ?? 'Berhasil';
      } else {
        throw Exception(response.data['message'] ?? 'Failed to update status');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Terjadi kesalahan jaringan');
    }
  }

  Future<String> updateUserRole(String id, String role) async {
    try {
      final response = await _apiService.dio.patch(
        '/users/$id/role',
        data: {'role': role},
      );
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['message'] ?? 'Berhasil';
      } else {
        throw Exception(response.data['message'] ?? 'Failed to update role');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Terjadi kesalahan jaringan');
    }
  }

  Future<String> resetPassword(String id) async {
    try {
      final response = await _apiService.dio.post('/users/$id/reset-password');
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['message'] ?? 'Password berhasil di-reset';
      } else {
        throw Exception(response.data['message'] ?? 'Failed to reset password');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Terjadi kesalahan jaringan');
    }
  }

  Future<String> deleteUser(String id) async {
    try {
      final response = await _apiService.dio.delete('/users/$id');
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['message'] ?? 'Akun berhasil dihapus';
      } else {
        throw Exception(response.data['message'] ?? 'Failed to delete user');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Terjadi kesalahan jaringan');
    }
  }
}
