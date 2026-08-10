import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:laci_mobile/utils/app_colors.dart';
import 'package:laci_mobile/widgets/custom_text_field.dart';

class FormArsipSuratScreen extends StatefulWidget {
  final bool isCabang;
  final bool isEdit;

  const FormArsipSuratScreen(
      {super.key, this.isCabang = true, this.isEdit = false});

  @override
  State<FormArsipSuratScreen> createState() => _FormArsipSuratScreenState();
}

class _FormArsipSuratScreenState extends State<FormArsipSuratScreen> {
  String? _selectedJenisSurat;
  String? _selectedOrganisasi;
  String? _selectedTanggal;
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.black.withOpacity(0.05), height: 1.0),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: (widget.isCabang
                  ? AppColors.cabangPrimary
                  : AppColors.pacPrimary)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isEdit ? 'Edit Arsip Surat' : 'Tambah Arsip Surat',
          style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              CustomTextField(
                label: 'Nomor Surat *',
                icon: Icons.tag,
                keyboardType: TextInputType.text,
                isCabang: widget.isCabang,
              ),
              const SizedBox(height: 16),
              _buildPremiumDropdown(
                label: 'Jenis Surat *',
                icon: Icons.description,
                value: _selectedJenisSurat,
                hint: 'Pilih Jenis Surat',
                onTap: () {
                  _showBottomSheetPicker(
                    title: 'Pilih Jenis Surat',
                    items: [
                      'Surat Masuk',
                      'Surat Keluar',
                      'Surat Keputusan',
                      'Surat Tugas'
                    ],
                    currentValue: _selectedJenisSurat,
                    onSelected: (val) =>
                        setState(() => _selectedJenisSurat = val),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildPremiumDropdown(
                label: 'Organisasi *',
                icon: Icons.business,
                value: _selectedOrganisasi,
                hint: 'Pilih Organisasi',
                onTap: () {
                  _showBottomSheetPicker(
                    title: 'Pilih Organisasi',
                    items: ['PAC IPNU', 'PAC IPPNU', 'PR IPNU', 'PR IPPNU'],
                    currentValue: _selectedOrganisasi,
                    onSelected: (val) =>
                        setState(() => _selectedOrganisasi = val),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildPremiumDropdown(
                label: 'Tanggal Surat *',
                icon: Icons.calendar_today,
                value: _selectedTanggal,
                hint: 'Pilih tanggal surat',
                onTap: () {
                  _selectDate(context,
                      (date) => setState(() => _selectedTanggal = date));
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Pengirim/Penerima *',
                icon: Icons.people_outline,
                keyboardType: TextInputType.text,
                isCabang: widget.isCabang,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Perihal *',
                icon: Icons.info_outline,
                keyboardType: TextInputType.text,
                isCabang: widget.isCabang,
              ),
              const SizedBox(height: 16),
              const Text(
                'Deskripsi',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Deskripsi singkat mengenai surat (opsional)',
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
              const SizedBox(height: 24),
              const Text('File Surat',
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                                color: AppColors.textSecondary, fontSize: 12)),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                          widget.isEdit ? 'Simpan Perubahan' : 'Simpan Surat',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.transparent),
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
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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
