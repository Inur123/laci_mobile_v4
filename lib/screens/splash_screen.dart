import 'package:flutter/material.dart';
import 'package:laci_mobile/screens/onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Center(
        // Dibuat statis tanpa animasi agar kembar identik 100% dengan Native Splash Screen
        // sehingga menghasilkan ilusi 1 layar yang tidak berubah
        child: Image.asset(
          'assets/images/logo.png',
          width: 300,
          height: 300,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
