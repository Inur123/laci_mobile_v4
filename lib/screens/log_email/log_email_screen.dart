import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laci_mobile/utils/app_colors.dart';

class LogEmailScreen extends StatefulWidget {
  final bool isCabang;
  const LogEmailScreen({super.key, this.isCabang = true});

  @override
  State<LogEmailScreen> createState() => _LogEmailScreenState();
}

class _LogEmailScreenState extends State<LogEmailScreen> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary;

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
        title: const Text(
          'Log Email',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          _buildStatsHorizontalScroll(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _buildFilterSection(primaryColor),
          ),
          const Divider(height: 1, thickness: 1, color: Colors.black12),
          _buildEmailList(),
        ],
      ),
    );
  }

  Widget _buildStatsHorizontalScroll() {
    final stats = [
      {'title': 'HARI INI', 'value': '0', 'icon': CupertinoIcons.calendar, 'color': Colors.blue},
      {'title': 'TOTAL', 'value': '250', 'icon': CupertinoIcons.mail, 'color': Colors.grey.shade700},
      {'title': 'TERKIRIM', 'value': '247', 'icon': CupertinoIcons.check_mark_circled, 'color': Colors.green},
      {'title': 'GAGAL', 'value': '3', 'icon': CupertinoIcons.xmark_circle, 'color': Colors.red},
    ];

    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: stats.length,
        itemBuilder: (context, index) {
          final item = stats[index];
          return _buildStatCard(
            item['title'] as String,
            item['value'] as String,
            item['icon'] as IconData,
            item['color'] as Color,
          );
        },
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
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
                ),
              ),
              const SizedBox(width: 4),
              Icon(icon, size: 14, color: color),
            ],
          ),
          Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildFilterSection(Color primaryColor) {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari penerima atau subjek...',
                  hintStyle: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              icon: const Icon(CupertinoIcons.slider_horizontal_3, size: 18, color: AppColors.textPrimary),
              onPressed: () {
                _showFilterModal(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailList() {
    final emails = [
      {
        'waktu': '27 Mei 2026, 19.14',
        'penerima': 'pelajarnumagetan@gmail.com',
        'subjek': '[NOTIFIKASI] Pengajuan Baru: PAC IPNU IPPNU PANEKAN',
        'jenis': 'Pengajuan Admin',
        'status': 'Terkirim',
      },
      {
        'waktu': '27 Mei 2026, 19.13',
        'penerima': 'pelajarnupanekan@gmail.com',
        'subjek': 'Pengajuan Berhasil: PAC IPNU IPPNU PANEKAN - 0...',
        'jenis': 'Pengajuan User',
        'status': 'Terkirim',
      },
      {
        'waktu': '25 Mei 2026, 20.03',
        'penerima': 'pacipnuippnuplaosan2@gmail.com',
        'subjek': 'Status Akun: TERVERIFIKASI - PAC PLAOSAN (Laci ...',
        'jenis': 'Sukses Verif',
        'status': 'Terkirim',
      },
      {
        'waktu': '25 Mei 2026, 20.00',
        'penerima': 'pacipnuippnuplaosan2@gmail.com',
        'subjek': 'Verifikasi Email: PAC PLAOSAN (Laci Digital)',
        'jenis': 'Verifikasi',
        'status': 'Terkirim',
      },
      {
        'waktu': '24 Mei 2026, 11.40',
        'penerima': 'muhammadzainurr11@gmail.com',
        'subjek': 'Update Pengajuan: DITOLAK - QA LACI 2',
        'jenis': 'Status Pengajuan',
        'status': 'Terkirim',
      },
      {
        'waktu': '24 Mei 2026, 11.16',
        'penerima': 'muhammadzainurr11@gmail.com',
        'subjek': 'Verifikasi Email: QA LACI 2 (Laci Digital)',
        'jenis': 'Verifikasi',
        'status': 'Gagal',
      },
    ];

    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        itemCount: emails.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = emails[index];
          final isSukses = item['status'] == 'Terkirim';
          
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black.withOpacity(0.05)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Penerima & Status)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.mail_solid, size: 16, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item['penerima'] as String,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSukses ? Colors.green.shade50 : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSukses ? Colors.green.shade200 : Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSukses ? CupertinoIcons.check_mark_circled_solid : CupertinoIcons.xmark_circle_fill, 
                            size: 12, 
                            color: isSukses ? Colors.green : Colors.red
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item['status'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isSukses ? Colors.green.shade700 : Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Subjek Email
                Text(
                  item['subjek'] as String,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                const Divider(height: 1, thickness: 1, color: Colors.black12),
                const SizedBox(height: 12),
                
                // Footer (Jenis & Waktu)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item['jenis'] as String,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(CupertinoIcons.clock, size: 12, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          item['waktu'] as String,
                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showFilterModal(BuildContext context) {
    String selectedJenis = 'Semua Jenis';
    String selectedStatus = 'Semua Status';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
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
                      const Text('Filter Log Email',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      IconButton(
                        icon: const Icon(CupertinoIcons.clear, color: AppColors.textSecondary),
                        onPressed: () => Navigator.pop(context),
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Filter Jenis Email
                  const Text('Jenis Email',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedJenis,
                        isExpanded: true,
                        items: ['Semua Jenis', 'Pengajuan Admin', 'Pengajuan User', 'Sukses Verif', 'Verifikasi', 'Status Pengajuan']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedJenis = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Filter Status
                  const Text('Status Pengiriman',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedStatus,
                        isExpanded: true,
                        items: ['Semua Status', 'Terkirim', 'Gagal'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedStatus = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      child: const Text('Terapkan Filter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
