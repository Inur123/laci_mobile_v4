// ignore_for_file: prefer_final_fields

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:laci_mobile/utils/app_colors.dart';
import 'package:laci_mobile/widgets/custom_text_field.dart';

class FormAnggotaScreen extends StatefulWidget {
  final bool isCabang;
  final bool isEdit;

  const FormAnggotaScreen(
      {super.key, this.isCabang = true, this.isEdit = false});

  @override
  State<FormAnggotaScreen> createState() => _FormAnggotaScreenState();
}

class _FormAnggotaScreenState extends State<FormAnggotaScreen> {
  // State for dynamic lists
  List<int> _pengkaderanList = [];
  List<int> _pendidikanList = [];
  int _pengkaderanCounter = 0;
  int _pendidikanCounter = 0;

  // Form states
  String? _selectedJenisKelamin;
  String? _selectedTanggalLahir;
  String? _photoFileName;

  // States for dynamic forms (just to store values for UI display)
  Map<int, String> _selectedpengkaderan = {};
  Map<int, String> _selectedTanggalpengkaderan = {};
  Map<int, String> _selectedPendidikan = {};

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
          icon: Icon(CupertinoIcons.back,
              color: (widget.isCabang
                  ? AppColors.cabangPrimary
                  : AppColors.pacPrimary)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isEdit ? 'Edit Data Anggota' : 'Tambah Anggota',
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
              // 1. FOTO ANGGOTA
              _buildSectionTitle('Foto Anggota', CupertinoIcons.camera),
              const SizedBox(height: 16),
              Center(
                child: InkWell(
                  onTap: _pickPhoto,
                  borderRadius: BorderRadius.circular(75),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: _photoFileName != null
                          ? Colors.blue.shade50
                          : Colors.grey.shade400,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                            _photoFileName != null
                                ? CupertinoIcons.checkmark_seal_fill
                                : CupertinoIcons.cloud_upload,
                            color: _photoFileName != null
                                ? Colors.blue
                                : Colors.white,
                            size: 32),
                        const SizedBox(height: 8),
                        Text(
                            _photoFileName != null
                                ? 'Foto Terpilih'
                                : 'Upload Foto',
                            style: TextStyle(
                                color: _photoFileName != null
                                    ? Colors.blue
                                    : Colors.white,
                                fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text('Format: JPG, PNG. Maks 2MB.',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Divider(thickness: 1, color: Colors.black12),
              ),

              // 2. INFORMASI PERSONAL
              _buildSectionTitle(
                  'Informasi Personal', CupertinoIcons.person_alt),
              const SizedBox(height: 8),
              const Text('Lengkapi data diri anggota sesuai identitas resmi.',
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              const SizedBox(height: 24),

              CustomTextField(
                  isCabang: widget.isCabang,
                  label: 'Nama Lengkap *',
                  icon: CupertinoIcons.person,
                  keyboardType: TextInputType.text),
              const SizedBox(height: 16),
              CustomTextField(
                  isCabang: widget.isCabang,
                  label: 'Email',
                  icon: CupertinoIcons.mail,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              CustomTextField(
                  isCabang: widget.isCabang,
                  label: 'NIK (Nomor Induk Kependudukan)',
                  icon: CupertinoIcons.creditcard,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              CustomTextField(
                  isCabang: widget.isCabang,
                  label: 'NIA (Nomor Induk Anggota)',
                  icon: CupertinoIcons.number_square,
                  keyboardType: TextInputType.text),
              const SizedBox(height: 16),

              _buildPremiumDropdown(
                label: 'Jenis Kelamin *',
                icon: CupertinoIcons.person_2,
                value: _selectedJenisKelamin,
                hint: 'Pilih Jenis Kelamin',
                onTap: () {
                  _showBottomSheetPicker(
                    title: 'Pilih Jenis Kelamin',
                    items: ['Laki-laki', 'Perempuan'],
                    currentValue: _selectedJenisKelamin,
                    onSelected: (val) =>
                        setState(() => _selectedJenisKelamin = val),
                  );
                },
              ),

              const SizedBox(height: 16),
              CustomTextField(
                  isCabang: widget.isCabang,
                  label: 'Nomor Handphone (WA)',
                  icon: CupertinoIcons.phone,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 16),

              // Tempat Lahir & Tanggal Lahir (Dibuat vertikal agar tidak mepet)
              CustomTextField(
                  isCabang: widget.isCabang,
                  label: 'Tempat Lahir',
                  icon: CupertinoIcons.location,
                  keyboardType: TextInputType.text),
              const SizedBox(height: 16),
              _buildPremiumDropdown(
                label: 'Tanggal Lahir',
                icon: CupertinoIcons.calendar,
                value: _selectedTanggalLahir,
                hint: 'Pilih tanggal',
                onTap: () {
                  _selectDate(context,
                      (date) => setState(() => _selectedTanggalLahir = date));
                },
              ),

              const SizedBox(height: 16),
              CustomTextField(
                  isCabang: widget.isCabang,
                  label: 'Alamat Lengkap',
                  icon: CupertinoIcons.map,
                  keyboardType: TextInputType.text),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Divider(thickness: 1, color: Colors.black12),
              ),

              // 3. RIWAYAT pengkaderan (DYNAMIC)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle('Riwayat pengkaderan',
                      CupertinoIcons.badge_plus_radiowaves_right),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _pengkaderanCounter++;
                        _pengkaderanList.add(_pengkaderanCounter);
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: const [
                          Icon(CupertinoIcons.add,
                              color: Colors.blue, size: 16),
                          SizedBox(width: 4),
                          Text('Tambah',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              if (_pengkaderanList.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black12, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text('Belum ada data pengkaderan.',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                  ),
                )
              else
                ..._pengkaderanList.map((id) => _buildpengkaderanForm(id)),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Divider(thickness: 1, color: Colors.black12),
              ),

              // 4. INFORMASI ORGANISASI & TAMBAHAN
              _buildSectionTitle('Informasi Organisasi & Tambahan',
                  CupertinoIcons.building_2_fill),
              const SizedBox(height: 24),
              CustomTextField(
                  isCabang: widget.isCabang,
                  label: 'Jabatan',
                  icon: CupertinoIcons.briefcase,
                  keyboardType: TextInputType.text),
              const SizedBox(height: 16),
              CustomTextField(
                  isCabang: widget.isCabang,
                  label: 'Nomor RFID',
                  icon: CupertinoIcons.creditcard_fill,
                  keyboardType: TextInputType.text),
              const SizedBox(height: 16),
              CustomTextField(
                  isCabang: widget.isCabang,
                  label: 'Pekerjaan',
                  icon: CupertinoIcons.hammer,
                  keyboardType: TextInputType.text),
              const SizedBox(height: 16),
              CustomTextField(
                  isCabang: widget.isCabang,
                  label: 'Hobi / Minat Bakat',
                  icon: CupertinoIcons.heart,
                  keyboardType: TextInputType.text),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Divider(thickness: 1, color: Colors.black12),
              ),

              // 5. RIWAYAT PENDIDIKAN (DYNAMIC)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle('Riwayat Pendidikan', CupertinoIcons.book),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _pendidikanCounter++;
                        _pendidikanList.add(_pendidikanCounter);
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: const [
                          Icon(CupertinoIcons.add,
                              color: Colors.blue, size: 16),
                          SizedBox(width: 4),
                          Text('Tambah',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              if (_pendidikanList.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black12, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text('Belum ada data pendidikan.',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                  ),
                )
              else
                ..._pendidikanList.map((id) => _buildPendidikanForm(id)),

              const SizedBox(height: 40),
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
                    widget.isEdit
                        ? 'Simpan Perubahan'
                        : 'Simpan Data Anggota',
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

  Widget _buildpengkaderanForm(int id) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Data pengkaderan',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
              InkWell(
                onTap: () {
                  setState(() => _pengkaderanList.remove(id));
                },
                child: const Icon(CupertinoIcons.trash,
                    color: Colors.red, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPremiumDropdown(
            label: 'Nama pengkaderan',
            icon: CupertinoIcons.badge_plus_radiowaves_right,
            value: _selectedpengkaderan[id],
            hint: 'Pilih pengkaderan',
            onTap: () {
              _showBottomSheetPicker(
                title: 'Pilih pengkaderan',
                items: ['Makesta', 'Lakmud', 'Lakut', 'Latin', 'Latpel'],
                currentValue: _selectedpengkaderan[id],
                onSelected: (val) =>
                    setState(() => _selectedpengkaderan[id] = val),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildPremiumDropdown(
            label: 'Tanggal',
            icon: CupertinoIcons.calendar,
            value: _selectedTanggalpengkaderan[id],
            hint: 'Pilih tanggal',
            onTap: () {
              _selectDate(
                  context,
                  (date) =>
                      setState(() => _selectedTanggalpengkaderan[id] = date));
            },
          ),
          const SizedBox(height: 12),
          CustomTextField(
              isCabang: widget.isCabang,
              label: 'Tempat',
              icon: CupertinoIcons.location,
              keyboardType: TextInputType.text),
        ],
      ),
    );
  }

  Widget _buildPendidikanForm(int id) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Data Pendidikan',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
              InkWell(
                onTap: () {
                  setState(() => _pendidikanList.remove(id));
                },
                child: const Icon(CupertinoIcons.trash,
                    color: Colors.red, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPremiumDropdown(
            label: 'Jenjang Pendidikan',
            icon: CupertinoIcons.book,
            value: _selectedPendidikan[id],
            hint: 'Pilih Jenjang',
            onTap: () {
              _showBottomSheetPicker(
                title: 'Pilih Jenjang Pendidikan',
                items: [
                  'SD/MI',
                  'SMP/MTs',
                  'SMA/MA/SMK',
                  'D3',
                  'S1',
                  'S2',
                  'S3'
                ],
                currentValue: _selectedPendidikan[id],
                onSelected: (val) =>
                    setState(() => _selectedPendidikan[id] = val),
              );
            },
          ),
          const SizedBox(height: 12),
          CustomTextField(
              isCabang: widget.isCabang,
              label: 'Nama Sekolah / Kampus',
              icon: CupertinoIcons.building_2_fill,
              keyboardType: TextInputType.text),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade700, size: 20),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary)),
      ],
    );
  }

  // Desain Dropdown Premium ala iOS / Bottom Sheet
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
                const Icon(CupertinoIcons.chevron_down,
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
                            ? Colors.blue.shade700
                            : AppColors.textPrimary,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(CupertinoIcons.checkmark_alt,
                            color: Colors.blue.shade700)
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
              primary: Colors.blue.shade700,
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

  Future<void> _pickPhoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        _photoFileName = result.files.single.name;
      });
    }
  }
}
