import 'package:dio/dio.dart';
import 'package:laci_mobile/models/periode_model.dart';
import 'package:laci_mobile/services/api_service.dart';

class PeriodeService {
  final ApiService _apiService = ApiService();

  Future<List<Periode>> getPeriodes() async {
    try {
      final response = await _apiService.dio.get('/periodes');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final list = response.data['data'] as List? ?? [];
        return list.map((item) => Periode.fromJson(item)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Gagal memuat data periode');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Gagal memuat data periode');
      }
      throw Exception('Terjadi kesalahan jaringan');
    }
  }

  Future<Periode> createPeriode(String nama) async {
    try {
      final response = await _apiService.dio.post('/periodes', data: {'nama': nama});

      if (response.statusCode == 201 && response.data['success'] == true) {
        return Periode.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Gagal membuat periode');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Gagal membuat periode');
      }
      throw Exception('Terjadi kesalahan jaringan');
    }
  }

  Future<Periode> updatePeriode(String id, String nama) async {
    try {
      final response = await _apiService.dio.patch('/periodes/$id', data: {'nama': nama});

      if (response.statusCode == 200 && response.data['success'] == true) {
        return Periode.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Gagal memperbarui periode');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Gagal memperbarui periode');
      }
      throw Exception('Terjadi kesalahan jaringan');
    }
  }

  Future<void> activatePeriode(String id) async {
    try {
      final response = await _apiService.dio.patch('/periodes/$id/activate');

      if (response.statusCode != 200 || response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Gagal mengaktifkan periode');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Gagal mengaktifkan periode');
      }
      throw Exception('Terjadi kesalahan jaringan');
    }
  }

  Future<void> deletePeriode(String id) async {
    try {
      final response = await _apiService.dio.delete('/periodes/$id');

      if (response.statusCode != 200 || response.data['success'] != true) {
        throw Exception(response.data['message'] ?? 'Gagal menghapus periode');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Gagal menghapus periode');
      }
      throw Exception('Terjadi kesalahan jaringan');
    }
  }
}
