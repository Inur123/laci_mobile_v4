import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:laci_mobile/utils/app_colors.dart';
import 'package:laci_mobile/widgets/custom_text_field.dart';
import 'package:laci_mobile/widgets/custom_refresh_control.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laci_mobile/providers/auth_provider.dart';
import 'package:laci_mobile/screens/login_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toastification/toastification.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final bool isCabang;
  const ProfileScreen({super.key, this.isCabang = true});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _obscureCurrentPassword = true;
  bool _isSaving = false;
  bool _isLoggingOut = false;
  String? _photoFileName;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isInitialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _initControllers(Map<String, dynamic>? user) {
    if (!_isInitialized && user != null) {
      _nameController.text = user['name'] ?? '';
      _emailController.text = user['email'] ?? '';
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary;
    final user = ref.watch(authProvider).user;

    // Initialize controllers with user data once
    _initControllers(user);

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
          style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: _buildBodyContent(primaryColor, user),
      ),
    );
  }

  Widget _buildBodyContent(Color primaryColor, Map<String, dynamic>? user) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading || user == null;
    final isEmailVerified = user?['emailVerified'] == true;

    Widget content = CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: [
        CustomRefreshControl(
          onRefresh: () async {
            await ref.read(authProvider.notifier).fetchProfile();
          },
          primaryColor: primaryColor,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. BAGIAN FOTO DAN INFO AKUN
                const SizedBox(height: 16),
              _buildProfileHeader(user),
              const SizedBox(height: 32),

              // 2. BAGIAN INFORMASI PRIBADI
              _buildSectionCard(
                title: 'Informasi Pribadi',
                icon: Icons.person_outline,
                children: [
                  // Field Nama
                  const Text('Nama Pimpinan',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan Nama Pimpinan',
                      hintStyle:
                          const TextStyle(color: Colors.black38, fontSize: 14),
                      prefixIcon: const Icon(Icons.person,
                          color: Colors.black45, size: 20),
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: primaryColor)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Bagian Email
                  const Text('Alamat Email',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan email baru',
                      hintStyle:
                          const TextStyle(color: Colors.black38, fontSize: 14),
                      prefixIcon: const Icon(Icons.mail,
                          color: Colors.black45, size: 20),
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: isEmailVerified
                                  ? Colors.grey.shade300
                                  : Colors.orange.shade300)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: isEmailVerified
                                  ? Colors.grey.shade300
                                  : Colors.orange.shade300)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: primaryColor)),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Badge Status Verifikasi
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _emailController,
                    builder: (context, value, child) {
                      final currentEmail = user?['email'] ?? '';
                      final isEmailChanged = value.text.trim().toLowerCase() != currentEmail.toLowerCase();
                      
                      bool showVerified = isEmailVerified && !isEmailChanged;
                      String badgeText = showVerified ? 'Terverifikasi' : (isEmailChanged ? 'Perlu Disimpan & Verifikasi' : 'Belum Verifikasi');
                      Color badgeColor = showVerified ? Colors.green : Colors.orange;
                      IconData badgeIcon = showVerified ? Icons.verified : Icons.warning;

                      return Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: showVerified
                                  ? Colors.green.shade50
                                  : Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: showVerified
                                      ? Colors.green.shade200
                                      : Colors.orange.shade200),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  badgeIcon,
                                  color: badgeColor,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  badgeText,
                                  style: TextStyle(
                                    color: showVerified
                                        ? Colors.green.shade700
                                        : Colors.orange.shade800,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  // Peringatan jika belum verif (hanya tampil jika email tidak sedang diubah)
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _emailController,
                    builder: (context, value, child) {
                      final currentEmail = user?['email'] ?? '';
                      final isEmailChanged = value.text.trim().toLowerCase() != currentEmail.toLowerCase();
                      
                      if (!isEmailVerified && !isEmailChanged) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.info,
                                    color: Colors.orange, size: 20),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    'Email Anda belum diverifikasi. Beberapa fitur mungkin dibatasi.',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black87),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 0),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text('Kirim Ulang',
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  // Info jika email diubah
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info,
                            color: primaryColor, size: 18),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Jika email diubah, link verifikasi akan dikirim ke email baru. Email lama tetap aktif sampai verifikasi selesai.',
                            style: TextStyle(
                                fontSize: 11, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 3. BAGIAN KEAMANAN (UBAH PASSWORD)
              _buildSectionCard(
                title: 'Keamanan',
                icon: Icons.gpp_good,
                children: [
                  const Text(
                    'Minimal 6 karakter untuk keamanan ekstra. Kosongkan jika tidak ingin mengubah password.',
                    style:
                        TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 16),

                  // Password Saat Ini
                  const Text('Password Saat Ini',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _currentPasswordController,
                    obscureText: _obscureCurrentPassword,
                    decoration: InputDecoration(
                      hintText: 'Masukkan password saat ini',
                      hintStyle:
                          const TextStyle(color: Colors.black38, fontSize: 14),
                      prefixIcon: const Icon(Icons.lock,
                          color: Colors.black45, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureCurrentPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black45,
                          size: 20,
                        ),
                        onPressed: () => setState(() =>
                            _obscureCurrentPassword =
                                !_obscureCurrentPassword),
                      ),
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: primaryColor)),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Password Baru
                  const Text('Password Baru',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _newPasswordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Masukkan password baru',
                      hintStyle:
                          const TextStyle(color: Colors.black38, fontSize: 14),
                      prefixIcon: const Icon(Icons.lock,
                          color: Colors.black45, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black45,
                          size: 20,
                        ),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: primaryColor)),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Konfirmasi Password
                  const Text('Konfirmasi Password',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      hintText: 'Konfirmasi password baru',
                      hintStyle:
                          const TextStyle(color: Colors.black38, fontSize: 14),
                      prefixIcon: const Icon(Icons.lock,
                          color: Colors.black45, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.black45,
                          size: 20,
                        ),
                        onPressed: () => setState(() =>
                            _obscureConfirmPassword =
                                !_obscureConfirmPassword),
                      ),
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: Colors.grey.shade300)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: primaryColor)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // 4. TOMBOL AKSI
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving
                          ? null
                          : () {
                              // Reset ke data awal
                              final user = ref.read(authProvider).user;
                              _nameController.text = user?['name'] ?? '';
                              _emailController.text = user?['email'] ?? '';
                              _currentPasswordController.clear();
                              _newPasswordController.clear();
                              _confirmPasswordController.clear();
                            },
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
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Perbarui Profil',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 5. TOMBOL LOGOUT
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: _isLoggingOut
                      ? null
                      : () async {
                          setState(() => _isLoggingOut = true);
                          await ref.read(authProvider.notifier).logout();
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                              (route) => false,
                            );
                          }
                        },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.red.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: _isLoggingOut
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.red,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.output,
                          color: Colors.red),
                  label: Text(
                      _isLoggingOut ? 'Sedang keluar...' : 'Keluar dari Akun',
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
        ),
      ],
    );
    
    if (isLoading && !_isSaving && !_isLoggingOut) {
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: [
          CustomRefreshControl(
            onRefresh: () async {
              await ref.read(authProvider.notifier).fetchProfile();
            },
            primaryColor: primaryColor,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  // Header skeleton
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Column(
                      children: [
                        Container(width: 80, height: 80, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                        const SizedBox(height: 16),
                        Container(width: 150, height: 20, color: Colors.white),
                        const SizedBox(height: 8),
                        Container(width: 100, height: 14, color: Colors.white),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Section 1 skeleton
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black.withOpacity(0.05)),
                    ),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(width: 20, height: 20, color: Colors.white),
                              const SizedBox(width: 12),
                              Container(width: 120, height: 16, color: Colors.white),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Container(width: 100, height: 14, color: Colors.white),
                          const SizedBox(height: 8),
                          Container(width: double.infinity, height: 48, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))),
                          const SizedBox(height: 16),
                          Container(width: 100, height: 14, color: Colors.white),
                          const SizedBox(height: 8),
                          Container(width: double.infinity, height: 48, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Section 2 skeleton
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black.withOpacity(0.05)),
                    ),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(width: 20, height: 20, color: Colors.white),
                              const SizedBox(width: 12),
                              Container(width: 120, height: 16, color: Colors.white),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Container(width: 100, height: 14, color: Colors.white),
                          const SizedBox(height: 8),
                          Container(width: double.infinity, height: 48, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))),
                          const SizedBox(height: 16),
                          Container(width: 100, height: 14, color: Colors.white),
                          const SizedBox(height: 8),
                          Container(width: double.infinity, height: 48, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))),
                          const SizedBox(height: 16),
                          Container(width: 100, height: 14, color: Colors.white),
                          const SizedBox(height: 8),
                          Container(width: double.infinity, height: 48, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }
    
    return content;
  }

  // ============================================
  // SUBMIT HANDLER
  // ============================================
  Future<void> _handleSubmit() async {
    final user = ref.read(authProvider).user;
    if (user == null) return;

    final currentName = user['name'] ?? '';
    final currentEmail = user['email'] ?? '';
    final newName = _nameController.text.trim();
    final newEmail = _emailController.text.trim();
    final currentPassword = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    final nameChanged = newName != currentName;
    final emailChanged =
        newEmail.toLowerCase() != currentEmail.toLowerCase();
    final passwordFilled = newPassword.isNotEmpty;

    if (!nameChanged && !emailChanged && !passwordFilled) {
      _showToast('Tidak ada perubahan yang dilakukan.', isError: true);
      return;
    }

    // Validasi nama
    if (nameChanged && newName.length < 3) {
      _showToast('Nama harus diisi minimal 3 karakter.', isError: true);
      return;
    }

    // Validasi email
    if (emailChanged && !newEmail.contains('@')) {
      _showToast('Format email tidak valid.', isError: true);
      return;
    }

    // Validasi password
    if (passwordFilled) {
      if (currentPassword.isEmpty) {
        _showToast('Password saat ini wajib diisi.', isError: true);
        return;
      }
      if (newPassword.length < 6) {
        _showToast('Password baru minimal 6 karakter.', isError: true);
        return;
      }
      if (newPassword != confirmPassword) {
        _showToast('Konfirmasi password tidak cocok.', isError: true);
        return;
      }
    }

    setState(() => _isSaving = true);

    try {
      final notifier = ref.read(authProvider.notifier);
      List<String> successMessages = [];
      bool hasError = false;

      // 1. Update nama
      if (nameChanged) {
        final result = await notifier.updateProfile(newName);
        if (result['success'] == true) {
          successMessages.add('Nama berhasil diperbarui');
        } else {
          _showToast(result['message'] ?? 'Gagal memperbarui nama.',
              isError: true);
          hasError = true;
        }
      }

      // 2. Update password
      if (passwordFilled && !hasError) {
        final result =
            await notifier.updatePassword(currentPassword, newPassword);
        if (result['success'] == true) {
          successMessages.add('Password berhasil diperbarui');
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();
        } else {
          _showToast(result['message'] ?? 'Gagal memperbarui password.',
              isError: true);
          hasError = true;
        }
      }

      // 3. Request email change
      if (emailChanged && !hasError) {
        final result = await notifier.requestEmailChange(newEmail);
        if (result['success'] == true) {
          successMessages
              .add('Link verifikasi dikirim ke $newEmail');
          // Reset email field ke email lama karena belum berubah
          _emailController.text = currentEmail;

          // Tampilkan dialog info
          if (mounted) {
            _showEmailChangeDialog(newEmail);
          }
        } else {
          _showToast(
              result['message'] ?? 'Gagal mengirim verifikasi email.',
              isError: true);
          _emailController.text = currentEmail;
          hasError = true;
        }
      }

      if (successMessages.isNotEmpty && !hasError) {
        _showToast(successMessages.join('. ') + '.', isError: false);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showEmailChangeDialog(String newEmail) {
    final primaryColor = widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.mail, color: primaryColor),
            const SizedBox(width: 10),
            const Expanded(
                child: Text('Verifikasi Email',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Link verifikasi telah dikirim ke:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                newEmail,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Silakan buka email tersebut dan klik link verifikasi untuk mengkonfirmasi perubahan. Email lama Anda tetap aktif sampai verifikasi selesai.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Mengerti',
                style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
          ),
        ],
      ),
    );
  }

  void _showToast(String message, {bool isError = false}) {
    toastification.show(
      context: context,
      title: Text(message),
      type: isError ? ToastificationType.error : ToastificationType.success,
      autoCloseDuration: const Duration(seconds: 3),
      style: ToastificationStyle.fillColored,
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic>? user) {
    final primaryColor = widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary;
    final userName = user?['name'] ?? 'Pengurus';
    final role = user?['role'] as String? ?? '';
    final userId = user?['id'] ?? 'ipnuippnu-admin-cabang';

    final imageUrl = user?['image'] ??
        'https://ui-avatars.com/api/?name=${Uri.encodeComponent(userName)}&background=1565C0&color=fff&size=256';

    String roleLabel = 'PENGURUS';
    if (role.contains('CABANG'))
      roleLabel = 'CABANG';
    else if (role.contains('PAC'))
      roleLabel = 'PAC';
    else if (role.contains('WILAYAH')) roleLabel = 'WILAYAH';

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
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ],
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
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
                  color: primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: const Icon(Icons.camera_alt,
                    color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          userName,
          style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: primaryColor.withOpacity(0.3)),
          ),
          child: Text(
            roleLabel,
            style: TextStyle(
                color: primaryColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'ID: $userId',
            style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontFamily: 'monospace'),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _photoFileName ?? 'Klik ikon kamera untuk ganti foto baru. Maks 2MB.',
          style: TextStyle(
              color:
                  _photoFileName != null ? primaryColor : Colors.grey,
              fontSize: 11,
              fontWeight:
                  _photoFileName != null ? FontWeight.bold : FontWeight.normal),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final primaryColor = widget.isCabang ? AppColors.cabangPrimary : AppColors.pacPrimary;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: primaryColor, size: 22),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
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
