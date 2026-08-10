import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laci_mobile/utils/app_colors.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:toastification/toastification.dart';
import 'package:shimmer/shimmer.dart';
import 'package:laci_mobile/providers/pengguna_provider.dart';
import 'package:laci_mobile/widgets/custom_refresh_control.dart';
import 'package:intl/intl.dart';

class DetailPenggunaScreen extends ConsumerStatefulWidget {
  final bool isCabang;
  final String userId;
  final String userName;
  final String initials;

  const DetailPenggunaScreen({
    super.key,
    required this.isCabang,
    required this.userId,
    required this.userName,
    required this.initials,
  });

  @override
  ConsumerState<DetailPenggunaScreen> createState() => _DetailPenggunaScreenState();
}

class _DetailPenggunaScreenState extends ConsumerState<DetailPenggunaScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(penggunaProvider.notifier).fetchDetail(widget.userId);
    });
  }
  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary;
    final state = ref.watch(penggunaProvider);
    final detail = state.currentDetail;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryColor),
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
      body: state.isDetailLoading || detail == null
          ? _buildShimmerLoading()
          : CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              slivers: [
                CustomRefreshControl(
                  onRefresh: () async => ref.read(penggunaProvider.notifier).fetchDetail(widget.userId),
                  primaryColor: primaryColor,
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
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
                  detail.user.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    detail.user.role == 'SEKRETARIS_PAC' ? 'SEKRETARIS PAC' : 'SEKRETARIS CABANG',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: detail.user.isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: detail.user.isActive ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3)),
                  ),
                  child: Text(
                    detail.user.isActive ? 'Aktif' : 'Nonaktif',
                    style: TextStyle(
                        fontSize: 12,
                        color: detail.user.isActive ? Colors.green.shade700 : Colors.red.shade700,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'ID USER: ${detail.user.id}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
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
          _buildSectionTitle(Icons.person_outline, 'Informasi Akun'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  'ALAMAT EMAIL',
                  detail.user.email,
                  badgeText: detail.user.emailVerified ? 'Terverifikasi' : 'Belum Verifikasi',
                  badgeColor: detail.user.emailVerified ? Colors.green : Colors.orange,
                  icon: Icons.mail,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCard(
                  'TANGGAL TERDAFTAR',
                  detail.user.createdAt != null ? DateFormat('dd MMM yyyy').format(detail.user.createdAt!) : '-',
                  icon: Icons.calendar_today,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Statistik Aktivitas
          _buildSectionTitle(Icons.timer, 'Statistik Aktivitas'),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.2,
            children: [
              _buildStatCard('PERIODE AKTIF', detail.user.periodeAktifName ?? 'Tidak Ada',
                  Icons.calendar_today, Colors.blue),
              _buildStatCard('ARSIP SURAT', '${detail.statsAktivitas['arsipSurat'] ?? 0} Surat', Icons.description,
                  Colors.green),
              _buildStatCard('PENGAJUAN PAC', '${detail.statsAktivitas['pengajuanPac'] ?? 0} Pengajuan',
                  Icons.assignment_ind, Colors.purple),
              _buildStatCard('DATA ANGGOTA', '${detail.statsAktivitas['dataAnggota'] ?? 0} Anggota',
                  Icons.people_outline, Colors.blue),
              _buildStatCard('BERKAS PIMPINAN', '${detail.statsAktivitas['berkasPimpinan'] ?? 0} Berkas',
                  Icons.folder, Colors.orange),
              _buildStatCard('RIWAYAT LOG', '${detail.statsAktivitas['riwayatLog'] ?? 0} Aktivitas',
                  Icons.access_time, Colors.red),
            ],
          ),

          const SizedBox(height: 32),

          // Statistik pengkaderan
          _buildSectionTitle(Icons.menu_book, 'Statistik pengkaderan'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ...detail.statsPengkaderan.map((p) => _buildSmallStatCard(p['namaPerkaderan'], '${p['count']} Anggota', Colors.blue)),
            ],
          ),

          const SizedBox(height: 32),

          // Statistik Pendidikan
          _buildSectionTitle(
              Icons.business, 'Statistik Pendidikan'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ...detail.statsPendidikan.map((p) => _buildSmallStatCard(p['jenjang'], '${p['count']} Orang', Colors.orange)),
            ],
          ),

          const SizedBox(height: 32),

          // Kontrol Keamanan & Status
          _buildSectionTitle(
              Icons.security, 'Kontrol Keamanan & Status',
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
                Icon(Icons.gpp_maybe,
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
                  onPressed: () => _showDeactivateDialog(context, detail.user.isActive),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: detail.user.isActive ? Colors.orange.shade300 : Colors.green.shade300),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    backgroundColor: Colors.white,
                  ),
                  child: Text(detail.user.isActive ? 'Nonaktifkan Akun' : 'Aktifkan Akun',
                      style: TextStyle(
                          color: detail.user.isActive ? Colors.orange.shade800 : Colors.green.shade800,
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
                    ]),
                  ),
                ),
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
                  Icon(Icons.gpp_good,
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
              Icon(Icons.square, size: 10, color: color),
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

  Future<void> _showDeactivateDialog(BuildContext context, bool currentStatus) async {
    final result = await showOkCancelAlertDialog(
      context: context,
      title: currentStatus ? 'Nonaktifkan Akun' : 'Aktifkan Akun',
      message: currentStatus 
          ? 'Apakah Anda yakin ingin menonaktifkan akun ini? Pengguna tidak akan bisa login sampai akun diaktifkan kembali.'
          : 'Apakah Anda yakin ingin mengaktifkan akun ini? Pengguna akan bisa login kembali.',
      okLabel: currentStatus ? 'Nonaktifkan' : 'Aktifkan',
      cancelLabel: 'Batal',
      isDestructiveAction: currentStatus,
    );
    if (result == OkCancelResult.ok && context.mounted) {
      final success = await ref.read(penggunaProvider.notifier).updateUserStatus(widget.userId, !currentStatus);
      if (success && context.mounted) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          showProgressBar: false,
          primaryColor: Colors.white,
          icon: Icon(Icons.check_circle_outline, color: currentStatus ? Colors.orange : Colors.green),
          title: Text(currentStatus ? 'Akun berhasil dinonaktifkan' : 'Akun berhasil diaktifkan'),
          alignment: Alignment.topCenter,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    }
  }

  Future<void> _showResetPasswordDialog(BuildContext context) async {
    final result = await showOkCancelAlertDialog(
      context: context,
      title: 'Reset Password',
      message:
          'Apakah Anda yakin ingin mengatur ulang password pengguna ini? Password akan direset ke default: password',
      okLabel: 'Reset',
      cancelLabel: 'Batal',
    );
    if (result == OkCancelResult.ok && context.mounted) {
      final success = await ref.read(penggunaProvider.notifier).resetPassword(widget.userId);
      if (success && context.mounted) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          showProgressBar: false,
          primaryColor: Colors.white,
          icon: const Icon(Icons.check_circle_outline, color: Colors.green),
          title: const Text('Password berhasil direset menjadi "password"'),
          alignment: Alignment.topCenter,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
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
      final success = await ref.read(penggunaProvider.notifier).deleteUser(widget.userId);
      if (success && context.mounted) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          showProgressBar: false,
          primaryColor: Colors.white,
          icon: const Icon(Icons.check_circle_outline, color: Colors.green),
          title: const Text('Akun berhasil dihapus permanen'),
          alignment: Alignment.topCenter,
          autoCloseDuration: const Duration(seconds: 3),
        );
        Navigator.pop(context); // Pop back to list after delete
      }
    }
  }

  Widget _buildShimmerLoading() {
    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // Shimmer Profile Section
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withOpacity(0.05)),
          ),
          child: Column(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(width: 100, height: 100, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
              ),
              const SizedBox(height: 16),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(width: 200, height: 24, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(width: 120, height: 20, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
              ),
              const SizedBox(height: 12),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(width: 80, height: 24, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Shimmer Cards (2 columns, multiple rows)
        Row(
          children: [
            Expanded(child: _buildShimmerCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildShimmerCard()),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildShimmerCard()),
            const SizedBox(width: 12),
            Expanded(child: _buildShimmerCard()),
          ],
        ),
        const SizedBox(height: 16),
        
        // Shimmer Action Buttons
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(width: double.infinity, height: 50, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
        ),
        const SizedBox(height: 12),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(width: double.infinity, height: 50, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
        ),
        const SizedBox(height: 12),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(width: double.infinity, height: 50, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
        ),
      ],
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
