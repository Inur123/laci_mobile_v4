import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laci_mobile/utils/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:laci_mobile/screens/aktivitas/detail_riwayat_aktivitas_screen.dart';

class RiwayatAktivitasScreen extends StatefulWidget {
  final bool isCabang;
  const RiwayatAktivitasScreen({super.key, this.isCabang = true});

  @override
  State<RiwayatAktivitasScreen> createState() => _RiwayatAktivitasScreenState();
}

class _RiwayatAktivitasScreenState extends State<RiwayatAktivitasScreen> {
  @override
  Widget build(BuildContext context) {
    final primaryColor =
        widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(CupertinoIcons.back, color: primaryColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Riwayat Aktivitas',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 16),
          ),
          bottom: TabBar(
            labelColor: primaryColor,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: primaryColor,
            indicatorWeight: 3,
            labelStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            unselectedLabelStyle:
                const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            tabs: const [
              Tab(text: 'Personal'),
              Tab(text: 'Global'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // TAB 1: Personal
            Column(
              children: [
                _buildStatsHorizontalScroll(false),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: _buildFilterSection(primaryColor, false),
                ),
                const Divider(height: 1, thickness: 1, color: Colors.black12),
                _buildActivityList(false),
              ],
            ),

            // TAB 2: Global
            Column(
              children: [
                _buildStatsHorizontalScroll(true),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: _buildFilterSection(primaryColor, true),
                ),
                const Divider(height: 1, thickness: 1, color: Colors.black12),
                _buildActivityList(true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Removed _buildHeader

  Widget _buildStatsHorizontalScroll(bool isGlobal) {
    final stats = !isGlobal
        ? [
            {
              'title': 'SEMUA',
              'value': '621',
              'icon': CupertinoIcons.waveform_path_ecg,
              'color': Colors.green
            },
            {
              'title': 'ARSIP SURAT',
              'value': '52',
              'icon': CupertinoIcons.doc_text,
              'color': Colors.blue
            },
            {
              'title': 'ANGGOTA',
              'value': '1',
              'icon': CupertinoIcons.person_2,
              'color': Colors.green
            },
            {
              'title': 'BERKAS PIMPINAN',
              'value': '9',
              'icon': CupertinoIcons.folder,
              'color': Colors.purple
            },
            {
              'title': 'BERKAS SP',
              'value': '16',
              'icon': CupertinoIcons.doc_plaintext,
              'color': Colors.purple.shade300
            },
            {
              'title': 'KEGIATAN',
              'value': '54',
              'icon': CupertinoIcons.calendar,
              'color': Colors.orange
            },
            {
              'title': 'PENGAJUAN PAC',
              'value': '41',
              'icon': CupertinoIcons.paperplane,
              'color': Colors.red
            },
            {
              'title': 'PERIODE',
              'value': '10',
              'icon': CupertinoIcons.layers_alt,
              'color': Colors.blue
            },
            {
              'title': 'AUTENTIKASI',
              'value': '361',
              'icon': CupertinoIcons.lock,
              'color': Colors.grey
            },
            {
              'title': 'UPDATE PROFIL',
              'value': '77',
              'icon': CupertinoIcons.person_crop_circle,
              'color': Colors.grey
            },
            {
              'title': 'PRESENSI',
              'value': '0',
              'icon': CupertinoIcons.waveform_path,
              'color': Colors.grey
            },
          ]
        : [
            {
              'title': 'SEMUA',
              'value': '1,7 rb',
              'icon': CupertinoIcons.waveform_path_ecg,
              'color': Colors.blue
            },
            {
              'title': 'ARSIP SURAT',
              'value': '236',
              'icon': CupertinoIcons.doc_text,
              'color': Colors.blue
            },
            {
              'title': 'ANGGOTA',
              'value': '586',
              'icon': CupertinoIcons.person_2,
              'color': Colors.green
            },
            {
              'title': 'BERKAS PIMPINAN',
              'value': '10',
              'icon': CupertinoIcons.folder,
              'color': Colors.purple
            },
            {
              'title': 'BERKAS SP',
              'value': '16',
              'icon': CupertinoIcons.doc_plaintext,
              'color': Colors.purple.shade300
            },
            {
              'title': 'KEGIATAN',
              'value': '95',
              'icon': CupertinoIcons.calendar,
              'color': Colors.orange
            },
            {
              'title': 'PENGAJUAN PAC',
              'value': '97',
              'icon': CupertinoIcons.paperplane,
              'color': Colors.red
            },
            {
              'title': 'PERIODE',
              'value': '37',
              'icon': CupertinoIcons.layers_alt,
              'color': Colors.blue
            },
            {
              'title': 'AUTENTIKASI',
              'value': '514',
              'icon': CupertinoIcons.lock,
              'color': Colors.grey
            },
            {
              'title': 'UPDATE PROFIL',
              'value': '86',
              'icon': CupertinoIcons.person_crop_circle,
              'color': Colors.grey
            },
            {
              'title': 'PRESENSI',
              'value': '0',
              'icon': CupertinoIcons.waveform_path,
              'color': Colors.grey
            },
          ];

    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: stats.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final stat = stats[index];
          return Container(
            width: 140,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black.withOpacity(0.05)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        stat['title'] as String,
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(stat['icon'] as IconData,
                        size: 14, color: stat['color'] as Color),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  stat['value'] as String,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildChartsSection(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Line Chart
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(CupertinoIcons.graph_circle,
                      color: primaryColor, size: 20),
                  const SizedBox(width: 8),
                  const Text('Tren Aktivitas User (7 Hari)',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textPrimary)),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) => FlLine(
                          color: Colors.black.withOpacity(0.05),
                          strokeWidth: 1,
                          dashArray: [5, 5]),
                    ),
                    titlesData: FlTitlesData(
                      rightTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:
                          AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const titles = [
                              '31 Jul',
                              '1 Agu',
                              '2 Agu',
                              '3 Agu',
                              '4 Agu',
                              '5 Agu',
                              '6 Agu'
                            ];
                            if (value >= 0 && value < titles.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(titles[value.toInt()],
                                    style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 10)),
                              );
                            }
                            return const Text('');
                          },
                          interval: 1,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Text(value.toInt().toString(),
                                style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 10));
                          },
                          interval: 5,
                          reservedSize: 28,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: 6,
                    minY: 0,
                    maxY: 20,
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 8),
                          FlSpot(1, 6),
                          FlSpot(2, 5),
                          FlSpot(3, 5),
                          FlSpot(4, 15),
                          FlSpot(5, 15),
                          FlSpot(6, 2),
                        ],
                        isCurved: true,
                        color: Colors.blue.shade400,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.blue.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Donut Chart
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(CupertinoIcons.chart_pie, color: primaryColor, size: 20),
                  const SizedBox(width: 8),
                  const Text('Sebaran Aktivitas per Modul',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textPrimary)),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 180,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 50,
                    sections: [
                      PieChartSectionData(
                          color: Colors.blue, value: 35, title: '', radius: 25),
                      PieChartSectionData(
                          color: Colors.green,
                          value: 20,
                          title: '',
                          radius: 25),
                      PieChartSectionData(
                          color: Colors.orange,
                          value: 15,
                          title: '',
                          radius: 25),
                      PieChartSectionData(
                          color: Colors.purple,
                          value: 10,
                          title: '',
                          radius: 25),
                      PieChartSectionData(
                          color: Colors.red, value: 10, title: '', radius: 25),
                      PieChartSectionData(
                          color: Colors.cyan, value: 10, title: '', radius: 25),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Legend
              Wrap(
                spacing: 12,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  _buildLegendItem(Colors.blue, 'AUTH'),
                  _buildLegendItem(Colors.green, 'USER'),
                  _buildLegendItem(Colors.orange, 'BERKAS PIMPINAN'),
                  _buildLegendItem(Colors.purple, 'PENGAJUAN'),
                  _buildLegendItem(Colors.red, 'PERIODE'),
                  _buildLegendItem(Colors.cyan, 'AGENDA'),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(text,
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildFilterSection(Color primaryColor, bool isGlobal) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari aktivitas, entitas, modul...',
                  hintStyle: const TextStyle(
                      fontSize: 14, color: AppColors.textSecondary),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300)),
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
              icon: const Icon(CupertinoIcons.slider_horizontal_3,
                  size: 18, color: AppColors.textPrimary),
              onPressed: () {
                _showFilterModal(context, isGlobal);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList(bool isGlobal) {
    final activities = [
      {
        'waktu': '6 Agustus 2026 - 09.19.49',
        'user': 'Sekretaris Cabang',
        'entitas': 'Login',
        'entitasColor': Colors.green,
        'modul': 'Autentikasi',
        'aktivitas': 'User login ke sistem: Sekretaris Cabang'
      },
      {
        'waktu': '5 Agustus 2026 - 15.45.45',
        'user': 'Sekretaris Cabang',
        'entitas': 'Hapus',
        'entitasColor': Colors.red,
        'modul': 'Periode',
        'aktivitas': 'Menghapus periode: 2027-2029'
      },
      {
        'waktu': '5 Agustus 2026 - 15.44.48',
        'user': 'Sekretaris Cabang',
        'entitas': 'Tambah',
        'entitasColor': Colors.green,
        'modul': 'Periode',
        'aktivitas': 'Membuat periode baru: 2027-2029'
      },
      {
        'waktu': '5 Agustus 2026 - 14.47.20',
        'user': 'Sekretaris Cabang',
        'entitas': 'Update',
        'entitasColor': Colors.blue,
        'modul': 'Kegiatan',
        'aktivitas': 'Memperbarui kegiatan presensi: Raker'
      },
      {
        'waktu': '5 Agustus 2026 - 14.47.14',
        'user': 'Sekretaris Cabang',
        'entitas': 'Tambah',
        'entitasColor': Colors.green,
        'modul': 'Kegiatan',
        'aktivitas': 'Membuat kegiatan presensi baru: Raker'
      },
      {
        'waktu': '5 Agustus 2026 - 12.49.04',
        'user': 'Sekretaris Cabang',
        'entitas': 'Logout',
        'entitasColor': Colors.orange,
        'modul': 'Autentikasi',
        'aktivitas': 'User logout dari sistem: Sekretaris Cabang'
      },
    ];

    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        itemCount: activities.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = activities[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailRiwayatAktivitasScreen(
                          data: item, isCabang: widget.isCabang)));
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black.withOpacity(0.05)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item['waktu'] as String,
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              (item['entitasColor'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(item['entitas'] as String,
                            style: TextStyle(
                                color: item['entitasColor'] as Color,
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (isGlobal) ...[
                    Row(
                      children: [
                        const Icon(CupertinoIcons.person_solid,
                            size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text(item['user'] as String,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary)),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(CupertinoIcons.square_list,
                            size: 16, color: Colors.blue),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['modul'] as String,
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary)),
                            const SizedBox(height: 4),
                            Text(item['aktivitas'] as String,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                    height: 1.4)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFilterModal(BuildContext context, bool isGlobal) {
    String selectedModul = 'Semua Modul';
    String selectedEntitas = 'Semua Entitas';
    String selectedUser = 'Semua User';

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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Filter Aktivitas',
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
                    const Text('Modul',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      value: selectedModul,
                      items: [
                        'Semua Modul',
                        'Autentikasi',
                        'Periode',
                        'Kegiatan',
                        'Manajemen User',
                        'Arsip Surat'
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => selectedModul = val);
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Entitas',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    _buildDropdown(
                      value: selectedEntitas,
                      items: [
                        'Semua Entitas',
                        'Login',
                        'Logout',
                        'Tambah',
                        'Update',
                        'Hapus',
                        'Lihat'
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => selectedEntitas = val);
                      },
                    ),
                    if (isGlobal) ...[
                      const SizedBox(height: 16),
                      const Text('User Akun',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary)),
                      const SizedBox(height: 8),
                      _buildDropdown(
                        value: selectedUser,
                        items: [
                          'Semua User',
                          'Ketua Cabang',
                          'Sekretaris Cabang',
                          'Ketua PAC',
                          'Sekretaris PAC'
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => selectedUser = val);
                        },
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
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDropdown(
      {required String value,
      required List<String> items,
      required Function(String?) onChanged}) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(CupertinoIcons.chevron_down, size: 16),
          items: items
              .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: const TextStyle(fontSize: 14))))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
