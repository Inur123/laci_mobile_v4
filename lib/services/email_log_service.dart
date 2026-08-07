import 'package:dio/dio.dart';
import 'package:laci_mobile/models/email_log_model.dart';
import 'package:laci_mobile/services/api_service.dart';

class EmailLogService {
  final ApiService _apiService = ApiService();

  Future<EmailLogResponse> getEmailLogs({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    try {
      final response = await _apiService.dio.get(
        '/email-logs',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return EmailLogResponse.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load email logs');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Failed to load email logs');
      }
      throw Exception('Network error occurred');
    }
  }
}
