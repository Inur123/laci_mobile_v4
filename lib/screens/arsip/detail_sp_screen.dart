import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laci_mobile/screens/arsip/form_sp_screen.dart';
import 'package:laci_mobile/utils/app_colors.dart';

class DetailSpScreen extends StatelessWidget {
  final bool isCabang;
  const DetailSpScreen({super.key, this.isCabang = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: (isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detail Berkas SP', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: (isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary)),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FormSpScreen(isEdit: true)));
            },
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.black.withOpacity(0.05), height: 1.0),
        ),
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
                _buildBadge('AKTIF', Colors.green),
              ],
            ),
            const SizedBox(height: 16),
            
            const Text(
              'PAC IPPNU Karas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary, height: 1.3),
            ),
            const SizedBox(height: 24),
            
            _buildDetailRow(Icons.calendar_today, 'Tanggal Mulai', 'Jumat, 8 Mei 2026'),
            const Divider(height: 24, thickness: 1, color: Colors.black12),
            _buildDetailRow(Icons.event, 'Tanggal Berakhir', 'Senin, 23 Agustus 2027'),
            const Divider(height: 24, thickness: 1, color: Colors.black12),
            _buildDetailRow(Icons.access_time, 'Periode', '2025-2027'),
            
            const SizedBox(height: 24),
            const Text('Catatan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            const Text(
              '-',
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
                    decoration: BoxDecoration(color: Colors.blueGrey.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.description, color: Colors.blueGrey, size: 24),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Berkas SP (Terenkripsi)', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        SizedBox(height: 4),
                        Text('1.2 MB', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.cloud_download, color: (isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary)),
                    onPressed: () {},
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            const Row(
              children: [
                Icon(Icons.manage_search, size: 16, color: Colors.blue),
                SizedBox(width: 8),
                Text('Pratinjau PDF', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue)),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 400,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock, color: Colors.white54, size: 40),
                    SizedBox(height: 12),
                    Text('Dokumen dilindungi kata sandi', style: TextStyle(color: Colors.white54)),
                  ],
                ),
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
