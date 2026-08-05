import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laci_mobile/utils/app_colors.dart';

class LainnyaScreen extends StatelessWidget {
  final bool isCabang;
  
  const LainnyaScreen({super.key, this.isCabang = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.black.withOpacity(0.05), height: 1.0),
        ),
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Menu Lainnya',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildMenuSection(
            context,
            'Administrasi & Sistem',
            [
              _buildMenuItem(
                icon: CupertinoIcons.calendar_badge_plus,
                color: Colors.blue,
                title: 'Periode',
                subtitle: 'Kelola data periode kepengurusan aktif',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: CupertinoIcons.clock_fill,
                color: Colors.orange,
                title: 'Riwayat Aktivitas',
                subtitle: 'Pantau log aktivitas pengguna aplikasi',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: CupertinoIcons.mail_solid,
                color: Colors.red.shade400,
                title: 'Log Email',
                subtitle: 'Cek riwayat pengiriman email sistem',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: CupertinoIcons.tray_arrow_down_fill,
                color: Colors.green,
                title: 'Backup Database',
                subtitle: 'Cadangkan atau pulihkan data sistem',
                isLast: true,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8, top: 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const Icon(CupertinoIcons.chevron_right, color: Colors.black26, size: 16),
              ],
            ),
          ),
          if (!isLast)
            Padding(
              padding: const EdgeInsets.only(left: 62),
              child: Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
            ),
        ],
      ),
    );
  }
}
