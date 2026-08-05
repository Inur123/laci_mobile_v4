import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laci_mobile/screens/arsip/detail_arsip_screen.dart';
import 'package:laci_mobile/screens/arsip/tambah_arsip_screen.dart';
import 'package:laci_mobile/utils/app_colors.dart';

class ArsipScreen extends StatefulWidget {
  const ArsipScreen({super.key});

  @override
  State<ArsipScreen> createState() => _ArsipScreenState();
}

class _ArsipScreenState extends State<ArsipScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text('Arsip Surat', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TambahArsipScreen()));
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              icon: const Icon(CupertinoIcons.add, size: 16, color: AppColors.primary),
              label: const Text('Tambah', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // STATISTIK HORIZONTAL
          Container(
            height: 110,
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildStatCard('TOTAL', '254', CupertinoIcons.doc_text, Colors.blue),
                _buildStatCard('MASUK', '131', CupertinoIcons.arrow_down_left, Colors.green),
                _buildStatCard('KELUAR', '123', CupertinoIcons.arrow_up_right, Colors.orange),
                _buildStatCard('IPNU', '40', CupertinoIcons.shield, Colors.teal),
                _buildStatCard('IPPNU', '77', CupertinoIcons.shield, Colors.teal),
              ],
            ),
          ),
          
          // SEARCH & FILTER
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.inputFill,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari nomor surat, perihal...',
                        hintStyle: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                        prefixIcon: Icon(CupertinoIcons.search, size: 18, color: AppColors.textSecondary),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppColors.inputFill,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: const Icon(CupertinoIcons.slider_horizontal_3, size: 18, color: AppColors.textPrimary),
                    onPressed: () {
                      _showFilterModal(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, thickness: 1, color: Colors.black12),
          
          // LIST SURAT
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return _buildSuratCard(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
              Icon(icon, size: 14, color: color),
            ],
          ),
          Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildSuratCard(int index) {
    // Dummy data variations
    final isMasuk = index % 2 == 0;
    final org = index % 3 == 0 ? 'IPPNU' : (index % 3 == 1 ? 'IPNU' : 'BERSAMA');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
          // Baris Atas: Badge & Menu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _buildBadge(org, org == 'IPPNU' ? Colors.pink : (org == 'IPNU' ? Colors.green : Colors.blue)),
                  const SizedBox(width: 8),
                  _buildBadge(isMasuk ? 'MASUK' : 'KELUAR', isMasuk ? Colors.indigo : Colors.orange),
                ],
              ),
              PopupMenuButton<String>(
                icon: const Icon(CupertinoIcons.ellipsis, size: 20, color: AppColors.textSecondary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Colors.white,
                onSelected: (value) {
                  if (value == 'lihat') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailArsipScreen()));
                  } else if (value == 'edit') {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const TambahArsipScreen(isEdit: true)));
                  } else if (value == 'hapus') {
                    _showDeleteDialog(context);
                  }
                },
                itemBuilder: (context) => [
                  _buildPopupMenuItem('lihat', CupertinoIcons.eye, 'Lihat Detail'),
                  _buildPopupMenuItem('edit', CupertinoIcons.pencil, 'Edit'),
                  _buildPopupMenuItem('hapus', CupertinoIcons.trash, 'Hapus', isDestructive: true),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Perihal
          Text(
            isMasuk ? 'Undangan Pra Rapimwil Jatim' : 'Instruksi Pelatihan Persidangan',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          
          // Info Detail
          Row(
            children: [
              const Icon(CupertinoIcons.number, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Expanded(child: Text('020/PW/A/7455/...', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(CupertinoIcons.calendar, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              const Expanded(child: Text('16 Juli 2026', style: TextStyle(fontSize: 12, color: AppColors.textSecondary))),
            ],
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, thickness: 1, color: Colors.black12),
          ),
          
          // Pengirim / Penerima
          Row(
            children: [
              Icon(isMasuk ? CupertinoIcons.person_crop_circle : CupertinoIcons.paperplane, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(isMasuk ? 'Dari: PW IPPNU Jatim' : 'Kepada: PC IPNU Magetan', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

  PopupMenuItem<String> _buildPopupMenuItem(String value, IconData icon, String text, {bool isDestructive = false}) {
    final color = isDestructive ? Colors.red : AppColors.textPrimary;
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(color: color, fontSize: 14, fontWeight: isDestructive ? FontWeight.bold : FontWeight.w500)),
        ],
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Filter Arsip', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 24),
              const Text('Organisasi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              // Dummy Dropdown Placeholder
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: AppColors.inputFill, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [Text('Semua Organisasi'), Icon(CupertinoIcons.chevron_down, size: 16)],
                ),
              ),
              const SizedBox(height: 16),
              const Text('Jenis Surat', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: AppColors.inputFill, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [Text('Semua Jenis'), Icon(CupertinoIcons.chevron_down, size: 16)],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Terapkan Filter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Hapus Arsip', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Apakah Anda yakin ingin menghapus arsip surat ini? Data yang sudah dihapus tidak dapat dikembalikan.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                // Tampilkan pesan sukses sementara
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Arsip berhasil dihapus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.only(bottom: 90, left: 16, right: 16),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Hapus', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
