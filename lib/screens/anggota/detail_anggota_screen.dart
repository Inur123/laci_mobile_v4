import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laci_mobile/utils/app_colors.dart';
import 'package:laci_mobile/screens/anggota/form_anggota_screen.dart';

class DetailAnggotaScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isCabang;

  const DetailAnggotaScreen(
      {super.key, required this.data, this.isCabang = true});

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary;
    final isLaki = data['jenis_kelamin'] == 'Laki-laki';
    final themeColor = isLaki ? Colors.green : Colors.pink;

    // Inisial untuk Avatar
    final namaLengkap = data['nama'] ?? 'Tanpa Nama';
    final parts = namaLengkap.split(' ');
    final inisial = parts.length > 1
        ? '${parts[0][0]}${parts[1][0]}'
        : (parts.isNotEmpty ? '${parts[0][0]}' : 'U');

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
        title: const Text('Detail Anggota',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 16)),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.pencil, color: primaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FormAnggotaScreen(isEdit: true, isCabang: isCabang),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // PROFILE CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  // Avatar Besar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        CupertinoIcons.person_solid,
                        size: 40,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    namaLengkap,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: themeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isLaki ? 'IPNU' : 'IPPNU',
                      style: TextStyle(
                          color: themeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 1. INFORMASI PERSONAL
            _buildSection(
              title: 'Informasi Personal',
              icon: CupertinoIcons.person_alt,
              color: Colors.blue,
              children: [
                _buildInfoRow('Nama Lengkap', namaLengkap),
                _buildInfoRow('Email', data['email'] ?? '-'),
                _buildInfoRow('Tempat Lahir', data['tempat_lahir'] ?? '-'),
                _buildInfoRow('Tanggal Lahir', data['tanggal_lahir'] ?? '-'),
                _buildInfoRow('Jenis Kelamin', data['jenis_kelamin'] ?? '-'),
                _buildInfoRow('NIK', data['nik'] ?? '-'),
                _buildInfoRow('NIA', data['nia'] ?? '-'),
                _buildInfoRow('Alamat', data['alamat'] ?? '-'),
                _buildInfoRow('No HP (WA)', data['no_hp'] ?? '-'),
              ],
            ),
            const SizedBox(height: 16),

            // 2. RIWAYAT pengkaderan
            _buildSection(
              title: 'Riwayat pengkaderan',
              icon: CupertinoIcons.badge_plus_radiowaves_right,
              color: Colors.indigo,
              children: (data['pengkaderan'] as List<dynamic>? ?? []).map((p) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            shape: BoxShape.circle),
                        child: const Icon(CupertinoIcons.checkmark_seal_fill,
                            color: Colors.indigo, size: 16),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p['nama'] ?? '-',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text('${p['tempat']} • ${p['tanggal']}',
                                style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12)),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // 3. INFORMASI ORGANISASI & TAMBAHAN
            _buildSection(
              title: 'Informasi Organisasi & Tambahan',
              icon: CupertinoIcons.building_2_fill,
              color: Colors.orange,
              children: [
                _buildInfoRow('Jabatan', data['jabatan'] ?? '-'),
                _buildInfoRow('Nomor RFID', data['rfid'] ?? '-'),
                _buildInfoRow('Pekerjaan', data['pekerjaan'] ?? '-'),
                _buildInfoRow('Hobi / Minat', data['hobi'] ?? '-'),
              ],
            ),
            const SizedBox(height: 16),

            // 4. RIWAYAT PENDIDIKAN
            _buildSection(
              title: 'Riwayat Pendidikan',
              icon: CupertinoIcons.book,
              color: Colors.green,
              children: (data['pendidikan'] as List<dynamic>? ?? []).map((p) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            shape: BoxShape.circle),
                        child: const Icon(CupertinoIcons.building_2_fill,
                            color: Colors.green, size: 16),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p['jenjang'] ?? '-',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text(p['nama'] ?? '-',
                                style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12)),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      {required String title,
      required IconData icon,
      required Color color,
      required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 12),
                Text(title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Colors.black12),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style:
                  const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
          ),
          const Text(':',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
