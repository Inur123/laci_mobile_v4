import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class AuthState {
  final bool isInitializing;
  final bool isLoading;
  final bool isAuthenticated;
  final Map<String, dynamic>? user;
  final String? errorMessage;

  AuthState({
    this.isInitializing = true,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isInitializing,
    bool? isLoading,
    bool? isAuthenticated,
    Map<String, dynamic>? user,
    String? errorMessage,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      isInitializing: isInitializing ?? this.isInitializing,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState());

  Future<void> checkInitialAuth() async {
    state = state.copyWith(isInitializing: true);
    
    final token = await _authService.getToken();
    if (token != null && token.isNotEmpty) {
      final user = await _authService.getSession();
      if (user != null) {
        state = state.copyWith(isInitializing: false, isAuthenticated: true, user: user);
        return;
      }
    }
    
    state = state.copyWith(isInitializing: false, isAuthenticated: false);
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final result = await _authService.signInWithEmail(email, password);
    
    if (result['success'] == true) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: result['user'],
        clearError: true,
      );
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
        errorMessage: result['message'],
      );
      return false;
    }
  }
  Future<bool> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _authService.signUpWithEmail(name, email, password);

    if (result['success'] == true) {
      state = state.copyWith(isLoading: false, clearError: true);
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: result['message'],
      );
      return false;
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _authService.verifyEmailOtp(email, otp);

    if (result['success'] == true) {
      state = state.copyWith(isLoading: false, clearError: true);
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: result['message'],
      );
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _authService.signOut();
    state = state.copyWith(
      isLoading: false,
      isAuthenticated: false,
      clearUser: true,
      clearError: true,
    );
  }

  // ============================================
  // PROFILE UPDATE METHODS
  // ============================================

  Future<Map<String, dynamic>> updateProfile(String name) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _authService.updateName(name);

    if (result['success'] == true) {
      // Refresh user data from server
      final updatedUser = await _authService.getSession();
      state = state.copyWith(
        isLoading: false,
        user: updatedUser,
        clearError: true,
      );
    } else {
      state = state.copyWith(isLoading: false);
    }

    return result;
  }

  Future<Map<String, dynamic>> updatePassword(
      String currentPassword, String newPassword) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result =
        await _authService.updatePassword(currentPassword, newPassword);

    state = state.copyWith(isLoading: false);
    return result;
  }

  Future<Map<String, dynamic>> requestEmailChange(String newEmail) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _authService.requestEmailChange(newEmail);

    state = state.copyWith(isLoading: false);
    return result;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});
