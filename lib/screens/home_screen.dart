import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:laci_mobile/screens/agenda/agenda_screen.dart';
import 'package:laci_mobile/screens/pengguna/pengguna_screen.dart';
import 'package:laci_mobile/screens/presensi/presensi_screen.dart';
import 'package:laci_mobile/screens/lainnya_screen.dart';
import 'package:laci_mobile/screens/periode/periode_screen.dart';
import 'package:laci_mobile/screens/aktivitas/riwayat_aktivitas_screen.dart';
import 'package:laci_mobile/utils/app_colors.dart';
import 'package:laci_mobile/widgets/custom_refresh_control.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laci_mobile/providers/dashboard_provider.dart';
import 'package:laci_mobile/providers/data_saya_provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final bool isCabang;
  const HomeScreen({super.key, this.isCabang = true});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dataSayaProvider.notifier).fetchDataSaya();
      if (widget.isCabang) {
        ref.read(dashboardMonitoringProvider.notifier).fetchMonitoringStats();
      }
    });
  }

  Future<void> _onRefresh() async {
    final futures = <Future>[
      ref.read(dataSayaProvider.notifier).fetchDataSaya(),
    ];
    if (widget.isCabang) {
      futures.add(ref.read(dashboardMonitoringProvider.notifier).fetchMonitoringStats());
    }
    await Future.wait(futures);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary;
    final dashboardState = ref.watch(dashboardMonitoringProvider);
    final dataSayaState = ref.watch(dataSayaProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: Column(
          children: [
            _buildHeader(primaryColor),
            if (widget.isCabang) ...[
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: primaryColor,
                      labelColor: primaryColor,
                      unselectedLabelColor: AppColors.textSecondary,
                      indicatorWeight: 3,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                      tabs: const [
                        Tab(text: 'Data Saya'),
                        Tab(text: 'Monitoring Wilayah'),
                      ],
                    ),
                    Container(height: 1, color: Colors.black.withOpacity(0.05)),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // TAB 1: Data Saya
                    CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        CustomRefreshControl(onRefresh: _onRefresh, primaryColor: primaryColor),
                        SliverPadding(
                          padding: const EdgeInsets.only(bottom: 40),
                          sliver: SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildGridMenu(),
                                const SizedBox(height: 24),
                                if (dataSayaState.isLoading && dataSayaState.stats == null)
                                  _buildDataSayaShimmer()
                                else ...[
                                  _buildDataSayaStatsScroll(primaryColor, dataSayaState),
                                  const SizedBox(height: 24),
                                  _buildStatistikDataChart(),
                                  const SizedBox(height: 24),
                                  _buildTrenKeaktifanChart(primaryColor),
                                ]
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // TAB 2: Monitoring Wilayah
                    CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        CustomRefreshControl(onRefresh: _onRefresh, primaryColor: primaryColor),
                        SliverPadding(
                          padding: const EdgeInsets.only(bottom: 40),
                          sliver: SliverToBoxAdapter(
                            child: dashboardState.isLoading && dashboardState.data == null
                              ? _buildMonitoringShimmer()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 16),
                                    _buildMonitoringStatsScroll(primaryColor, dashboardState),
                                    const SizedBox(height: 24),
                                    _buildPengkaderanBadges(),
                                    const SizedBox(height: 24),
                                    _buildTopPacChart(primaryColor, dashboardState),
                                    const SizedBox(height: 24),
                                    _buildSebaranDataChart(primaryColor, dashboardState),
                                    const SizedBox(height: 24),
                                    _buildRincianKlasemenTable(dashboardState),
                                  ],
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ] else ...[
              Expanded(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    CustomRefreshControl(onRefresh: _onRefresh, primaryColor: primaryColor),
                    SliverPadding(
                      padding: const EdgeInsets.only(bottom: 40),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildGridMenu(),
                            const SizedBox(height: 24),
                            if (dataSayaState.isLoading && dataSayaState.stats == null)
                              _buildDataSayaShimmer()
                            else ...[
                              _buildDataSayaStatsScroll(primaryColor, dataSayaState),
                              const SizedBox(height: 24),
                              _buildStatistikDataChart(),
                              const SizedBox(height: 24),
                              _buildTrenKeaktifanChart(primaryColor),
                            ]
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 30),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hai, Pengurus!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Laci Cabang',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Text(
                  widget.isCabang ? 'CABANG' : 'PAC',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: CircleAvatar(
              radius: 26,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: primaryColor, size: 30),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 1: DATA SAYA COMPONENTS
  // ==========================================

  Widget _buildGridMenu() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Menu Utama',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.isCabang
                    ? _buildMenuButton(
                        Icons.groups,
                        'Pengguna',
                        Colors.blue.shade100,
                        Colors.blue.shade700,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PenggunaScreen(isCabang: widget.isCabang))),
                      )
                    : _buildMenuButton(
                        Icons.layers,
                        'Periode',
                        Colors.blue.shade100,
                        Colors.blue.shade700,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PeriodeScreen(isCabang: widget.isCabang))),
                      ),
                _buildMenuButton(
                  Icons.calendar_today,
                  'Agenda',
                  Colors.orange.shade100,
                  Colors.orange.shade700,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AgendaScreen(isCabang: widget.isCabang))),
                ),
                _buildMenuButton(
                  Icons.qr_code_scanner,
                  'Presensi',
                  Colors.green.shade100,
                  Colors.green.shade700,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PresensiScreen(isCabang: widget.isCabang))),
                ),
                widget.isCabang
                    ? _buildMenuButton(
                        Icons.grid_view,
                        'Lainnya',
                        Colors.purple.shade100,
                        Colors.purple.shade700,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LainnyaScreen(isCabang: widget.isCabang))),
                      )
                    : _buildMenuButton(
                        Icons.bar_chart,
                        'Aktivitas',
                        Colors.purple.shade100,
                        Colors.purple.shade700,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RiwayatAktivitasScreen(isCabang: widget.isCabang))),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(IconData icon, String label, Color bgColor, Color iconColor, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildDataSayaShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Shimmer Data Saya Stats
        SizedBox(
          height: 90,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),

        // Shimmer for Statistik Data Chart
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 200,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Shimmer for Tren Keaktifan
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 220,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDataSayaStatsScroll(Color primaryColor, DataSayaState state) {
    final statsAktivitas = state.stats ?? {};
    final totalAnggota = statsAktivitas['dataAnggota'] ?? 0;
    final totalArsip = statsAktivitas['arsipSurat'] ?? 0;
    final totalPeriode = statsAktivitas['periode'] ?? 0;
    final totalPengajuan = statsAktivitas['pengajuanPac'] ?? 0;
    final totalBerkasPimpinan = statsAktivitas['berkasPimpinan'] ?? 0;

    final stats = widget.isCabang ? [
      {'title': 'TOTAL ANGGOTA', 'val': '$totalAnggota', 'color': Colors.blue},
      {'title': 'ARSIP SURAT', 'val': '$totalArsip', 'color': Colors.orange},
      {'title': 'BERKAS SP', 'val': '0', 'color': Colors.purple}, // Belum ada di DB
      {'title': 'BERKAS PIMPINAN', 'val': '$totalBerkasPimpinan', 'color': Colors.pink},
      {'title': 'VERIFIKASI PENGAJUAN', 'val': '$totalPengajuan', 'color': Colors.green},
      {'title': 'AGENDA KEGIATAN', 'val': '0', 'color': Colors.red}, // Belum ada di DB
      {'title': 'MANAJEMEN USER', 'val': '0', 'color': Colors.blueGrey}, // Belum ada di DB
      {'title': 'DATA ANGGOTA', 'val': '$totalAnggota', 'color': Colors.cyan},
      {'title': 'PERIODE', 'val': '$totalPeriode', 'color': Colors.blue},
      {'title': 'PRESENSI', 'val': '0', 'color': Colors.pink}, // Belum ada di DB
    ] : [
      {'title': 'TOTAL ANGGOTA', 'val': '$totalAnggota', 'color': Colors.blue},
      {'title': 'ARSIP SURAT', 'val': '$totalArsip', 'color': Colors.orange},
      {'title': 'ARSIP PIMPINAN', 'val': '$totalBerkasPimpinan', 'color': Colors.purple},
      {'title': 'PENGAJUAN BERKAS', 'val': '$totalPengajuan', 'color': Colors.green},
      {'title': 'PERIODE', 'val': '$totalPeriode', 'color': Colors.cyan},
      {'title': 'PRESENSI', 'val': '0', 'color': Colors.pink}, // Belum ada di DB
    ];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: stats.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = stats[index];
          final col = item['color'] as Color;
          return Container(
            width: 140,
            padding: const EdgeInsets.all(12),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item['title'] as String, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: col), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Text(item['val'] as String, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: col)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatistikDataChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Statistik Data', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 300,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const titles = ['Anggota', 'Surat', 'SP', 'Pimpinan', 'Pengajuan'];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(titles[value.toInt()], style: const TextStyle(color: AppColors.textSecondary, fontSize: 9, fontWeight: FontWeight.bold)),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 30, interval: 100, getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10))),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 100,
                    getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade200, strokeWidth: 1, dashArray: [5, 5]),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 1, color: Colors.blue, width: 20, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 254, color: Colors.orange, width: 20, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 15, color: Colors.indigo, width: 20, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 8, color: Colors.purple, width: 20, borderRadius: BorderRadius.circular(4))]),
                    BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 28, color: Colors.green, width: 20, borderRadius: BorderRadius.circular(4))]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrenKeaktifanChart(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.call_made, size: 18, color: primaryColor),
                const SizedBox(width: 8),
                const Text('Tren Keaktifan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
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
                    horizontalInterval: 55,
                    getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.shade200, strokeWidth: 1, dashArray: [5, 5]),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 22,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          const months = ['Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu'];
                          if (value.toInt() >= 0 && value.toInt() < months.length) {
                            return Text(months[value.toInt()], style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold));
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 55,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 5,
                  minY: 0,
                  maxY: 220,
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 0),
                        FlSpot(1, 215),
                        FlSpot(2, 25),
                        FlSpot(3, 5),
                        FlSpot(4, 10),
                        FlSpot(5, 0),
                      ],
                      isCurved: true,
                      color: primaryColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: primaryColor.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TAB 2: MONITORING WILAYAH COMPONENTS
  // ==========================================

  Widget _buildMonitoringShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        // Shimmer for Stats Scroll
        SizedBox(
          height: 90,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        
        // Shimmer for Pengkaderan Badges
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(height: 60, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(height: 60, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(height: 60, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Shimmer for Top PAC Chart
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 250,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Shimmer for Sebaran Data (Pie Chart)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 260,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMonitoringStatsScroll(Color primaryColor, DashboardMonitoringState state) {
    final data = state.data;
    
    final stats = [
      {'title': 'TOTAL ANGGOTA', 'val': '${data?.totalAnggota ?? 0}', 'color': Colors.blue},
      {'title': 'TOTAL ADMINISTRASI', 'val': '${data?.totalAdministrasi ?? 0}', 'color': Colors.cyan},
      {'title': 'PAC AKTIF', 'val': '${data?.pacAktif ?? 0}', 'color': Colors.deepPurple},
      {'title': 'VERIF / PENDING', 'val': '${data?.pacVerif ?? 0} / ${data?.pacPending ?? 0}', 'color': Colors.red},
    ];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: stats.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = stats[index];
          final col = item['color'] as Color;
          return Container(
            width: 150,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item['title'] as String, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: col), maxLines: 1),
                const SizedBox(height: 8),
                Text(item['val'] as String, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: col)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPengkaderanBadges() {
    final kader = [
      {'title': 'MAKESTA', 'val': '172', 'c': Colors.pink},
      {'title': 'LAKMUD', 'val': '35', 'c': Colors.green},
      {'title': 'LATIH', 'val': '2', 'c': Colors.blue},
      {'title': 'LATPEL', 'val': '5', 'c': Colors.teal},
      {'title': 'LAKUT', 'val': '1', 'c': Colors.purple},
      {'title': 'DIKLATAMA', 'val': '16', 'c': Colors.orange},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Icon(Icons.layers, size: 16, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              const Text('Total Pengkaderan Wilayah', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 60,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: kader.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final k = kader[index];
              final col = k['c'] as Color;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: col.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 10, color: col),
                        const SizedBox(width: 4),
                        Text(k['title'] as String, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: col)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('${k['val']} Anggota', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTopPacChart(Color primaryColor, DashboardMonitoringState state) {
    final topPacs = state.data?.topPacs ?? [];
    
    // Default dummy if empty, though real data should come from DB
    final data = topPacs.isNotEmpty 
        ? topPacs.map((p) => {'name': p.name, 'val': p.totalAnggota}).toList()
        : [
            {'name': 'Belum ada data', 'val': 0},
          ];
    
    final maxVal = data.fold<double>(1.0, (max, item) => (item['val'] as int) > max ? (item['val'] as int).toDouble() : max);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.military_tech, size: 18, color: Colors.orange),
                const SizedBox(width: 8),
                const Text('Top 5 PAC Paling Aktif', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              ],
            ),
            const SizedBox(height: 24),
            ...data.map((item) {
              final val = (item['val'] as int).toDouble();
              final proportion = val / maxVal;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'] as String,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Stack(
                            children: [
                              Container(
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: proportion,
                                child: Container(
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 24,
                          child: Text(
                            '${item['val']}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSebaranDataChart(Color primaryColor, DashboardMonitoringState state) {
    final d = state.data;
    final totalAnggota = d?.totalAnggota.toDouble() ?? 442.0;
    final totalAdministrasi = d?.totalAdministrasi.toDouble() ?? 429.0;
    final pacAktif = d?.pacAktif.toDouble() ?? 20.0;
    // Scale up PAC visually if it's very small compared to the others
    final pacScaled = pacAktif * 10; 

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.pie_chart, size: 18, color: Colors.blue),
                const SizedBox(width: 8),
                const Text('Sebaran Data', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 60,
                      sections: [
                        PieChartSectionData(color: Colors.blue, value: totalAnggota, title: '', radius: 24),
                        PieChartSectionData(color: Colors.orange, value: totalAdministrasi, title: '', radius: 24),
                        PieChartSectionData(color: Colors.cyan, value: pacScaled, title: '', radius: 24), // PAC (*10 for visibility)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Anggota', Colors.blue),
                const SizedBox(width: 16),
                _buildLegendItem('Administrasi', Colors.orange),
                const SizedBox(width: 16),
                _buildLegendItem('PAC', Colors.cyan),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(title, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildRincianKlasemenTable(DashboardMonitoringState state) {
    final topPacs = state.data?.topPacs ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text('Rincian Klasemen Lengkap', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ),
            const Divider(height: 1, thickness: 1, color: Colors.black12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowHeight: 40,
                dataRowMinHeight: 48,
                dataRowMaxHeight: 48,
                horizontalMargin: 20,
                columnSpacing: 24,
                headingTextStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                dataTextStyle: const TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                columns: const [
                  DataColumn(label: Text('#')),
                  DataColumn(label: Text('NAMA PAC')),
                  DataColumn(label: Text('ANGGOTA')),
                  DataColumn(label: Text('ARSIP SURAT')),
                  DataColumn(label: Text('SKOR')),
                ],
                rows: List.generate(topPacs.length, (index) {
                  final pac = topPacs[index];
                  final isFirst = index == 0;
                  final rank = index + 1;
                  final skor = pac.totalAnggota; // Assume score is member count

                  return DataRow(
                    color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) => isFirst ? Colors.orange.shade50 : null),
                    cells: [
                      DataCell(isFirst 
                        ? const Icon(Icons.military_tech, color: Colors.orange, size: 16) 
                        : Text('$rank', style: const TextStyle(color: Colors.grey))),
                      DataCell(Text(pac.name)),
                      DataCell(Text('${pac.totalAnggota}')),
                      DataCell(Text('${pac.totalArsipSurat}')),
                      DataCell(Text('$skor', style: TextStyle(color: isFirst ? Colors.orange : AppColors.textPrimary, fontWeight: isFirst ? FontWeight.bold : FontWeight.w600))),
                    ]
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

}
