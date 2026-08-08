import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laci_mobile/screens/anggota/form_anggota_screen.dart';
import 'package:laci_mobile/screens/anggota/detail_anggota_screen.dart';
import 'package:laci_mobile/utils/app_colors.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:toastification/toastification.dart';

class AnggotaScreen extends StatefulWidget {
  final bool isCabang;
  const AnggotaScreen({super.key, this.isCabang = true});

  @override
  State<AnggotaScreen> createState() => _AnggotaScreenState();
}

class _AnggotaScreenState extends State<AnggotaScreen> {
  @override
  Widget build(BuildContext context) {
    final primaryColor =
        widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text('Data Anggota',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.content_paste,
                color: AppColors.textSecondary, size: 22),
            onPressed: () {
              _showSalinModal(context, primaryColor);
            },
          ),
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
                _buildStatCard('TOTAL ANGGOTA', '312', Icons.people_outline,
                    primaryColor),
                _buildStatCard('LAKI-LAKI (IPNU)', '113', Icons.person_outline,
                    Colors.green),
                _buildStatCard('PEREMPUAN (IPPNU)', '199',
                    Icons.person_outline, Colors.pink),
                _buildStatCard(
                    'MAKESTA', '116', Icons.security, Colors.blue),
                _buildStatCard(
                    'LAKMUD', '21', Icons.security, Colors.indigo),
                _buildStatCard(
                    'LATIN', '2', Icons.military_tech, Colors.orange),
              ],
            ),
          ),

          // SEARCH & FILTER
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari nama, jabatan, NIK, NIA...',
                        hintStyle: const TextStyle(
                            fontSize: 14, color: AppColors.textSecondary),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: primaryColor)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.tune,
                        size: 18, color: AppColors.textPrimary),
                    onPressed: () {
                      _showFilterModal(context);
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
      floatingActionButton: FloatingActionButton(
        heroTag: 'anggota_fab',
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      FormAnggotaScreen(isCabang: widget.isCabang)));
        },
        backgroundColor:
            widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String count, IconData icon, Color color) {
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
              Expanded(
                  child: Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary))),
              const SizedBox(width: 4),
              Icon(icon, size: 14, color: color),
            ],
          ),
          Text(count,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildAnggotaCard(int index) {
    // Dummy data variations
    final isLaki = index == 2 || index == 3;
    final nama = isLaki
        ? (index == 2 ? 'Dwi Agus Nur Cahyo' : 'Fauzan Nabil')
        : (index == 0 ? 'Chumaira Nurul Aini' : 'Desta Faizatus Zahra');
    final inisial = nama.split(' ').take(2).map((e) => e[0]).join();

    final dummyData = {
      'nama': nama,
      'email': '${nama.replaceAll(' ', '').toLowerCase()}@gmail.com',
      'tempat_lahir': isLaki ? 'Magetan' : 'Madiun',
      'tanggal_lahir': isLaki ? '12 Agustus 2005' : '01 Januari 2006',
      'jenis_kelamin': isLaki ? 'Laki-laki' : 'Perempuan',
      'nik': '3520123456780001',
      'nia': isLaki ? '11.12.13.14.15' : '21.22.23.24.25',
      'alamat': 'Jl. Manggis No. 12, Ngariboyo, Magetan',
      'no_hp': '081234567890',
      'jabatan': 'Anggota',
      'rfid': 'RFID-987654321',
      'pekerjaan': 'Mahasiswa',
      'hobi': 'Membaca, Menulis',
      'pengkaderan': [
        {
          'nama': 'Makesta',
          'tanggal': '15 Juli 2023',
          'tempat': 'MtsN 1 Magetan'
        },
        {
          'nama': 'Lakmud',
          'tanggal': '20 Agustus 2024',
          'tempat': 'PCNU Magetan'
        }
      ],
      'pendidikan': [
        {'jenjang': 'SMA/MA/SMK', 'nama': 'SMAN 1 Magetan'},
        {'jenjang': 'S1', 'nama': 'Universitas Brawijaya'}
      ]
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailAnggotaScreen(
                  data: dummyData,
                  isCabang: widget.isCabang,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color:
                        isLaki ? Colors.green.shade100 : Colors.pink.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      inisial,
                      style: TextStyle(
                        color: isLaki
                            ? Colors.green.shade700
                            : Colors.pink.shade700,
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
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.person,
                              size: 12,
                              color: isLaki ? Colors.green : Colors.pink),
                          const SizedBox(width: 4),
                          Text(
                              isLaki ? 'Laki-laki (IPNU)' : 'Perempuan (IPPNU)',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.business,
                              size: 12, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          const Expanded(
                              child: Text('PAC Ngariboyo',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary))),
                        ],
                      ),
                    ],
                  ),
                ),

                // Menu 3 Titik
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz,
                      size: 20, color: AppColors.textSecondary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  color: Colors.white,
                  onSelected: (value) async {
                    if (value == 'lihat') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailAnggotaScreen(
                            data: dummyData,
                            isCabang: widget.isCabang,
                          ),
                        ),
                      );
                    } else if (value == 'edit') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const FormAnggotaScreen(isEdit: true)));
                    } else if (value == 'hapus') {
                      final result = await showOkCancelAlertDialog(
                        context: context,
                        title: 'Hapus Anggota',
                        message:
                            'Apakah Anda yakin ingin menghapus data anggota ini? Data yang sudah dihapus tidak dapat dikembalikan.',
                        okLabel: 'Hapus',
                        cancelLabel: 'Batal',
                        isDestructiveAction: true,
                      );
                      if (result == OkCancelResult.ok) {
                        if (context.mounted) {
                          toastification.show(
                            // ignore: use_build_context_synchronously
                            context: context,
                            type: ToastificationType.success,
                            style: ToastificationStyle.flat,
                            showProgressBar: false,
                            primaryColor: Colors.white,
                            icon: const Icon(Icons.check_circle_outline,
                                color: Colors.green),
                            title: const Text('Data anggota berhasil dihapus'),
                            alignment: Alignment.topCenter,
                            autoCloseDuration: const Duration(seconds: 3),
                          );
                        }
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    _buildPopupMenuItem(
                        'lihat', Icons.visibility_outlined, 'Lihat Detail'),
                    _buildPopupMenuItem('edit', Icons.edit_outlined, 'Edit'),
                    _buildPopupMenuItem('hapus', Icons.delete_outline, 'Hapus',
                        isDestructive: true),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
      String value, IconData icon, String text,
      {bool isDestructive = false}) {
    final color = isDestructive ? Colors.red : AppColors.textPrimary;
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 12),
          Text(text,
              style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight:
                      isDestructive ? FontWeight.bold : FontWeight.w500)),
        ],
      ),
    );
  }

  void _showSalinModal(BuildContext context, Color primaryColor) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Row(
            children: [
              Icon(Icons.content_paste,
                  color: primaryColor),
              const SizedBox(width: 8),
              const Text('Salin Anggota',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
              const Text('PILIH PERIODE ASAL',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary)),
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
                    Text('Pilih periode...',
                        style: TextStyle(color: AppColors.textSecondary)),
                    Icon(Icons.expand_more,
                        size: 16, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Salin 0 Anggota',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showFilterModal(BuildContext context) {
    String selectedPac = 'Semua PAC';
    List<String> pacList = [
      'Semua PAC',
      'Pac Barat',
      'Pac Bendo',
      'Pacipnuippnu Lembeyan',
      'Pacipnuippnumagetan',
      'Pac Ipnu Ippnu Panekan',
      'Pac Ipnu Ippnu Sukomoro',
      'Pac Ipnu Ippnu Takeran'
    ];
    List<String> filteredPacList = List.from(pacList);
    TextEditingController searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.7,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Filter User',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary)),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          child: const Text('Batal',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 48,
                      child: TextField(
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            filteredPacList = pacList
                                .where((pac) => pac
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Cari PAC...',
                          hintStyle: const TextStyle(
                              fontSize: 14, color: AppColors.textSecondary),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                  color: widget.isCabang
                                      ? AppColors.cabangPrimary
                                      : AppColors.pacPrimary)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: ListView.builder(
                        itemCount: filteredPacList.length,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final pac = filteredPacList[index];
                          final isSelected = pac == selectedPac;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedPac = pac;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 8),
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.black12))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(pac,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                          color: AppColors.textPrimary)),
                                  if (isSelected)
                                    Icon(Icons.check,
                                        color: widget.isCabang
                                            ? AppColors.cabangPrimary
                                            : AppColors.pacPrimary,
                                        size: 20),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.isCabang
                              ? AppColors.cabangPrimary
                              : AppColors.pacPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Terapkan Filter',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
