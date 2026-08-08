import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:laci_mobile/screens/login_screen.dart';
import 'package:laci_mobile/screens/onboarding_screen.dart';
import 'package:laci_mobile/screens/main_screen.dart';
import 'package:laci_mobile/providers/auth_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laci_mobile/services/location_service.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  
  await dotenv.load(fileName: ".env");

  final prefs = await SharedPreferences.getInstance();
  
  // Deteksi jika ini adalah instalasi baru (atau setelah uninstall)
  final isFirstRun = prefs.getBool('isFirstRun') ?? true;
  if (isFirstRun) {
    const secureStorage = FlutterSecureStorage();
    await secureStorage.deleteAll(); // Hapus sisa token lama di Keychain iOS
    await prefs.setBool('isFirstRun', false);
  }

  final showHome = prefs.getBool('showHome') ?? false;

  final container = ProviderContainer();
  await container.read(authProvider.notifier).checkInitialAuth();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MyApp(showHome: showHome),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  final bool showHome;
  const MyApp({super.key, required this.showHome});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late final AppLinks _appLinks;
  late final Future<void> _locationFuture;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
    _locationFuture = LocationService().requireLocation();
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle incoming links while app is running
    _appLinks.uriLinkStream.listen((uri) {
      if (uri.scheme == 'lacimobile' && uri.host == 'profile') {
        // Refresh the user session when returning from email verification
        ref.read(authProvider.notifier).checkInitialAuth();
      }
    });

    // Handle deep link when app is launched from a link
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null && initialUri.scheme == 'lacimobile' && initialUri.host == 'profile') {
        // Add a slight delay to ensure the provider is ready
        Future.delayed(const Duration(milliseconds: 500), () {
          ref.read(authProvider.notifier).checkInitialAuth();
        });
      }
    } catch (e) {
      debugPrint("Failed to handle initial link: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return ToastificationWrapper(
      child: MaterialApp(
        title: 'Laci Mobile',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('id', 'ID'), // Bahasa Indonesia
        ],
        theme: ThemeData(
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ),
          dialogTheme: const DialogTheme(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
          ),
        ),
        home: _getHomeWidget(authState, widget.showHome),
      ),
    );
  }

  Widget _getHomeWidget(AuthState authState, bool showHome) {
    if (authState.isInitializing) {
      return const Scaffold(backgroundColor: Colors.white, body: SizedBox.shrink());
    }

    return FutureBuilder(
      future: _locationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(backgroundColor: Colors.white, body: SizedBox.shrink());
        }
        if (snapshot.hasError) {
          FlutterNativeSplash.remove();
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_off_rounded, size: 80, color: Colors.red),
                    const SizedBox(height: 24),
                    Text(
                      snapshot.error.toString().replaceAll('Exception: ', ''),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => setState(() {}),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Coba Lagi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }

        // App is ready, remove the native splash screen
        FlutterNativeSplash.remove();

        if (authState.isAuthenticated && authState.user != null) {
          final role = authState.user?['role'] as String? ?? '';
          final isCabang = role.contains('CABANG') || role == 'ADMIN_CABANG';
          return MainScreen(isCabang: isCabang);
        }

        return showHome ? const LoginScreen() : const OnboardingScreen();
      },
    );
  }
}

