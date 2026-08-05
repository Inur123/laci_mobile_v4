import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laci_mobile/screens/main_screen.dart';
import 'package:laci_mobile/screens/register_screen.dart';
import 'package:laci_mobile/utils/app_colors.dart';
import 'package:laci_mobile/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _isCabang = true; // State untuk toggle Role

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Image.asset(
                    'assets/images/logo.png',
                    height: 80,
                  ),
                  const SizedBox(height: 24),
                  
                  // Welcome Text
                  const Text(
                    'Selamat Datang',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Masuk untuk mengelola administrasi IPNU IPPNU Anda.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Form Fields
                  const CustomTextField(
                    label: 'Email',
                    icon: CupertinoIcons.mail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  
                  CustomTextField(
                    label: 'Password',
                    icon: CupertinoIcons.lock,
                    isPassword: true,
                    obscureText: _obscurePassword,
                    onTogglePassword: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),

                  const SizedBox(height: 24),
                  
                  // Role Selector
                  const Text('Masuk Sebagai:', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _isCabang = true),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _isCabang ? AppColors.cabangPrimary.withOpacity(0.1) : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: _isCabang ? AppColors.cabangPrimary : Colors.black12, width: 2),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.building_2_fill, color: _isCabang ? AppColors.cabangPrimary : Colors.grey, size: 20),
                                const SizedBox(width: 8),
                                Text('Cabang', style: TextStyle(color: _isCabang ? AppColors.cabangPrimary : Colors.grey, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _isCabang = false),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !_isCabang ? AppColors.pacPrimary.withOpacity(0.1) : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: !_isCabang ? AppColors.pacPrimary : Colors.black12, width: 2),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(CupertinoIcons.person_3_fill, color: !_isCabang ? AppColors.pacPrimary : Colors.grey, size: 20),
                                const SizedBox(width: 8),
                                Text('PAC', style: TextStyle(color: !_isCabang ? AppColors.pacPrimary : Colors.grey, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Login Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen(isCabang: _isCabang)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  
                  // Divider
                  Row(
                    children: [
                      const Expanded(child: Divider(color: Colors.black12, thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Atau',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                        ),
                      ),
                      const Expanded(child: Divider(color: Colors.black12, thickness: 1)),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Google Login Button
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: Colors.black12, width: 1),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/google.png',
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Masuk dengan Google',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Bottom Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Belum punya akun?',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Daftar',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
