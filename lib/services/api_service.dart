import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laci_mobile/services/location_service.dart';

class ApiService {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  ApiService()
      : dio = Dio(BaseOptions(
          baseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'x-client-device': 'Mobile',
          },
          validateStatus: (status) => true,
        )),
        secureStorage = const FlutterSecureStorage() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Extract token from secure storage and append to headers if available
          final token = await secureStorage.read(key: 'auth_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          final location = LocationService().currentLocation;
          if (location != null) {
            options.headers['x-user-location'] = location;
          }
          
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Handle global errors here (e.g., token expiration -> 401)
          return handler.next(e);
        },
      ),
    );
  }
}
