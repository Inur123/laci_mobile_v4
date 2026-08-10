import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:laci_mobile/utils/app_colors.dart';
import 'package:laci_mobile/widgets/custom_text_field.dart';
import 'package:toastification/toastification.dart';

class FormSpScreen extends StatefulWidget {
  final bool isCabang;
  final bool isEdit;

  const FormSpScreen({super.key, this.isCabang = true, this.isEdit = false});

  @override
  State<FormSpScreen> createState() => _FormSpScreenState();
}

class _FormSpScreenState extends State<FormSpScreen> {
  String? _selectedOrganisasi;
  String? _tanggalMulai;
  String? _tanggalBerakhir;
  String? _fileName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: (widget.isCabang
                  ? AppColors.cabangPrimary
                  : AppColors.pacPrimary)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isEdit ? 'Edit Berkas SP' : 'Tambah Berkas SP',
          style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.black.withOpacity(0.05), height: 1.0),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              children: [
                CustomTextField(
                  label: 'Nama Pimpinan *',
                  icon: Icons.groups,
                  isCabang: widget.isCabang,
                ),
                const SizedBox(height: 16),

                _buildPremiumDropdown(
                  label: 'Organisasi *',
                  icon: Icons.security,
                  value: _selectedOrganisasi,
                  hint: 'Pilih Organisasi',
                  onTap: () {
                    _showBottomSheetPicker(
                      title: 'Pilih Organisasi',
                      items: ['IPNU', 'IPPNU'],
                      currentValue: _selectedOrganisasi,
                      onSelected: (val) =>
                          setState(() => _selectedOrganisasi = val),
                    );
                  },
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildPremiumDropdown(
                        label: 'Tanggal Mulai *',
                        icon: Icons.calendar_today,
                        value: _tanggalMulai,
                        hint: 'Pilih',
                        onTap: () {
                          _selectDate(context,
                              (date) => setState(() => _tanggalMulai = date));
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildPremiumDropdown(
                        label: 'Tanggal Berakhir *',
                        icon: Icons.calendar_today,
                        value: _tanggalBerakhir,
                        hint: 'Pilih',
                        onTap: () {
                          _selectDate(
                              context,
                              (date) =>
                                  setState(() => _tanggalBerakhir = date));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                const Text('Catatan (Opsional)',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Tambahkan catatan jika ada...',
                    hintStyle: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 14),
                    contentPadding: const EdgeInsets.all(16),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: widget.isCabang
                                ? AppColors.cabangPrimary
                                : AppColors.pacPrimary)),
                  ),
                ),
                const SizedBox(height: 16),

                // Upload File
                const Text('File Berkas SP',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickFile,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 24),
                    decoration: BoxDecoration(
                      color: (widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: (widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary).withOpacity(0.3),
                          style: BorderStyle.solid),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10)
                            ],
                          ),
                          child: Icon(
                            _fileName != null
                                ? Icons.description
                                : Icons.cloud_upload,
                            color: widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _fileName ?? 'Klik untuk upload',
                          style: TextStyle(
                              color: widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        if (_fileName == null) ...[
                          const SizedBox(height: 8),
                          const Text(
                              'Maksimal 2MB. Format: PDF, Word, atau Gambar',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12)),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),

          // Action Buttons
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Batal',
                        style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      toastification.show(
                        context: context,
                        type: ToastificationType.success,
                        style: ToastificationStyle.flat,
                        showProgressBar: false,
                        primaryColor: Colors.white,
                        icon: const Icon(Icons.check_circle_outline,
                            color: Colors.green),
                        title: const Text('Berkas SP berhasil disimpan!'),
                        alignment: Alignment.topCenter,
                        autoCloseDuration: const Duration(seconds: 3),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Simpan Berkas',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumDropdown({
    required String label,
    required IconData icon,
    required String? value,
    required String hint,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(icon, color: AppColors.textSecondary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value ?? hint,
                    style: TextStyle(
                      color: value != null
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.expand_more,
                    color: AppColors.textSecondary, size: 20),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showBottomSheetPicker({
    required String title,
    required List<String> items,
    required String? currentValue,
    required Function(String) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Text(title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 16),
                ...items.map((item) {
                  final isSelected = item == currentValue;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    title: Text(
                      item,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected
                            ? (widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary)
                            : AppColors.textPrimary,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check,
                            color: widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary)
                        : null,
                    onTap: () {
                      onSelected(item);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(
      BuildContext context, Function(String) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onDateSelected("${picked.day}/${picked.month}/${picked.year}");
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png', 'jpeg'],
    );
    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
      });
    }
  }
}
