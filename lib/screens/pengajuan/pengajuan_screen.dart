import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laci_mobile/screens/pengajuan/detail_pengajuan_screen.dart';
import 'package:laci_mobile/utils/app_colors.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:toastification/toastification.dart';

class PengajuanScreen extends StatefulWidget {
  final bool isCabang;
  
  const PengajuanScreen({super.key, this.isCabang = true});

  @override
  State<PengajuanScreen> createState() => _PengajuanScreenState();
}

class _PengajuanScreenState extends State<PengajuanScreen> {
  // Dummy Data based on Web Screenshot
  final List<Map<String, dynamic>> dummyData = [
    {
      'no_surat': '019/PAC/A/VIII-VIII/7...',
      'pengaju': 'Pac Ipnu Ippnu Panekan',
      'periode': '2025-2027',
      'penerima': 'BERSAMA',
      'tanggal': '28 Jul 2026',
      'keperluan': 'Pemberitahuan Kegiatan',
      'status': 'Diterima',
    },
    {
      'no_surat': '073/Pan-Pel/A/VIII/7...',
      'pengaju': 'Pac Barat',
      'periode': '2025-2027',
      'penerima': 'BERSAMA',
      'tanggal': '12 Jul 2026',
      'keperluan': 'Permohonan Baiat',
      'status': 'Pending',
    },
    {
      'no_surat': '068/Pan-Pel/A/VIII/7...',
      'pengaju': 'Pac Barat',
      'periode': '2025-2027',
      'penerima': 'IPPNU',
      'tanggal': '11 Jul 2026',
      'keperluan': 'Permohonan Pemateri Ippnu',
      'status': 'Ditolak',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Pengajuan Berkas',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
        ),
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
                _buildStatCard('TOTAL', '28', CupertinoIcons.doc_text, Colors.blue),
                _buildStatCard('PENDING', '0', CupertinoIcons.clock, Colors.orange),
                _buildStatCard('DITERIMA', '28', CupertinoIcons.checkmark_shield, Colors.green),
                _buildStatCard('DITOLAK', '0', CupertinoIcons.xmark_shield, Colors.red),
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
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari nomor surat, pengaju...',
                        hintStyle: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        isDense: true,
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
                    icon: const Icon(CupertinoIcons.slider_horizontal_3, size: 20, color: AppColors.textPrimary),
                    onPressed: () {
                      _showFilterModal(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1, thickness: 1, color: Colors.black12),
          
          // LIST PENGAJUAN
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              itemCount: dummyData.length,
              itemBuilder: (context, index) {
                final item = dummyData[index];
                return _buildPengajuanCard(item);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: widget.isCabang 
          ? null 
          : FloatingActionButton.extended(
              onPressed: () {},
              backgroundColor: AppColors.pacPrimary,
              icon: const Icon(CupertinoIcons.add, color: Colors.white),
              label: const Text('Buat Pengajuan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

  Widget _buildPengajuanCard(Map<String, dynamic> item) {
    Color statusColor;
    Color statusBg;
    if (item['status'] == 'Diterima') {
      statusColor = Colors.green.shade700;
      statusBg = Colors.green.shade50;
    } else if (item['status'] == 'Pending') {
      statusColor = Colors.orange.shade700;
      statusBg = Colors.orange.shade50;
    } else {
      statusColor = Colors.red.shade700;
      statusBg = Colors.red.shade50;
    }

    Color penerimaColor;
    Color penerimaBg;
    if (item['penerima'] == 'BERSAMA') {
      penerimaColor = Colors.blue.shade700;
      penerimaBg = Colors.blue.shade50;
    } else if (item['penerima'] == 'IPPNU') {
      penerimaColor = Colors.pink.shade700;
      penerimaBg = Colors.pink.shade50;
    } else {
      penerimaColor = Colors.green.shade700;
      penerimaBg = Colors.green.shade50;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPengajuanScreen(
                data: item,
                isCabang: widget.isCabang,
              ),
            ),
          );
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
                    child: Text(
                      item['no_surat'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusBg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: statusColor.withOpacity(0.3)),
                        ),
                        child: Text(
                          item['status'],
                          style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 4),
                      PopupMenuButton<String>(
                        icon: const Icon(CupertinoIcons.ellipsis, size: 20, color: AppColors.textSecondary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        color: Colors.white,
                        onSelected: (value) {
                          if (value == 'lihat') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPengajuanScreen(
                                  data: item,
                                  isCabang: widget.isCabang,
                                ),
                              ),
                            );
                          } else if (value == 'hapus') {
                            _showDeleteDialog(context);
                          }
                        },
                        itemBuilder: (context) => [
                          _buildPopupMenuItem('lihat', CupertinoIcons.eye, 'Lihat Detail'),
                          _buildPopupMenuItem('hapus', CupertinoIcons.trash, 'Hapus', isDestructive: true),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(CupertinoIcons.person_solid, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item['pengaju'],
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(CupertinoIcons.doc_plaintext, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item['keperluan'],
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(height: 1, thickness: 1, color: Colors.black12),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(CupertinoIcons.calendar, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(item['tanggal'], style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: penerimaColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: penerimaColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      item['penerima'],
                      style: TextStyle(color: penerimaColor, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
    String selectedStatus = 'Semua Status';
    String selectedPenerima = 'Semua Penerima';
    String selectedPac = 'Semua PAC';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Filter Pengajuan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        child: const Text('Batal', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Status', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedStatus,
                        isExpanded: true,
                        icon: const Icon(CupertinoIcons.chevron_down, size: 16),
                        items: ['Semua Status', 'Pending', 'Diterima', 'Ditolak'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => selectedStatus = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Penerima', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedPenerima,
                        isExpanded: true,
                        icon: const Icon(CupertinoIcons.chevron_down, size: 16),
                        items: ['Semua Penerima', 'IPNU', 'IPPNU', 'BERSAMA', 'CBP KPP'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => selectedPenerima = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Filter PAC', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedPac,
                        isExpanded: true,
                        icon: const Icon(CupertinoIcons.chevron_down, size: 16),
                        items: ['Semua PAC', 'Pac Barat', 'Pac Bendo', 'Pac Ipnu Ippnu Panekan', 'Pac Ipnu Ippnu Sukomoro'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => selectedPac = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
      },
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final result = await showOkCancelAlertDialog(
      context: context,
      title: 'Hapus Pengajuan',
      message: 'Apakah Anda yakin ingin menghapus data pengajuan ini?',
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
          title: const Text('Pengajuan berhasil dihapus'),
          alignment: Alignment.topCenter,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    }
  }
}
