import 'package:dio/dio.dart';
import 'package:laci_mobile/models/activity_model.dart';
import 'package:laci_mobile/services/api_service.dart';

class ActivityService {
  final ApiService _apiService = ApiService();

  Future<ActivityResponse> getActivities({
    required String type, // 'personal' atau 'global'
    int page = 1,
    int limit = 50,
    String? search,
    String? module,
    String? action,
    String? userId,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'type': type,
        'page': page,
        'limit': limit,
      };

      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (module != null && module != 'Semua Modul') queryParams['module'] = module;
      if (action != null && action != 'Semua Entitas') queryParams['action'] = action;
      if (userId != null && userId != 'Semua User') queryParams['userId'] = userId;

      final response = await _apiService.dio.get(
        '/activities',
        queryParameters: queryParams,
      );
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        return ActivityResponse.fromJson(response.data);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load activities');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to load activities');
      }
      throw Exception('Terjadi kesalahan jaringan');
    }
  }
}
