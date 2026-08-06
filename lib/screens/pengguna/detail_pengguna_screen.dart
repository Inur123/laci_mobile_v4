import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laci_mobile/utils/app_colors.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:toastification/toastification.dart';

class DetailPenggunaScreen extends StatefulWidget {
  final bool isCabang;
  final String userName;
  final String initials;

  const DetailPenggunaScreen({
    super.key,
    required this.isCabang,
    required this.userName,
    required this.initials,
  });

  @override
  State<DetailPenggunaScreen> createState() => _DetailPenggunaScreenState();
}

class _DetailPenggunaScreenState extends State<DetailPenggunaScreen> {
  @override
  Widget build(BuildContext context) {
    final primaryColor =
        widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Pengguna',
          style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 16),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.black.withOpacity(0.05), height: 1.0),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: [
          // Profile Section
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withOpacity(0.05)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green.shade200, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      widget.initials,
                      style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 36),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.userName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'SEKRETARIS PAC',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Text(
                    'Aktif',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'ID USER: RXUL4CV389HM5OZ\nYBK5DGDOM15U4KD5A',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                      letterSpacing: 1.5,
                      height: 1.5),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Informasi Akun
          _buildSectionTitle(CupertinoIcons.person, 'Informasi Akun'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  'ALAMAT EMAIL',
                  'ipnuippnubarat@gmail.com',
                  badgeText: 'Terverifikasi',
                  badgeColor: Colors.green,
                  icon: CupertinoIcons.mail,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCard(
                  'TANGGAL TERDAFTAR',
                  '24 Mei 2026',
                  icon: CupertinoIcons.calendar,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Statistik Aktivitas
          _buildSectionTitle(CupertinoIcons.timer, 'Statistik Aktivitas'),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.2,
            children: [
              _buildStatCard('PERIODE AKTIF', '2025-2027',
                  CupertinoIcons.calendar, Colors.blue),
              _buildStatCard('ARSIP SURAT', '0 Surat', CupertinoIcons.doc_text,
                  Colors.green),
              _buildStatCard('PENGAJUAN PAC', '6 Pengajuan',
                  CupertinoIcons.doc_person, Colors.purple),
              _buildStatCard('DATA ANGGOTA', '0 Anggota',
                  CupertinoIcons.person_2, Colors.blue),
              _buildStatCard('BERKAS PIMPINAN', '0 Berkas',
                  CupertinoIcons.folder, Colors.orange),
              _buildStatCard('RIWAYAT LOG', '14 Aktivitas',
                  CupertinoIcons.clock, Colors.red),
            ],
          ),

          const SizedBox(height: 32),

          // Statistik pengkaderan
          _buildSectionTitle(CupertinoIcons.book, 'Statistik pengkaderan'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildSmallStatCard('MAKESTA', '0 Anggota', Colors.purple),
              _buildSmallStatCard('LAKMUD', '0 Anggota', Colors.green),
              _buildSmallStatCard('LATIN', '0 Anggota', Colors.blue),
              _buildSmallStatCard('LATPEL', '0 Anggota', Colors.teal),
              _buildSmallStatCard('LAKUT', '0 Anggota', Colors.indigo),
              _buildSmallStatCard('DIKLATAMA', '0 Anggota', Colors.orange),
              _buildSmallStatCard('DIKLATMAD', '0 Anggota', Colors.red),
            ],
          ),

          const SizedBox(height: 32),

          // Statistik Pendidikan
          _buildSectionTitle(
              CupertinoIcons.building_2_fill, 'Statistik Pendidikan'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildSmallStatCard('SD', '0', Colors.grey),
              _buildSmallStatCard('MI', '0', Colors.lightBlue),
              _buildSmallStatCard('SMP', '0', Colors.orange),
              _buildSmallStatCard('MTS', '0', Colors.orangeAccent),
              _buildSmallStatCard('SMA', '0', Colors.green),
              _buildSmallStatCard('SMK', '0', Colors.teal),
              _buildSmallStatCard('MA', '0', Colors.cyan),
              _buildSmallStatCard('KULIAH', '0', Colors.purple),
            ],
          ),

          const SizedBox(height: 32),

          // Kontrol Keamanan & Status
          _buildSectionTitle(
              CupertinoIcons.shield_lefthalf_fill, 'Kontrol Keamanan & Status',
              color: Colors.blue.shade700),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(CupertinoIcons.exclamationmark_shield_fill,
                    color: Colors.orange.shade700, size: 20),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Aksi Administratif',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.textPrimary)),
                      SizedBox(height: 4),
                      Text(
                          'Sebagai Sekretaris Cabang, Anda memiliki wewenang penuh untuk mengelola akses pengguna ini ke dalam sistem Laci.',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showDeactivateDialog(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.orange.shade300),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    backgroundColor: Colors.white,
                  ),
                  child: Text('Nonaktifkan Akun',
                      style: TextStyle(
                          color: Colors.orange.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showResetPasswordDialog(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text('Reset Password',
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => _showDeleteDialog(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.red.shade300),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              backgroundColor: Colors.red.withOpacity(0.02),
            ),
            child: Text('Hapus Akun Secara Permanen',
                style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              '* Perhatian: Menghapus akun akan menghilangkan seluruh data terkait user ini dari database.',
              style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title,
      {Color color = AppColors.textPrimary}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(title,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value,
      {String? badgeText, Color? badgeColor, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Expanded(
                  child: Text(label,
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          if (badgeText != null && badgeColor != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: badgeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: badgeColor.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(CupertinoIcons.checkmark_shield_fill,
                      size: 12, color: badgeColor),
                  const SizedBox(width: 4),
                  Text(badgeText,
                      style: TextStyle(
                          fontSize: 10,
                          color: badgeColor,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Expanded(
                  child: Text(label,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: color),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildSmallStatCard(String label, String value, Color color) {
    return Container(
      width: (MediaQuery.of(context).size.width - 32 - 12 - 12) /
          3, // 3 items per row roughly
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.square_fill, size: 10, color: color),
              const SizedBox(width: 4),
              Text(label,
                  style: TextStyle(
                      fontSize: 10, fontWeight: FontWeight.bold, color: color),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Future<void> _showDeactivateDialog(BuildContext context) async {
    final result = await showOkCancelAlertDialog(
      context: context,
      title: 'Nonaktifkan Akun',
      message:
          'Apakah Anda yakin ingin menonaktifkan akun ini? Pengguna tidak akan bisa login sampai akun diaktifkan kembali.',
      okLabel: 'Nonaktifkan',
      cancelLabel: 'Batal',
      isDestructiveAction: true,
    );
    if (result == OkCancelResult.ok && context.mounted) {
      toastification.show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.flat,
        showProgressBar: false,
        primaryColor: Colors.white,
        icon: const Icon(Icons.check_circle_outline, color: Colors.orange),
        title: const Text('Akun berhasil dinonaktifkan'),
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> _showResetPasswordDialog(BuildContext context) async {
    final result = await showOkCancelAlertDialog(
      context: context,
      title: 'Reset Password',
      message:
          'Apakah Anda yakin ingin mengatur ulang password pengguna ini? Password akan direset ke default: pcippnumagetan',
      okLabel: 'Reset',
      cancelLabel: 'Batal',
    );
    if (result == OkCancelResult.ok && context.mounted) {
      toastification.show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.flat,
        showProgressBar: false,
        primaryColor: Colors.white,
        icon: const Icon(Icons.check_circle_outline, color: Colors.green),
        title: const Text('Password berhasil direset'),
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final result = await showOkCancelAlertDialog(
      context: context,
      title: 'Hapus Akun',
      message:
          'Apakah Anda yakin ingin menghapus akun ini secara permanen? Data yang sudah dihapus tidak dapat dikembalikan.',
      okLabel: 'Hapus',
      cancelLabel: 'Batal',
      isDestructiveAction: true,
    );
    if (result == OkCancelResult.ok && context.mounted) {
      toastification.show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.flat,
        showProgressBar: false,
        primaryColor: Colors.white,
        icon: const Icon(Icons.check_circle_outline, color: Colors.green),
        title: const Text('Akun berhasil dihapus'),
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 3),
      );
      Navigator.pop(context); // Pop back to list after delete
    }
  }
}
