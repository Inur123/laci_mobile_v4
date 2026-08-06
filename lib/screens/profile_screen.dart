import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:laci_mobile/utils/app_colors.dart';
import 'package:laci_mobile/widgets/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  final bool isCabang;
  const ProfileScreen({super.key, this.isCabang = true});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEmailVerified = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _photoFileName;

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
        title: const Text(
          'Profil Saya',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16),
        ),
        actions: [
          // Tombol sementara untuk melihat perbedaan UI saat verif/belum
          IconButton(
            icon: Icon(
              _isEmailVerified ? CupertinoIcons.checkmark_seal_fill : CupertinoIcons.exclamationmark_triangle_fill,
              color: _isEmailVerified ? Colors.green : Colors.orange,
            ),
            tooltip: 'Toggle Status Verifikasi (Demo)',
            onPressed: () {
              setState(() {
                _isEmailVerified = !_isEmailVerified;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. BAGIAN FOTO DAN INFO AKUN
              const SizedBox(height: 16),
              _buildProfileHeader(),
              const SizedBox(height: 32),

              // 2. BAGIAN INFORMASI PRIBADI
              _buildSectionCard(
                title: 'Informasi Pribadi',
                icon: CupertinoIcons.person,
                children: [
                  CustomTextField(
                    isCabang: widget.isCabang,
                    label: 'Nama Pimpinan',
                    icon: CupertinoIcons.person_fill,
                    keyboardType: TextInputType.text,
                    // Di dunia nyata ini diisi initialValue controller
                  ),
                  const SizedBox(height: 16),
                  
                  // Bagian Email Khusus (Ada Status Verifikasi)
                  const Text('Alamat Email', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'lacipelajarnumagetan@gmail.com',
                      hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
                      prefixIcon: const Icon(CupertinoIcons.mail_solid, color: Colors.black45, size: 20),
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: _isEmailVerified ? Colors.grey.shade300 : Colors.orange.shade300)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: _isEmailVerified ? Colors.grey.shade300 : Colors.orange.shade300)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: primaryColor)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Badge Status Pindah ke Bawah (Sesuai Desain Web)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _isEmailVerified ? Colors.green.shade50 : Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _isEmailVerified ? Colors.green.shade200 : Colors.orange.shade200),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isEmailVerified ? CupertinoIcons.checkmark_seal_fill : CupertinoIcons.exclamationmark_triangle_fill,
                              color: _isEmailVerified ? Colors.green : Colors.orange,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _isEmailVerified ? 'Terverifikasi' : 'Belum Verifikasi',
                              style: TextStyle(
                                color: _isEmailVerified ? Colors.green.shade700 : Colors.orange.shade800,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  // Jika belum verif, tampilkan peringatan & tombol kirim ulang
                  if (!_isEmailVerified) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.info_circle_fill, color: Colors.orange, size: 20),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Email Anda belum diverifikasi. Beberapa fitur mungkin dibatasi.',
                              style: TextStyle(fontSize: 12, color: Colors.black87),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('Kirim Ulang', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
                          )
                        ],
                      ),
                    ),
                  ]
                ],
              ),
              
              const SizedBox(height: 24),

              // 3. BAGIAN KEAMANAN (UBAH PASSWORD)
              _buildSectionCard(
                title: 'Keamanan',
                icon: CupertinoIcons.lock_shield,
                children: [
                  const Text(
                    'Minimal 6 karakter untuk keamanan ekstra. Kosongkan jika tidak ingin mengubah password.',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  
                  // Password Baru
                  CustomTextField(
                    label: 'Password Baru',
                    icon: CupertinoIcons.lock_fill,
                    hintText: 'Kosongkan jika tidak diubah',
                    isPassword: true,
                    obscureText: _obscurePassword,
                    onTogglePassword: () => setState(() => _obscurePassword = !_obscurePassword),
                    isCabang: widget.isCabang,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Konfirmasi Password
                  CustomTextField(
                    label: 'Konfirmasi Password',
                    icon: CupertinoIcons.lock_fill,
                    hintText: 'Konfirmasi password baru',
                    isPassword: true,
                    obscureText: _obscureConfirmPassword,
                    onTogglePassword: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    isCabang: widget.isCabang,
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // 4. TOMBOL AKSI
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
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
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Perbarui Profil', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // 5. TOMBOL LOGOUT
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    // TODO: Implementasi logika logout
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.red.withOpacity(0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(CupertinoIcons.square_arrow_right, color: Colors.red),
                  label: const Text('Keluar dari Akun', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                image: const DecorationImage(
                  image: NetworkImage('https://ui-avatars.com/api/?name=Sekretaris+Cabang&background=1565C0&color=fff&size=256'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            InkWell(
              onTap: _pickPhoto,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade600,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(CupertinoIcons.camera_fill, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Sekretaris Cabang',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Text(
            'SEKRETARIS CABANG',
            style: TextStyle(color: Colors.blue.shade700, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'ID: ipnuippnu-admin-cabang',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontFamily: 'monospace'),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _photoFileName ?? 'Klik ikon kamera untuk ganti foto baru. Maks 2MB.',
          style: TextStyle(color: _photoFileName != null ? Colors.blue.shade700 : Colors.grey, fontSize: 11, fontWeight: _photoFileName != null ? FontWeight.bold : FontWeight.normal),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue.shade700, size: 22),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Colors.black12),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
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
