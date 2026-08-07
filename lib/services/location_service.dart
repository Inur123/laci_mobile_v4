import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/foundation.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  String? _cachedLocation;

  String? get currentLocation => _cachedLocation;

  Future<void> requireLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Layanan lokasi di HP Anda tidak aktif. Mohon nyalakan GPS.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Izin lokasi ditolak. Aplikasi ini mewajibkan akses lokasi.');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Izin lokasi ditolak secara permanen. Silakan buka Pengaturan HP Anda untuk mengizinkannya.');
    } 

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String locality = place.locality ?? place.subLocality ?? 'Unknown City';
        String adminArea = place.administrativeArea ?? 'Unknown Province';
        _cachedLocation = '$locality, $adminArea';
      } else {
        _cachedLocation = '${position.latitude}, ${position.longitude}';
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
      throw Exception('Gagal mendapatkan lokasi presisi. Pastikan sinyal GPS Anda baik.');
    }
  }
}
