import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laci_mobile/utils/app_colors.dart';

class DetailRiwayatAktivitasScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isCabang;

  const DetailRiwayatAktivitasScreen({
    super.key,
    required this.data,
    this.isCabang = true,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary;

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
          icon: Icon(CupertinoIcons.back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Log Aktivitas',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInformasiAktivitas(primaryColor),
            const SizedBox(height: 16),
            _buildPelakuWaktu(primaryColor),
            const SizedBox(height: 16),
            _buildInformasiPerangkat(primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textSecondary, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: child,
    );
  }

  Widget _buildInformasiAktivitas(Color primaryColor) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('INFORMASI AKTIVITAS'),
          const Text('DESKRIPSI', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              data['aktivitas'] ?? '-',
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(CupertinoIcons.tag, size: 12, color: AppColors.textSecondary),
                        SizedBox(width: 4),
                        Text('Modul / Menu', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange.withOpacity(0.2)),
                      ),
                      child: Text(
                        data['modul'] ?? '-',
                        style: const TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(CupertinoIcons.bolt, size: 12, color: AppColors.textSecondary),
                        SizedBox(width: 4),
                        Text('Jenis Aksi', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: (data['entitasColor'] ?? Colors.blue).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        data['entitas'] ?? '-',
                        style: TextStyle(color: data['entitasColor'] ?? Colors.blue, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(CupertinoIcons.layers_alt, size: 12, color: AppColors.textSecondary),
                        SizedBox(width: 4),
                        Text('Periode Aktif', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text('2025-2027', style: TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(CupertinoIcons.doc_text, size: 12, color: AppColors.textSecondary),
                        SizedBox(width: 4),
                        Text('Log ID', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('cnqj7dxu70001wq...', style: TextStyle(fontSize: 10, color: AppColors.textSecondary, fontFamily: 'monospace')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPelakuWaktu(Color primaryColor) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('PELAKU & WAKTU'),
          _buildListTile(
            icon: CupertinoIcons.person,
            iconColor: Colors.blue,
            title: 'USER AKUN',
            subtitle: data['user'] ?? 'Sekretaris Cabang',
            subtitleBold: true,
          ),
          const Divider(height: 16),
          _buildListTile(
            icon: CupertinoIcons.calendar,
            iconColor: Colors.green,
            title: 'TANGGAL KEJADIAN',
            subtitle: (data['waktu'] as String).split(' - ')[0],
            subtitleBold: true,
          ),
          const Divider(height: 16),
          _buildListTile(
            icon: CupertinoIcons.clock,
            iconColor: Colors.orange,
            title: 'WAKTU PRESISI',
            subtitle: '${(data['waktu'] as String).split(' - ')[1]} WIB',
            subtitleBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInformasiPerangkat(Color primaryColor) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('INFORMASI PERANGKAT & JARINGAN'),
          _buildListTile(
            icon: CupertinoIcons.wifi,
            iconColor: Colors.blue,
            title: 'ALAMAT IP',
            subtitleWidget: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.05), borderRadius: BorderRadius.circular(4)),
              child: const Text('103.184.180.186', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
            ),
          ),
          const Divider(height: 16),
          _buildListTile(
            icon: CupertinoIcons.globe,
            iconColor: Colors.green,
            title: 'BROWSER',
            subtitle: 'Google Chrome',
            subtitleBold: true,
          ),
          const Divider(height: 16),
          _buildListTile(
            icon: CupertinoIcons.device_desktop,
            iconColor: Colors.orange,
            title: 'PERANGKAT',
            subtitle: 'Desktop - macOS',
            subtitleBold: true,
          ),
          const Divider(height: 16),
          _buildListTile(
            icon: CupertinoIcons.location_solid,
            iconColor: Colors.red,
            title: 'LOKASI',
            subtitle: 'Tambran, Kec. Magetan',
            subtitleBold: true,
            trailingWidget: const Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(
                'Kab. Magetan, Jawa Timur',
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 48, top: 4),
            child: GestureDetector(
              onTap: () {},
              child: const Row(
                children: [
                  Text('Lihat di Google Maps', style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold)),
                  SizedBox(width: 4),
                  Icon(CupertinoIcons.arrow_right, size: 10, color: Colors.red),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    bool subtitleBold = false,
    Widget? subtitleWidget,
    Widget? trailingWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                if (subtitleWidget != null) subtitleWidget,
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                      fontWeight: subtitleBold ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                if (trailingWidget != null) trailingWidget,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
