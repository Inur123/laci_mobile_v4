import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laci_mobile/models/dashboard_monitoring_model.dart';
import 'package:laci_mobile/services/api_service.dart';
import 'package:dio/dio.dart';

class DashboardMonitoringState {
  final bool isLoading;
  final String? error;
  final DashboardMonitoringModel? data;

  DashboardMonitoringState({
    this.isLoading = false,
    this.error,
    this.data,
  });

  DashboardMonitoringState copyWith({
    bool? isLoading,
    String? error,
    DashboardMonitoringModel? data,
  }) {
    return DashboardMonitoringState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      data: data ?? this.data,
    );
  }
}

class DashboardMonitoringNotifier extends StateNotifier<DashboardMonitoringState> {
  DashboardMonitoringNotifier() : super(DashboardMonitoringState());

  Future<void> fetchMonitoringStats() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final ApiService apiService = ApiService();
      final response = await apiService.dio.get('/dashboard/monitoring');
      
      if (response.data['success']) {
        final data = DashboardMonitoringModel.fromJson(response.data['data']);
        state = state.copyWith(isLoading: false, data: data, error: null);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.data['message'] ?? 'Gagal memuat data',
        );
      }
    } on DioException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.response?.data['message'] ?? e.message ?? 'Terjadi kesalahan jaringan',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final dashboardMonitoringProvider =
    StateNotifierProvider<DashboardMonitoringNotifier, DashboardMonitoringState>((ref) {
  return DashboardMonitoringNotifier();
});
