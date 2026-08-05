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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: (isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detail Berkas SP', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.pencil_circle_fill, color: Colors.blue),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const FormSpScreen(isEdit: true)));
            },
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.trash_circle_fill, color: Colors.red),
            onPressed: () {
              // Show Delete Dialog
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.black.withOpacity(0.05), height: 1.0),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: [
          // Info Berkas
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withOpacity(0.05)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Informasi Berkas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Organisasi', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: Colors.pink.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                            child: const Text('IPPNU', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.pink)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Nama Pimpinan / Pengaju', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          const Text('PAC IPPNU Karas', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tanggal Mulai', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          const Text('Jumat, 8 Mei 2026', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Tanggal Berakhir', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Expanded(child: Text('Senin, 23 Agustus 2027', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: Colors.green.shade50, border: Border.all(color: Colors.green.shade200), borderRadius: BorderRadius.circular(8)),
                                child: const Text('Aktif', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.green)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Periode', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          const Text('2025-2027', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Catatan', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          const Text('-', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // File Lampiran & Preview
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withOpacity(0.05)),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('File Lampiran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(CupertinoIcons.doc_fill, color: Colors.blueGrey, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Berkas SP (Terenkripsi)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text('1.2 MB', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(CupertinoIcons.cloud_download, color: (isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary)),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                Row(
                  children: [
                    Icon(CupertinoIcons.doc_text_viewfinder, size: 16, color: (isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary)),
                    SizedBox(width: 8),
                    Text('Pratinjau PDF', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: (isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary))),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 400,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.doc_plaintext, color: Colors.white54, size: 48),
                        SizedBox(height: 16),
                        Text('PDF Preview Placeholder', style: TextStyle(color: Colors.white)),
                        Text('Menampilkan dokumen SP PDF', style: TextStyle(color: Colors.white54, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
