import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laci_mobile/screens/anggota/anggota_screen.dart';
import 'package:laci_mobile/screens/arsip/arsip_screen.dart';
import 'package:laci_mobile/screens/home_screen.dart';
import 'package:laci_mobile/screens/pengajuan/pengajuan_screen.dart';
import 'package:laci_mobile/screens/profile_screen.dart';
import 'package:laci_mobile/utils/app_colors.dart';

class MainScreen extends StatefulWidget {
  final bool isCabang;
  
  const MainScreen({super.key, this.isCabang = true});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(isCabang: widget.isCabang),
      ArsipScreen(isCabang: widget.isCabang),
      PengajuanScreen(isCabang: widget.isCabang),
      AnggotaScreen(isCabang: widget.isCabang),
      ProfileScreen(isCabang: widget.isCabang),
    ];
  }

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
            backgroundColor: widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary,
            elevation: 2,
            shape: const CircleBorder(),
            child: const Icon(Icons.description, color: Colors.white, size: 28),
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
            Expanded(child: _buildNavItem(Icons.home, 'Beranda', 0)),
            Expanded(child: _buildNavItem(Icons.folder, 'Arsip', 1)),
            const Expanded(child: SizedBox()), // Ruang kosong untuk FAB
            Expanded(child: _buildNavItem(Icons.people_outline, 'Anggota', 3)),
            Expanded(child: _buildNavItem(Icons.account_circle, 'Profil', 4)),
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
            color: isSelected ? (widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary) : AppColors.textSecondary,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? (widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary) : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
