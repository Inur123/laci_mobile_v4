import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:laci_mobile/utils/app_colors.dart';
import 'package:laci_mobile/widgets/custom_text_field.dart';
import 'package:toastification/toastification.dart';

class FormBerkasCabangScreen extends StatefulWidget {
  final bool isEdit;
  final bool isCabang;
  
  const FormBerkasCabangScreen({super.key, this.isEdit = false, this.isCabang = true});

  @override
  State<FormBerkasCabangScreen> createState() => _FormBerkasCabangScreenState();
}

class _FormBerkasCabangScreenState extends State<FormBerkasCabangScreen> {
  String? _tanggal;
  String? _fileName;

  @override
  Widget build(BuildContext context) {
    final title = widget.isCabang ? 'Berkas Cabang' : 'Berkas PAC';
    
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
          icon: Icon(Icons.arrow_back_ios_new, color: widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isEdit ? 'Edit $title' : 'Tambah $title',
          style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: 'Nama *',
                        icon: Icons.description,
                        isCabang: widget.isCabang,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildPremiumDropdown(
                        label: 'Tanggal *',
                        icon: Icons.calendar_today,
                        value: _tanggal,
                        hint: 'Pilih tanggal',
                        onTap: () {
                          _selectDate(context, (date) => setState(() => _tanggal = date));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                const Text('Catatan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Catatan tambahan (opsional)',
                    hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    contentPadding: const EdgeInsets.all(16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary)),
                  ),
                ),
                const SizedBox(height: 16),

                const Text('File Berkas *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickFile,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    decoration: BoxDecoration(
                      color: (widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: (widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary).withOpacity(0.3), style: BorderStyle.solid),
                    ),
                    child: widget.isEdit && _fileName == null
                    ? Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                child: const Icon(Icons.description, color: Colors.blueGrey, size: 24),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'File Lampiran (Tersimpan)', 
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Text('File saat ini', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.visibility_outlined, color: widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary, size: 20),
                              const SizedBox(width: 16),
                              const Icon(Icons.close, color: Colors.red, size: 20),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.grey.shade300)
                            ),
                            child: const Text('Ganti file', textAlign: TextAlign.center, style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                            ),
                            child: Icon(
                              _fileName != null ? Icons.description : Icons.cloud_upload, 
                              color: widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary, 
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _fileName ?? 'Klik untuk upload', 
                            style: TextStyle(color: widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          if (_fileName == null) ...[
                            const SizedBox(height: 8),
                            const Text('Maksimal 5MB. Format: PDF, Word, PPT, atau Gambar (JPG/PNG).', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          ],
                        ],
                      ),
                  ),
                ),
                
                if (widget.isEdit) ...[
                  const SizedBox(height: 32),
                  const Text('Preview PDF', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.manage_search, size: 16, color: widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary),
                      const SizedBox(width: 8),
                      Text('Pratinjau PDF', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary)),
                      const Spacer(),
                      const Icon(Icons.open_in_new, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      const Text('Layar Penuh', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 400,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.article, color: Colors.white54, size: 48),
                          SizedBox(height: 16),
                          Text('PDF Preview Placeholder', style: TextStyle(color: Colors.white)),
                          Text('Menampilkan dokumen Cabang PDF', style: TextStyle(color: Colors.white54, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ],
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Batal', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
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
                        icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                        title: Text('$title berhasil disimpan!'),
                        alignment: Alignment.topCenter,
                        autoCloseDuration: const Duration(seconds: 3),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Simpan Berkas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
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
                      color: value != null ? AppColors.textPrimary : AppColors.textSecondary,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, Function(String) onDateSelected) async {
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
      allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'jpg', 'png', 'jpeg'],
    );
    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
      });
    }
  }
}
