import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laci_mobile/utils/app_colors.dart';
import 'package:laci_mobile/models/activity_model.dart';
import 'package:laci_mobile/widgets/custom_refresh_control.dart';

class DetailRiwayatAktivitasScreen extends StatelessWidget {
  final ActivityModel data;
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
          icon: Icon(Icons.arrow_back_ios_new, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Log Aktivitas',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: [
          CustomRefreshControl(
            onRefresh: () async {
              // Dummy refresh for detail screen
              await Future.delayed(const Duration(milliseconds: 1500));
            },
            primaryColor: primaryColor,
          ),
          SliverToBoxAdapter(
            child: Padding(
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
          ),
        ],
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
              data.description,
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
                        Icon(Icons.local_offer, size: 12, color: AppColors.textSecondary),
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
                        data.module,
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
                        Icon(Icons.bolt, size: 12, color: AppColors.textSecondary),
                        SizedBox(width: 4),
                        Text('Jenis Aksi', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: data.actionColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        data.action,
                        style: TextStyle(color: data.actionColor, fontSize: 10, fontWeight: FontWeight.bold),
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
                        Icon(Icons.layers, size: 12, color: AppColors.textSecondary),
                        SizedBox(width: 4),
                        Text('Periode Aktif', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(data.periodeName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.description, size: 12, color: AppColors.textSecondary),
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
                      child: Text(
                        data.id.length > 15 
                          ? '${data.id.substring(0, 15)}...' 
                          : data.id,
                        style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontFamily: 'monospace'),
                      ),
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
            icon: Icons.person_outline,
            iconColor: Colors.blue,
            title: 'USER AKUN',
            subtitle: data.userName,
            subtitleBold: true,
          ),
          const Divider(height: 16),
          _buildListTile(
            icon: Icons.calendar_today,
            iconColor: Colors.green,
            title: 'TANGGAL KEJADIAN',
            subtitle: data.formattedDateOnly,
            subtitleBold: true,
          ),
          const Divider(height: 16),
          _buildListTile(
            icon: Icons.access_time,
            iconColor: Colors.orange,
            title: 'WAKTU PRESISI',
            subtitle: data.formattedTimeOnly,
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
            icon: Icons.wifi,
            iconColor: Colors.blue,
            title: 'ALAMAT IP',
            subtitleWidget: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: Colors.blue.withOpacity(0.05), borderRadius: BorderRadius.circular(4)),
              child: Text(data.ipAddress ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
            ),
          ),
          const Divider(height: 16),
          _buildListTile(
            icon: Icons.language,
            iconColor: Colors.green,
            title: 'BROWSER / KLIEN',
            subtitle: data.userAgent ?? 'Unknown Client',
            subtitleBold: true,
          ),
          const Divider(height: 16),
          _buildListTile(
            icon: Icons.desktop_windows,
            iconColor: Colors.orange,
            title: 'PERANGKAT',
            subtitle: data.device ?? 'Unknown Device',
            subtitleBold: true,
          ),
          const Divider(height: 16),
          _buildListTile(
            icon: Icons.location_on,
            iconColor: Colors.red,
            title: 'LOKASI PRESISI (GPS)',
            subtitle: data.location ?? 'Tidak ada data lokasi',
            subtitleBold: true,
            trailingWidget: const Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: Text(
                'Akurasi Tinggi',
                style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
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
