import 'package:flutter/material.dart';
import 'package:laci_mobile/screens/arsip/detail_arsip_surat_screen.dart';
import 'package:laci_mobile/screens/arsip/detail_sp_screen.dart';
import 'package:laci_mobile/screens/arsip/detail_berkas_cabang_screen.dart';
import 'package:laci_mobile/screens/arsip/form_arsip_surat_screen.dart';
import 'package:laci_mobile/screens/arsip/form_berkas_cabang_screen.dart';
import 'package:laci_mobile/screens/arsip/form_sp_screen.dart';
import 'package:laci_mobile/utils/app_colors.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:toastification/toastification.dart';

class ArsipScreen extends StatefulWidget {
  final bool isCabang;

  const ArsipScreen({super.key, this.isCabang = true});

  @override
  State<ArsipScreen> createState() => _ArsipScreenState();
}

class _ArsipScreenState extends State<ArsipScreen> {
  @override
  Widget build(BuildContext context) {
    final primaryColor =
        widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          title: const Text('Arsip',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          actions: [],
          bottom: TabBar(
            labelColor: widget.isCabang
                ? AppColors.cabangPrimary
                : AppColors.pacPrimary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: widget.isCabang
                ? AppColors.cabangPrimary
                : AppColors.pacPrimary,
            indicatorWeight: 3,
            labelStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            tabs: [
              const Tab(text: 'Arsip Surat'),
              const Tab(text: 'Berkas SP'),
              Tab(text: widget.isCabang ? 'Berkas Cabang' : 'Berkas PAC'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // TAB 1: Arsip Surat (Original Content)
            Column(
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
                      _buildStatCard(
                          'TOTAL', '254', Icons.description, Colors.blue),
                      _buildStatCard('MASUK', '131',
                          Icons.call_received, Colors.green),
                      _buildStatCard('KELUAR', '123',
                          Icons.call_made, Colors.orange),
                      _buildStatCard(
                          'IPNU', '40', Icons.security, Colors.teal),
                      _buildStatCard(
                          'IPPNU', '77', Icons.security, Colors.teal),
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
                              hintText: 'Cari nomor surat, perihal...',
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

            // TAB 2: Berkas SP
            Column(
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
                      _buildStatCard('TOTAL BERKAS', '15',
                          Icons.description, Colors.blue),
                      _buildStatCard(
                          'IPNU', '12', Icons.security, Colors.green),
                      _buildStatCard(
                          'IPPNU', '3', Icons.security, Colors.pink),
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
                              hintText: 'Cari nama pimpinan atau catatan...',
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
                            _showFilterModal(context, showJenis: false);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1, thickness: 1, color: Colors.black12),

                // LIST SP
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return _buildSpCard(index);
                    },
                  ),
                ),
              ],
            ),

            // TAB 3: Berkas Cabang/PAC
            Column(
              children: [
                // SEARCH & FILTER
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Cari nama atau catatan...',
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
                    ],
                  ),
                ),

                const Divider(height: 1, thickness: 1, color: Colors.black12),

