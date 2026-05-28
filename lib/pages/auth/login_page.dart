import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Tambahkan package Dio
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_colors.dart';
import '../home_page.dart';
import 'auth_widgets.dart';
import 'register_step1_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _remember = false;
  bool _hide = true;
  bool _isLoading = false; // Status loading indikator tombol

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // 1. Inisialisasi Dio (Sesuaikan IP Host Laravel sesuai dengan IPv4 hasil 'ipconfig')
      final dio = Dio(
        BaseOptions(
          baseUrl: "http://10.253.128.201:8000/api",
          connectTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      // 2. Eksekusi Request POST Login ke Laravel
      final response = await dio.post(
        '/login',
        data: {
          'email':
              _emailCtrl.text
                  .trim(), // Kolom ini bisa menerima email atau nomor HP di backend
          'password': _passCtrl.text,
        },
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        final data = response.data;
        print(data);
        final String token = data['access_token'];
        final String name = data['user']['name']; // Mengambil nama pengguna
        final String email = data['user']['email']; // Mengambil email pengguna
        final String role =
            data['user']['role']; // Mengambil string: 'admin', 'user', atau 'mekanik'

        // 3. Simpan data otentikasi menggunakan SharedPreferences bawaan
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_logged_in', true);
        await prefs.setString('access_token', token);
        await prefs.setString('name', name);
        await prefs.setString('email', email);
        await prefs.setString('role', role);

        if (!mounted) return;

        // 4. Redirect ke Dashboard Utama (HomePage) secara bersih
        // Menggunakan pushAndRemoveUntil agar tumpukan (stack) halaman login dihapus total
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
          (_) => false,
        );
      }
    } on DioException catch (e) {
      setState(() => _isLoading = false);

      // Tangkap pesan kegagalan dari Laravel (misalnya password salah / akun tidak ada)
      String errorMsg = "Gagal terhubung ke server.";
      if (e.response != null && e.response?.data['message'] != null) {
        errorMsg = e.response?.data['message'];
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: AppColors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      lightBottom: true,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 48),
              decoration: const BoxDecoration(color: Color(0xFF1A1A2E)),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Positioned(
                    top: -68,
                    right: -60,
                    child: _HeaderCircle(size: 192, color: Color(0x800F3460)),
                  ),
                  const Positioned(
                    top: 48,
                    left: -84,
                    child: _HeaderCircle(size: 158, color: Color(0x12FF6B35)),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      const Center(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Bengkel ',
                                style: TextStyle(color: Colors.white),
                              ),
                              TextSpan(
                                text: 'Track',
                                style: TextStyle(color: AppColors.orange),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Syne',
                            fontSize: 42,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Center(
                        child: Text(
                          'Masuk untuk lanjutkan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(.52),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
                decoration: const BoxDecoration(color: Color(0xFFF9F8F6)),
                child: SingleChildScrollView(
                  // Membungkus konten agar aman dari error overflow saat keyboard HP muncul
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE6E1DA)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label('Email'),
                          TextFormField(
                            controller: _emailCtrl,
                            onChanged: (_) => setState(() {}),
                            style: const TextStyle(color: Colors.black),
                            decoration: authInputDecoration(
                              hint: 'Masukkan email anda',
                              icon: Icons.person,
                            ).copyWith(
                              hintStyle: TextStyle(
                                color:
                                    _emailCtrl.text.trim().isEmpty
                                        ? AppColors.gray
                                        : Colors.black,
                              ),
                            ),
                            validator:
                                (v) =>
                                    v == null || v.isEmpty
                                        ? 'Wajib diisi'
                                        : null,
                          ),
                          const SizedBox(height: 12),
                          _label('Password'),
                          TextFormField(
                            controller: _passCtrl,
                            obscureText: _hide,
                            onChanged: (_) => setState(() {}),
                            style: const TextStyle(color: Colors.black),
                            decoration: authInputDecoration(
                              hint: 'Masukkan password anda',
                              icon: Icons.lock,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _hide
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () => setState(() => _hide = !_hide),
                              ),
                            ).copyWith(
                              hintStyle: TextStyle(
                                color:
                                    _passCtrl.text.trim().isEmpty
                                        ? AppColors.gray
                                        : Colors.black,
                              ),
                            ),
                            validator:
                                (v) =>
                                    v == null || v.length < 8
                                        ? 'Password minimal 8 karakter'
                                        : null,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Checkbox(
                                value: _remember,
                                onChanged:
                                    (v) =>
                                        setState(() => _remember = v ?? false),
                                activeColor: AppColors.orange,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                              const Text(
                                'Ingat saya (opsional)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.gray,
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                'Lupa password?',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.orange,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          OrangeButton(
                            text: _isLoading ? 'Memvalidasi...' : 'Masuk',
                            onTap:
                                _isLoading
                                    ? () {}
                                    : _login, // Kunci tombol saat memproses data ke server
                            textStyle: const TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Center(
                            child: GestureDetector(
                              onTap:
                                  () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const RegisterStep1Page(),
                                    ),
                                  ),
                              child: const Text.rich(
                                TextSpan(
                                  text: 'Belum punya akun? ',
                                  style: TextStyle(color: AppColors.gray),
                                  children: [
                                    TextSpan(
                                      text: 'Daftar Sekarang',
                                      style: TextStyle(
                                        color: AppColors.orange,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String s) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      s,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.darkGray,
      ),
    ),
  );
}

class _HeaderCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _HeaderCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
