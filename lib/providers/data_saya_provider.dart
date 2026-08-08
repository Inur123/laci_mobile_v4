import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laci_mobile/models/user_model.dart';
import 'package:laci_mobile/services/user_service.dart';
import 'package:laci_mobile/providers/auth_provider.dart';

class DataSayaState {
  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? stats;

  DataSayaState({
    this.isLoading = false,
    this.error,
    this.stats,
  });

  DataSayaState copyWith({
    bool? isLoading,
    String? error,
    Map<String, dynamic>? stats,
  }) {
    return DataSayaState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      stats: stats ?? this.stats,
    );
  }
}

class DataSayaNotifier extends StateNotifier<DataSayaState> {
  final Ref ref;
  DataSayaNotifier(this.ref) : super(DataSayaState());

  Future<void> fetchDataSaya() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = ref.read(authProvider).user;
      if (user == null || user['id'] == null) {
        state = state.copyWith(isLoading: false, error: 'User tidak ditemukan');
        return;
      }

      final data = await UserService().getMeStats();
      state = state.copyWith(isLoading: false, stats: data, error: null);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final dataSayaProvider =
    StateNotifierProvider<DataSayaNotifier, DataSayaState>((ref) {
  return DataSayaNotifier(ref);
});