                // LIST BERKAS CABANG/PAC
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return _buildBerkasCabangCard(index);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'arsip_fab',
          onPressed: () {
            _showAddOptions(context);
          },
          backgroundColor: primaryColor,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String count, IconData icon, Color color) {
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
              Text(title,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary)),
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

  Widget _buildSuratCard(int index) {
    // Dummy data variations
    final isMasuk = index % 2 == 0;
    final org =
        index % 3 == 0 ? 'IPPNU' : (index % 3 == 1 ? 'IPNU' : 'BERSAMA');

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
                    builder: (context) =>
                        DetailArsipSuratScreen(isCabang: widget.isCabang)));
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Baris Atas: Badge & Menu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildBadge(
                            org,
                            org == 'IPPNU'
                                ? Colors.pink
                                : (org == 'IPNU' ? Colors.green : Colors.blue)),
                        const SizedBox(width: 8),
                        _buildBadge(isMasuk ? 'MASUK' : 'KELUAR',
                            isMasuk ? Colors.indigo : Colors.orange),
                      ],
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_horiz,
                          size: 20, color: AppColors.textSecondary),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      color: Colors.white,
                      onSelected: (value) {
                        if (value == 'lihat') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailArsipSuratScreen(
                                      isCabang: widget.isCabang)));
                        } else if (value == 'edit') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FormArsipSuratScreen(
                                          isEdit: true)));
                        } else if (value == 'hapus') {
                          _showDeleteDialog(context);
                        }
                      },
                      itemBuilder: (context) => [
                        _buildPopupMenuItem(
                            'lihat', Icons.visibility_outlined, 'Lihat Detail'),
                        _buildPopupMenuItem(
                            'edit', Icons.edit_outlined, 'Edit'),
                        _buildPopupMenuItem(
                            'hapus', Icons.delete_outline, 'Hapus',
                            isDestructive: true),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Perihal
                Text(
                  isMasuk
                      ? 'Undangan Pra Rapimwil Jatim'
                      : 'Instruksi Pelatihan Persidangan',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Info Detail
                Row(
                  children: [
                    const Icon(Icons.tag,
                        size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Expanded(
                        child: Text('020/PW/A/7455/...',
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textSecondary))),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    const Expanded(
                        child: Text('16 Juli 2026',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.textSecondary))),
                  ],
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child:
                      Divider(height: 1, thickness: 1, color: Colors.black12),
                ),

                // Pengirim / Penerima
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: (widget.isCabang
                                  ? AppColors.cabangPrimary
                                  : AppColors.pacPrimary)
                              .withOpacity(0.1),
                          shape: BoxShape.circle),
                      child: Icon(
                          isMasuk
                              ? Icons.account_circle
                              : Icons.send,
                          size: 16,
                          color: widget.isCabang
                              ? AppColors.cabangPrimary
                              : AppColors.pacPrimary),
                    ),
                    const SizedBox(width: 8),
                    Text(
                        isMasuk
                            ? 'Dari: PW IPPNU Jatim'
                            : 'Kepada: PC IPNU Magetan',
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpCard(int index) {
    final names = [
      'Pk Ipnu Tarbiyatul \'ulum',
      'Pac Ippnu Karas',
      'Pac Ippnu Plaosan',
      'Pac Ippnu Maospati'
    ];
    final orgs = ['IPNU', 'IPPNU', 'IPPNU', 'IPPNU'];
    final sisaHari = ['110', '383', '537', '521'];

    final isIppnu = orgs[index] == 'IPPNU';

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
                    builder: (context) =>
                        DetailSpScreen(isCabang: widget.isCabang)));
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildBadge(
                            orgs[index], isIppnu ? Colors.pink : Colors.green),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Text('Aktif (Sisa ${sisaHari[index]} Hari)',
                              style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green)),
                        ),
                      ],
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_horiz,
                          size: 20, color: AppColors.textSecondary),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      color: Colors.white,
                      onSelected: (value) {
                        if (value == 'lihat') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailSpScreen(
                                      isCabang: widget.isCabang)));
                        } else if (value == 'edit') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const FormSpScreen(isEdit: true)));
                        } else if (value == 'hapus') {
                          _showDeleteDialog(context);
                        }
                      },
                      itemBuilder: (context) => [
                        _buildPopupMenuItem(
                            'lihat', Icons.visibility_outlined, 'Lihat Detail'),
                        _buildPopupMenuItem(
                            'edit', Icons.edit_outlined, 'Edit'),
                        _buildPopupMenuItem(
                            'hapus', Icons.delete_outline, 'Hapus',
                            isDestructive: true),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(names[index],
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    const Text('Mulai: 23 Nov 2026',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.event,
                        size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    const Text('Akhir: 23 Nov 2026',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBerkasCabangCard(int index) {
    final names = [
      'LPJ Kader Connect 2026',
      'LPJ Rapimcab 2026',
      'LPJ Mujahadah 2026',
      'SP IPNU'
    ];
    final tanggals = [
      '02 Agu 2026',
      '27 Jul 2026',
      '27 Jul 2026',
      '04 Jun 2026'
    ];

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
                    builder: (context) =>
                        DetailBerkasCabangScreen(isCabang: widget.isCabang)));
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(names[index],
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_horiz,
                          size: 20, color: AppColors.textSecondary),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      color: Colors.white,
                      onSelected: (value) {
                        if (value == 'edit') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FormBerkasCabangScreen(
                                      isEdit: true,
                                      isCabang: widget.isCabang)));
                        } else if (value == 'hapus') {
                          _showDeleteDialog(context);
                        }
                      },
                      itemBuilder: (context) => [
                        _buildPopupMenuItem(
                            'edit', Icons.edit_outlined, 'Edit'),
                        _buildPopupMenuItem(
                            'hapus', Icons.delete_outline, 'Hapus',
                            isDestructive: true),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(tanggals[index],
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.description,
                        size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    const Text('Catatan: -',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
        ),
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
        style:
            TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
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

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10))),
              const Padding(
                padding: EdgeInsets.all(24.0),
                child: Text('Tambah Data Baru',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
              ),
              ListTile(
                leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.blue.shade50, shape: BoxShape.circle),
                    child: const Icon(Icons.description,
                        color: Colors.blue)),
                title: const Text('Arsip Surat',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Surat masuk dan keluar',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FormArsipSuratScreen(isCabang: widget.isCabang)));
                },
              ),
              ListTile(
                leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.green.shade50, shape: BoxShape.circle),
                    child: const Icon(Icons.assignment_ind,
                        color: Colors.green)),
                title: const Text('Berkas SP',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Surat Pengesahan Kepengurusan',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FormSpScreen(isCabang: widget.isCabang)));
                },
              ),
              ListTile(
                leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.orange.shade50, shape: BoxShape.circle),
                    child: const Icon(Icons.folder,
                        color: Colors.orange)),
                title: Text(widget.isCabang ? 'Berkas Cabang' : 'Berkas PAC',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                    'Dokumen dan aset ${widget.isCabang ? 'cabang' : 'PAC'}',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FormBerkasCabangScreen(
                              isCabang: widget.isCabang)));
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _showFilterModal(BuildContext context, {bool showJenis = true}) {
    String selectedOrganisasi = 'Semua Organisasi';
    String selectedJenis = 'Semua Jenis';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Filter Arsip',
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
                  const SizedBox(height: 24),
                  const Text('Organisasi',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedOrganisasi,
                        isExpanded: true,
                        icon: const Icon(Icons.expand_more, size: 16),
                        items: [
                          'Semua Organisasi',
                          'IPNU',
                          'IPPNU',
                          'BERSAMA',
                          'CBP KPP'
                        ]
                            .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e,
                                    style: const TextStyle(fontSize: 14))))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => selectedOrganisasi = val);
                          }
                        },
                      ),
                    ),
                  ),
                  if (showJenis) ...[
                    const SizedBox(height: 16),
                    const Text('Jenis Surat',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedJenis,
                          isExpanded: true,
                          icon:
                              const Icon(Icons.expand_more, size: 16),
                          items: [
                            'Semua Jenis',
                            'Surat Masuk',
                            'Surat Keluar',
                            'Surat Tugas',
                            'Surat Keputusan'
                          ]
                              .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e,
                                      style: const TextStyle(fontSize: 14))))
                              .toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => selectedJenis = val);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
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
            );
          },
        );
      },
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final result = await showOkCancelAlertDialog(
      context: context,
      title: 'Hapus Arsip',
      message:
          'Apakah Anda yakin ingin menghapus arsip surat ini? Data yang sudah dihapus tidak dapat dikembalikan.',
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
          showProgressBar: false,
          primaryColor: Colors.white,
          icon: const Icon(Icons.check_circle_outline, color: Colors.green),
          title: const Text('Arsip berhasil dihapus'),
          alignment: Alignment.topCenter,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    }
  }
}
