import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laci_mobile/utils/app_colors.dart';

class DetailArsipScreen extends StatelessWidget {
  const DetailArsipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          icon: const Icon(CupertinoIcons.back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detail Arsip', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.pencil, color: AppColors.primary),
            onPressed: () {
              // Bisa untuk shortcut edit
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildBadge('IPPNU', Colors.pink),
                const SizedBox(width: 8),
                _buildBadge('MASUK', Colors.indigo),
              ],
            ),
            const SizedBox(height: 16),
            
            const Text(
              'Undangan Pra Rapimwil Jatim',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary, height: 1.3),
            ),
            const SizedBox(height: 24),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildDetailRow(CupertinoIcons.number, 'Nomor Surat', '020/PW/A/7455/2026'),
                  const Divider(height: 24, thickness: 1, color: Colors.black12),
                  _buildDetailRow(CupertinoIcons.calendar, 'Tanggal', '16 Juli 2026'),
                  const Divider(height: 24, thickness: 1, color: Colors.black12),
                  _buildDetailRow(CupertinoIcons.person_2, 'Pengirim', 'PW IPPNU Jatim'),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            const Text('Deskripsi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            const Text(
              'Ini adalah teks deskripsi dummy. Mengharapkan kehadiran pengurus cabang dalam acara Pra Rapimwil yang akan diselenggarakan di Surabaya.',
              style: TextStyle(color: AppColors.textSecondary, height: 1.5),
            ),
            
            const SizedBox(height: 32),
            const Text('File Lampiran', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(CupertinoIcons.doc_fill, color: Colors.red, size: 24),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Undangan_Rapimwil.pdf', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        SizedBox(height: 4),
                        Text('2.4 MB', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(CupertinoIcons.cloud_download, color: AppColors.primary),
                    onPressed: () {},
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
