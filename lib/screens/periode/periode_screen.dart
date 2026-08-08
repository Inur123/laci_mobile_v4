import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laci_mobile/utils/app_colors.dart';
import 'package:laci_mobile/screens/periode/form_periode_screen.dart';
import 'package:laci_mobile/providers/periode_provider.dart';
import 'package:laci_mobile/models/periode_model.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:toastification/toastification.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:laci_mobile/widgets/custom_refresh_control.dart';

class PeriodeScreen extends ConsumerStatefulWidget {
  final bool isCabang;
  const PeriodeScreen({super.key, this.isCabang = true});

  @override
  ConsumerState<PeriodeScreen> createState() => _PeriodeScreenState();
}

class _PeriodeScreenState extends ConsumerState<PeriodeScreen> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary;
    final periodesAsync = ref.watch(periodesProvider);
    final viewedPeriode = ref.watch(viewedPeriodeProvider);

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
      body: periodesAsync.when(
        data: (periodes) {
          if (periodes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.calendar_badge_plus, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  const Text('Belum ada periode', style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text('Tap tombol + untuk membuat periode baru', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ],
              ),
            );
          }
          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            slivers: [
              CustomRefreshControl(
                onRefresh: () async => ref.read(periodesProvider.notifier).refresh(),
                primaryColor: primaryColor,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildPeriodeCard(periodes[index], periodes, viewedPeriode, primaryColor),
                    childCount: periodes.length,
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => _buildShimmerLoading(),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.exclamationmark_triangle, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('$error', style: const TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.read(periodesProvider.notifier).refresh(),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormPeriodeScreen(isCabang: widget.isCabang)),
          );
          if (result == true) {
            ref.read(periodesProvider.notifier).refresh();
          }
        },
        backgroundColor: primaryColor,
        child: const Icon(CupertinoIcons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildPeriodeCard(Periode periode, List<Periode> allPeriodes, Periode? viewedPeriode, Color primaryColor) {
    final isActive = periode.isActive;
    
    // Jika viewedPeriode null, berarti yang dilihat = yang aktif
    final isDisplayed = viewedPeriode != null
        ? viewedPeriode.id == periode.id
        : periode.isActive;

    final dateFormat = DateFormat('d MMMM yyyy', 'id_ID');

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
                  periode.nama,
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
          Text('Dibuat: ${dateFormat.format(periode.createdAt)}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          
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
                    ref.read(viewedPeriodeProvider.notifier).state = periode;
                    toastification.show(
                      context: context,
                      type: ToastificationType.info,
                      style: ToastificationStyle.flat,
                      showProgressBar: false,
                      icon: const Icon(CupertinoIcons.eye, color: Colors.blue),
                      title: Text('Menampilkan data "${periode.nama}"'),
                      alignment: Alignment.topCenter,
                      autoCloseDuration: const Duration(seconds: 2),
                    );
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
                  onTap: () async {
                    final success = await ref.read(periodesProvider.notifier).activate(periode.id);
                    if (success && mounted) {
                      // Reset viewed periode ke null (ikut aktif)
                      ref.read(viewedPeriodeProvider.notifier).state = null;
                      toastification.show(
                        context: context,
                        type: ToastificationType.success,
                        style: ToastificationStyle.flat,
                        showProgressBar: false,
                        icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                        title: Text('Periode "${periode.nama}" berhasil diaktifkan'),
                        alignment: Alignment.topCenter,
                        autoCloseDuration: const Duration(seconds: 3),
                      );
                    }
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
                onTap: () async {
                  final result = await Navigator.push(context, MaterialPageRoute(
                    builder: (context) => FormPeriodeScreen(isEdit: true, isCabang: widget.isCabang, initialName: periode.nama, periodeId: periode.id),
                  ));
                  if (result == true) {
                    ref.read(periodesProvider.notifier).refresh();
                  }
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

              if (!isActive)
                InkWell(
                  onTap: () => _showDeleteDialog(context, periode),
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

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black.withOpacity(0.05)),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(height: 20, width: 150, color: Colors.white),
                    Container(height: 20, width: 50, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12))),
                  ],
                ),
                const SizedBox(height: 12),
                Container(height: 14, width: 100, color: Colors.white),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(height: 32, width: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))),
                    const SizedBox(width: 8),
                    Container(height: 32, width: 70, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, Periode periode) async {
    final result = await showOkCancelAlertDialog(
      context: context,
      title: 'Hapus Periode',
      message: 'Apakah Anda yakin ingin menghapus periode "${periode.nama}"? Semua data terkait (anggota, arsip, agenda, presensi) akan ikut terhapus.',
      okLabel: 'Hapus',
      cancelLabel: 'Batal',
      isDestructiveAction: true,
    );
    if (result == OkCancelResult.ok && context.mounted) {
      final success = await ref.read(periodesProvider.notifier).delete(periode.id);
      if (success && context.mounted) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          showProgressBar: false,
          primaryColor: Colors.white,
          icon: const Icon(Icons.check_circle_outline, color: Colors.green),
          title: Text('Periode "${periode.nama}" berhasil dihapus'),
          alignment: Alignment.topCenter,
          autoCloseDuration: const Duration(seconds: 3),
        );
      }
    }
  }
}
