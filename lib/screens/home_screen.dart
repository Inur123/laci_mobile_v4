import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laci_mobile/screens/pengajuan/pengajuan_screen.dart';
import 'package:laci_mobile/screens/agenda/agenda_screen.dart';
import 'package:laci_mobile/screens/pengguna/pengguna_screen.dart';
import 'package:laci_mobile/screens/presensi/presensi_screen.dart';
import 'package:laci_mobile/screens/lainnya_screen.dart';
import 'package:laci_mobile/utils/app_colors.dart';

class HomeScreen extends StatelessWidget {
  final bool isCabang;
  
  const HomeScreen({super.key, this.isCabang = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. PREMIUM GREEN HEADER
            Container(
              padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 40),
              decoration: BoxDecoration(
                color: isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hai, Pengurus!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Laci Cabang',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'CABANG',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white,
                      child: Icon(CupertinoIcons.person_solid, color: isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary, size: 30),
                    ),
                  ),
                ],
              ),
            ),

            // Transform up slightly to overlap the green header
            Transform.translate(
              offset: const Offset(0, -20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. GRID MENU
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Menu Utama',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 20),
                          GridView.count(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 4,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 8,
                            childAspectRatio: 0.8, // Fix for bottom overflow
                            children: [
                              _buildMenuButton(
                                CupertinoIcons.person_3_fill, 
                                'Pengguna', 
                                Colors.blue.shade100, 
                                Colors.blue.shade700,
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => PenggunaScreen(isCabang: isCabang)));
                                },
                              ),
                              _buildMenuButton(
                                CupertinoIcons.calendar_today, 
                                'Agenda', 
                                Colors.orange.shade100, 
                                Colors.orange.shade700,
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AgendaScreen(isCabang: isCabang)));
                                },
                              ),
                              _buildMenuButton(
                                CupertinoIcons.qrcode_viewfinder, 
                                'Presensi', 
                                Colors.green.shade100, 
                                Colors.green.shade700,
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => PresensiScreen(isCabang: isCabang)));
                                },
                              ),
                              _buildMenuButton(
                                CupertinoIcons.square_grid_2x2_fill, 
                                'Lainnya', 
                                Colors.purple.shade100, 
                                Colors.purple.shade700,
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => LainnyaScreen(isCabang: isCabang)));
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // 3. DASHBOARD WIDGET
                    const Text(
                      'Aktivitas Terbaru',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        children: [
                          Icon(CupertinoIcons.doc_text_search, size: 48, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          const Text(
                            'Belum ada aktivitas',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Aktivitas organisasi akan muncul di sini',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40), // Bottom padding for fab
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(IconData icon, String label, Color bgColor, Color iconColor, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
