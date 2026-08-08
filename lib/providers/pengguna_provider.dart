import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laci_mobile/models/user_model.dart';
import 'package:laci_mobile/services/user_service.dart';

final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

class PenggunaState {
  final bool isLoading;
  final bool isDetailLoading;
  final String? error;
  final List<UserModel> users;
  final UserStatsModel? stats;
  final UserDetailModel? currentDetail;

  PenggunaState({
    this.isLoading = false,
    this.isDetailLoading = false,
    this.error,
    this.users = const [],
    this.stats,
    this.currentDetail,
  });

  PenggunaState copyWith({
    bool? isLoading,
    bool? isDetailLoading,
    String? error,
    List<UserModel>? users,
    UserStatsModel? stats,
    UserDetailModel? currentDetail,
    bool clearError = false,
  }) {
    return PenggunaState(
      isLoading: isLoading ?? this.isLoading,
      isDetailLoading: isDetailLoading ?? this.isDetailLoading,
      error: clearError ? null : (error ?? this.error),
      users: users ?? this.users,
      stats: stats ?? this.stats,
      currentDetail: currentDetail ?? this.currentDetail,
    );
  }
}

class PenggunaNotifier extends StateNotifier<PenggunaState> {
  final UserService _userService;

  PenggunaNotifier(this._userService) : super(PenggunaState());

  Future<void> fetchData() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final stats = await _userService.getUsersStats();
      final users = await _userService.getUsers();
      state = state.copyWith(
        isLoading: false,
        stats: stats,
        users: users,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchDetail(String id) async {
    state = state.copyWith(isDetailLoading: true, clearError: true);
    try {
      final detail = await _userService.getUserDetail(id);
      state = state.copyWith(
        isDetailLoading: false,
        currentDetail: detail,
      );
    } catch (e) {
      state = state.copyWith(isDetailLoading: false, error: e.toString());
    }
  }

  Future<bool> updateUserStatus(String id, bool isActive) async {
    try {
      await _userService.updateUserStatus(id, isActive);
      // Update local state detail
      if (state.currentDetail?.user.id == id) {
        final updatedUser = UserModel(
          id: state.currentDetail!.user.id,
          name: state.currentDetail!.user.name,
          email: state.currentDetail!.user.email,
          role: state.currentDetail!.user.role,
          isActive: isActive,
          emailVerified: state.currentDetail!.user.emailVerified,
          image: state.currentDetail!.user.image,
          periodeAktifId: state.currentDetail!.user.periodeAktifId,
          createdAt: state.currentDetail!.user.createdAt,
          lastLogoutAt: state.currentDetail!.user.lastLogoutAt,
        );
        state = state.copyWith(
          currentDetail: UserDetailModel(
            user: updatedUser,
            statsAktivitas: state.currentDetail!.statsAktivitas,
            statsPendidikan: state.currentDetail!.statsPendidikan,
            statsPengkaderan: state.currentDetail!.statsPengkaderan,
          ),
        );
      }
      // Refresh list and stats
      fetchData();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> resetPassword(String id) async {
    try {
      await _userService.resetPassword(id);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> deleteUser(String id) async {
    try {
      await _userService.deleteUser(id);
      fetchData();
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

final penggunaProvider = StateNotifierProvider<PenggunaNotifier, PenggunaState>((ref) {
  return PenggunaNotifier(ref.watch(userServiceProvider));
});
