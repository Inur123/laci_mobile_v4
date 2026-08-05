import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laci_mobile/screens/anggota/tambah_anggota_screen.dart';
import 'package:laci_mobile/utils/app_colors.dart';

class AnggotaScreen extends StatefulWidget {
  const AnggotaScreen({super.key});

  @override
  State<AnggotaScreen> createState() => _AnggotaScreenState();
}

class _AnggotaScreenState extends State<AnggotaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text('Data Anggota', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.doc_on_clipboard, color: AppColors.textSecondary, size: 22),
            onPressed: () {
              _showSalinModal(context);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 4),
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TambahAnggotaScreen()));
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
                _buildStatCard('TOTAL ANGGOTA', '312', CupertinoIcons.person_2, Colors.blue),
                _buildStatCard('LAKI-LAKI (IPNU)', '113', CupertinoIcons.person, Colors.green),
                _buildStatCard('PEREMPUAN (IPPNU)', '199', CupertinoIcons.person, Colors.pink),
                _buildStatCard('MAKESTA', '116', CupertinoIcons.shield, Colors.blue),
                _buildStatCard('LAKMUD', '21', CupertinoIcons.shield_fill, Colors.indigo),
                _buildStatCard('LATIN', '2', CupertinoIcons.rosette, Colors.orange),
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
                        hintText: 'Cari nama, jabatan, NIK, NIA...',
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
                      // Filter modal
                    },
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, thickness: 1, color: Colors.black12),
          
          // LIST ANGGOTA
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              itemCount: 8,
              itemBuilder: (context, index) {
                return _buildAnggotaCard(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Container(
      width: 130,
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
              Expanded(child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary))),
              const SizedBox(width: 4),
              Icon(icon, size: 14, color: color),
            ],
          ),
          Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildAnggotaCard(int index) {
    // Dummy data variations
    final isLaki = index == 2 || index == 3;
    final nama = isLaki ? (index == 2 ? 'Dwi Agus Nur Cahyo' : 'Fauzan Nabil') : (index == 0 ? 'Chumaira Nurul Aini' : 'Desta Faizatus Zahra');
    final inisial = nama.split(' ').take(2).map((e) => e[0]).join();
    
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: isLaki ? Colors.green.shade100 : Colors.pink.shade100,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                inisial,
                style: TextStyle(
                  color: isLaki ? Colors.green.shade700 : Colors.pink.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Info Detail
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(CupertinoIcons.person_solid, size: 12, color: isLaki ? Colors.green : Colors.pink),
                    const SizedBox(width: 4),
                    Text(isLaki ? 'Laki-laki (IPNU)' : 'Perempuan (IPPNU)', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(CupertinoIcons.building_2_fill, size: 12, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    const Expanded(child: Text('PAC Ngariboyo', style: TextStyle(fontSize: 12, color: AppColors.textSecondary))),
                  ],
                ),
              ],
            ),
          ),
          
          // Menu 3 Titik
          PopupMenuButton<String>(
            icon: const Icon(CupertinoIcons.ellipsis, size: 20, color: AppColors.textSecondary),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.white,
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const TambahAnggotaScreen(isEdit: true)));
              } else if (value == 'hapus') {
                // delete dialog
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

  void _showSalinModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(CupertinoIcons.doc_on_clipboard_fill, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              const Text('Salin Anggota', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih periode asal dan salin anggota yang akan dilanjutkan ke periode saat ini.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 24),
              const Text('PILIH PERIODE ASAL', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
              const SizedBox(height: 8),
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Pilih periode...', style: TextStyle(color: AppColors.textSecondary)),
                    Icon(CupertinoIcons.chevron_down, size: 16, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade300,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Salin 0 Anggota', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
