import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laci_mobile/screens/anggota/anggota_screen.dart';
import 'package:laci_mobile/screens/arsip/arsip_screen.dart';
import 'package:laci_mobile/screens/home_screen.dart';
import 'package:laci_mobile/screens/profile_screen.dart';
import 'package:laci_mobile/utils/app_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ArsipScreen(),
    const Center(child: Text('Pengajuan Berkas (Tengah)')),
    const AnggotaScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _screens[_selectedIndex],
      floatingActionButton: Transform.translate(
        offset: const Offset(0, 10), // Menurunkan tombol secara visual tanpa merusak layout menu bawah
        child: SizedBox(
          height: 56, // Ukuran standar
          width: 56,
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                _selectedIndex = 2; // Index for Pengajuan
              });
            },
            backgroundColor: AppColors.primary,
            elevation: 2,
            shape: const CircleBorder(),
            child: const Icon(CupertinoIcons.doc_text, color: Colors.white, size: 28),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        color: Colors.white,
        height: 60, // Membatasi tinggi maksimum agar tidak terlalu tebal
        padding: const EdgeInsets.symmetric(horizontal: 8), // Menghilangkan padding berlebih bawaan Material 3
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildNavItem(CupertinoIcons.home, 'Beranda', 0)),
            Expanded(child: _buildNavItem(CupertinoIcons.folder, 'Arsip', 1)),
            const Expanded(child: SizedBox()), // Ruang kosong untuk FAB
            Expanded(child: _buildNavItem(CupertinoIcons.person_2, 'Anggota', 3)),
            Expanded(child: _buildNavItem(CupertinoIcons.person_circle, 'Profil', 4)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
