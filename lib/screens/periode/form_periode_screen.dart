import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laci_mobile/utils/app_colors.dart';
import 'package:laci_mobile/widgets/custom_text_field.dart';
import 'package:laci_mobile/providers/periode_provider.dart';
import 'package:toastification/toastification.dart';

class FormPeriodeScreen extends ConsumerStatefulWidget {
  final bool isEdit;
  final bool isCabang;
  final String? initialName;
  final String? periodeId;
  
  const FormPeriodeScreen({super.key, this.isEdit = false, this.isCabang = true, this.initialName, this.periodeId});

  @override
  ConsumerState<FormPeriodeScreen> createState() => _FormPeriodeScreenState();
}

class _FormPeriodeScreenState extends ConsumerState<FormPeriodeScreen> {
  late TextEditingController _nameController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final nama = _nameController.text.trim();
    if (nama.isEmpty) {
      toastification.show(
        context: context,
        type: ToastificationType.warning,
        style: ToastificationStyle.flat,
        showProgressBar: false,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.orange),
        title: const Text('Nama periode wajib diisi'),
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    setState(() => _isLoading = true);

    String? errorMsg;
    if (widget.isEdit && widget.periodeId != null) {
      errorMsg = await ref.read(periodesProvider.notifier).updatePeriode(widget.periodeId!, nama);
    } else {
      errorMsg = await ref.read(periodesProvider.notifier).create(nama);
    }

    setState(() => _isLoading = false);

    if (errorMsg == null && mounted) {
      toastification.show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.flat,
        showProgressBar: false,
        primaryColor: Colors.white,
        icon: const Icon(Icons.check_circle_outline, color: Colors.green),
        title: Text(widget.isEdit ? 'Periode berhasil diperbarui' : 'Periode berhasil disimpan'),
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 3),
      );
      Navigator.pop(context, true);
    } else if (mounted) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        showProgressBar: false,
        icon: const Icon(Icons.cancel_outlined, color: Colors.red),
        title: Text(errorMsg ?? (widget.isEdit ? 'Gagal memperbarui periode' : 'Gagal menyimpan periode')),
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 4),
      );
    }
  }

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
          icon: Icon(Icons.arrow_back_ios_new, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isEdit ? 'Edit Periode' : 'Tambah Periode Baru',
          style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16),
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
          const SizedBox(height: 8),
          
          CustomTextField(
            label: 'Nama Periode *',
            icon: Icons.local_offer,
            controller: _nameController,
            hintText: 'Contoh: Masa Khidmat 2024-2026',
          ),

          const SizedBox(height: 32),

          // Buttons
          Row(
            children: [
              Expanded(
                flex: 1,
                child: OutlinedButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text('Batal', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20, width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(widget.isEdit ? 'Perbarui Periode' : 'Simpan Periode', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
