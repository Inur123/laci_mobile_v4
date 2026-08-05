import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laci_mobile/screens/login_screen.dart';
import 'package:laci_mobile/utils/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pengaturan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 32),
              
              _buildSectionTitle('Sistem & Administrasi'),
              _buildListTile(CupertinoIcons.person_3, 'Manajemen User'),
              _buildListTile(CupertinoIcons.time, 'Periode'),
              _buildListTile(CupertinoIcons.clock, 'Riwayat Aktivitas'),
              _buildListTile(CupertinoIcons.mail, 'Log Email'),
              _buildListTile(CupertinoIcons.cloud_download, 'Backup Database'),
              
              const SizedBox(height: 32),
              
              _buildSectionTitle('Akun'),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(CupertinoIcons.square_arrow_right, color: Colors.red, size: 20),
                ),
                title: const Text(
                  'Keluar',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
                ),
                onTap: () async {
                  // Logout action
                  final prefs = await SharedPreferences.getInstance();
                  // Di aplikasi nyata, kita hapus token dsb. Untuk sekarang kita pastikan kembali ke Login
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      ),
      trailing: const Icon(CupertinoIcons.chevron_right, size: 16, color: Colors.black26),
      onTap: () {},
    );
  }
}
