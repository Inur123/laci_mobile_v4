import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laci_mobile/utils/app_colors.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:toastification/toastification.dart';

class BackupDatabaseScreen extends StatefulWidget {
  final bool isCabang;
  const BackupDatabaseScreen({super.key, this.isCabang = true});

  @override
  State<BackupDatabaseScreen> createState() => _BackupDatabaseScreenState();
}

class _BackupDatabaseScreenState extends State<BackupDatabaseScreen> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary;

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
          'Backup Database',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Penyimpanan Card
            _buildStatusCard(primaryColor),
            const SizedBox(height: 24),
            
            // List Backup Files
            _buildBackupList(primaryColor),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status Penyimpanan R2',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          const Text(
            'Batas maksimal penyimpanan adalah 10 file backup.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Kapasitas Digunakan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              Text('9 dari 10 Backup', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor)),
            ],
          ),
          const SizedBox(height: 8),
          
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.9,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
          const SizedBox(height: 24),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _showBackupConfirmationDialog();
              },
              icon: const Icon(Icons.inbox, size: 18, color: Colors.white),
              label: const Text('Mulai Backup Database', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackupList(Color primaryColor) {
    final backups = [
      {'nama': 'laci_db_2026-08-02_000001.sql.gz', 'waktu': '2 Agustus 2026 | 00:00:03', 'ukuran': '409.54 KB'},
      {'nama': 'laci_db_2026-07-26_000001.sql.gz', 'waktu': '26 Juli 2026 | 00:00:03', 'ukuran': '400.68 KB'},
      {'nama': 'laci_db_2026-07-19_000001.sql.gz', 'waktu': '19 Juli 2026 | 00:00:03', 'ukuran': '397.98 KB'},
      {'nama': 'laci_db_2026-07-12_000001.sql.gz', 'waktu': '12 Juli 2026 | 00:00:03', 'ukuran': '391.73 KB'},
      {'nama': 'laci_db_2026-07-05_000001.sql.gz', 'waktu': '5 Juli 2026 | 00:00:03', 'ukuran': '375.5 KB'},
      {'nama': 'laci_db_2026-06-28_000001.sql.gz', 'waktu': '28 Juni 2026 | 00:00:03', 'ukuran': '368.12 KB'},
      {'nama': 'laci_db_2026-06-21_000001.sql.gz', 'waktu': '21 Juni 2026 | 00:00:02', 'ukuran': '365.66 KB'},
      {'nama': 'laci_db_2026-06-14_000001.sql.gz', 'waktu': '14 Juni 2026 | 00:00:02', 'ukuran': '344.02 KB'},
      {'nama': 'laci_db_2026-06-07_000001.sql.gz', 'waktu': '7 Juni 2026 | 00:00:03', 'ukuran': '316.25 KB'},
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: backups.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = backups[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header File Name
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.description, color: primaryColor, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['nama'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 12, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              item['waktu'] as String,
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, thickness: 1, color: Colors.black12),
              const SizedBox(height: 12),
              
              // Footer Ukuran & Aksi
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Ukuran: ${item['ukuran']}',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Icon(Icons.cloud_download, size: 20, color: primaryColor),
                        ),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () {
                          _showDeleteConfirmationDialog(item['nama'] as String);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBackupConfirmationDialog() async {
    final result = await showOkCancelAlertDialog(
      context: context,
      title: 'Mulai Backup Database',
      message: 'Apakah Anda yakin ingin memulai proses backup database sekarang? Proses ini mungkin memakan waktu beberapa saat.',
      okLabel: 'Mulai Backup',
      cancelLabel: 'Batal',
    );

    if (result == OkCancelResult.ok) {
      if (context.mounted) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          title: const Text('Proses backup berhasil dimulai!'),
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    }
  }

  void _showDeleteConfirmationDialog(String fileName) async {
    final result = await showOkCancelAlertDialog(
      context: context,
      title: 'Hapus File Backup',
      message: 'Apakah Anda yakin ingin menghapus file backup "$fileName"? Data yang sudah dihapus tidak dapat dikembalikan.',
      okLabel: 'Hapus',
      cancelLabel: 'Batal',
      isDestructiveAction: true,
    );

    if (result == OkCancelResult.ok) {
      if (context.mounted) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          title: const Text('File backup berhasil dihapus'),
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    }
  }
}
