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
}
