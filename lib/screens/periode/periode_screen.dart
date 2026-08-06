import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laci_mobile/utils/app_colors.dart';
import 'package:laci_mobile/screens/periode/form_periode_screen.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:toastification/toastification.dart';

class PeriodeScreen extends StatefulWidget {
  final bool isCabang;
  const PeriodeScreen({super.key, this.isCabang = true});

  @override
  State<PeriodeScreen> createState() => _PeriodeScreenState();
}

class _PeriodeScreenState extends State<PeriodeScreen> {
  int _displayedPeriodeIndex = 1; // dummy index for 'Sedang Ditampilkan'
  int _activePeriodeIndex = 1; // dummy index for 'Aktif'

  final List<Map<String, dynamic>> _periodes = [
    {
      'nama': '2027-2029',
      'dibuat': '5 Agustus 2026',
    },
    {
      'nama': '2025-2027',
      'dibuat': '27 April 2026',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary;

    return Scaffold(
      backgroundColor: AppColors.background,
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
          'Daftar Periode',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.black.withOpacity(0.05), height: 1.0),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: [
          // List Periode
          ...List.generate(_periodes.length, (index) => _buildPeriodeCard(index, primaryColor)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FormPeriodeScreen(isCabang: widget.isCabang)));
        },
        backgroundColor: primaryColor,
        child: const Icon(CupertinoIcons.add, color: Colors.white),
      ),
    );
  }



  Widget _buildPeriodeCard(int index, Color primaryColor) {
    final periode = _periodes[index];
    final isDisplayed = index == _displayedPeriodeIndex;
    final isActive = index == _activePeriodeIndex;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDisplayed ? Colors.blue.withOpacity(0.02) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDisplayed ? Colors.blue.withOpacity(0.5) : Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  periode['nama'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary),
                ),
              ),
              if (isActive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: const Text('Aktif', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text('Dibuat: ${periode['dibuat']}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (isDisplayed)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.eye_fill, color: Colors.white, size: 14),
                      SizedBox(width: 6),
                      Text('Sedang Ditampilkan', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              else
                InkWell(
                  onTap: () {
                    setState(() => _displayedPeriodeIndex = index);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.eye, color: AppColors.textPrimary, size: 14),
                        SizedBox(width: 6),
                        Text('Tampilkan', style: TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),

              if (!isActive)
                InkWell(
                  onTap: () {
                    setState(() => _activePeriodeIndex = index);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.check_mark_circled, color: AppColors.textPrimary, size: 14),
                        SizedBox(width: 6),
                        Text('Aktifkan', style: TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FormPeriodeScreen(isEdit: true, isCabang: widget.isCabang, initialName: periode['nama'])));
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.pencil, color: AppColors.textPrimary, size: 14),
                      SizedBox(width: 6),
                      Text('Edit', style: TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),

              InkWell(
                onTap: () => _showDeleteDialog(context),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(CupertinoIcons.trash, color: Colors.red, size: 16),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final result = await showOkCancelAlertDialog(
      context: context,
      title: 'Hapus Periode',
      message: 'Apakah Anda yakin ingin menghapus periode ini? Data yang terkait mungkin tidak akan tampil dengan benar.',
      okLabel: 'Hapus',
      cancelLabel: 'Batal',
      isDestructiveAction: true,
    );
    if (result == OkCancelResult.ok && context.mounted) {
      toastification.show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.flat,
        showProgressBar: false,
        primaryColor: Colors.white,
        icon: const Icon(Icons.check_circle_outline, color: Colors.green),
        title: const Text('Periode berhasil dihapus'),
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }
}
