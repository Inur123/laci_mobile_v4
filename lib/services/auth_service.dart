import 'package:dio/dio.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> signUpWithEmail(
      String name, String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        '/auth/sign-up/email',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return {
          'success': true,
          'user': response.data['user'],
        };
      } else {
        String err = response.data?['message'] ?? 'Pendaftaran gagal.';
        if (err.toLowerCase() == 'user already exists') {
          err = 'Email ini sudah terdaftar.';
        }
        return {
          'success': false,
          'message': err,
        };
      }
    } on DioException catch (e) {
      String message = 'Terjadi kesalahan jaringan.';
      if (e.response != null) {
        message = e.response?.data['message'] ?? 'Pendaftaran gagal.';
      }
      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> verifyEmailOtp(
      String email, String otp) async {
    try {
      final response = await _apiService.dio.post(
        '/auth/email-otp/verify-email',
        data: {
          'email': email,
          'otp': otp,
        },
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
        };
      } else {
        String err = response.data?['message'] ?? 'Kode OTP salah.';
        return {
          'success': false,
          'message': err,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal memverifikasi OTP.',
      };
    }
  }

  Future<Map<String, dynamic>> signInWithEmail(
      String email, String password) async {
    try {
      final response = await _apiService.dio.post(
        '/auth/sign-in/email',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final token = response.data['token'];
        final user = response.data['user'];

        if (token != null) {
          // Verify if user is active (ACC Cabang)
          if (user['isActive'] == false) {
            return {
              'success': false,
              'message': 'Akun Anda sedang menunggu persetujuan dari Admin Cabang.',
            };
          }

          await _apiService.secureStorage
              .write(key: 'auth_token', value: token);
        }

        return {
          'success': true,
          'user': user,
        };
      } else {
        String err = response.data?['message'] ?? 'Email atau password salah.';
        if (err.toLowerCase() == 'invalid email or password') {
          err = 'Email atau password salah.';
        } else if (err.toLowerCase().contains('email not verified')) {
          err = 'Email belum terverifikasi.';
        }
        return {
          'success': false,
          'message': err,
        };
      }
    } on DioException catch (e) {
      String message = 'Terjadi kesalahan jaringan.';
      if (e.response != null) {
        // Better Auth typically returns 400 or 401 on invalid credentials
        message = e.response?.data['message'] ?? 'Email atau password salah.';
      }
      return {
        'success': false,
        'message': message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  Future<void> signOut() async {
    try {
      // Optional: Hit logout endpoint if backend requires it
      await _apiService.dio.post('/auth/sign-out');
    } catch (e) {
      // Ignore errors on sign out, we just want to clear local data
    } finally {
      await _apiService.secureStorage.delete(key: 'auth_token');
    }
  }

  Future<String?> getToken() async {
    return await _apiService.secureStorage.read(key: 'auth_token');
  }

  Future<Map<String, dynamic>?> getSession() async {
    try {
      final response = await _apiService.dio.get('/auth/get-session');
      if (response.statusCode == 200 && response.data != null) {
        return response.data['user'];
      } else {
        await _apiService.secureStorage.delete(key: 'auth_token');
        return null;
      }
    } catch (e) {
      // Return null on failure (e.g. token expired/invalid)
      await _apiService.secureStorage.delete(key: 'auth_token');
      return null;
    }
  }

  // ============================================
  // PROFILE UPDATE METHODS
  // ============================================

  Future<Map<String, dynamic>> updateName(String name) async {
    try {
      final response = await _apiService.dio.put(
        '/me/profile',
        data: {'name': name},
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': response.data['message']};
      } else {
        return {
          'success': false,
          'message': response.data?['message'] ?? 'Gagal memperbarui nama.',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan.'};
    }
  }

  Future<Map<String, dynamic>> updatePassword(
      String currentPassword, String newPassword) async {
    try {
      final response = await _apiService.dio.put(
        '/me/password',
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': response.data['message']};
      } else {
        return {
          'success': false,
          'message':
              response.data?['message'] ?? 'Gagal memperbarui password.',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan.'};
    }
  }

  Future<Map<String, dynamic>> requestEmailChange(String newEmail) async {
    try {
      final response = await _apiService.dio.put(
        '/me/email',
        data: {'newEmail': newEmail},
        options: Options(
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': response.data['message']};
      } else {
        return {
          'success': false,
          'message':
              response.data?['message'] ?? 'Gagal mengirim verifikasi email.',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan jaringan.'};
    }
  }
}

