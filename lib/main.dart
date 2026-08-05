import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:laci_mobile/screens/login_screen.dart';
import 'package:laci_mobile/screens/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool('showHome') ?? false;

  runApp(
    ProviderScope(
      child: MyApp(showHome: showHome),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool showHome;
  const MyApp({super.key, required this.showHome});

  @override
  Widget build(BuildContext context) {
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
        home: showHome ? const LoginScreen() : const OnboardingScreen(),
      ),
    );
  }
}
