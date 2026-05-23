import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/app_colors.dart';
import 'auth_widgets.dart';
import 'login_page.dart';
import 'register_step2_page.dart';

class RegisterStep1Page extends StatefulWidget {
  const RegisterStep1Page({super.key});

  @override
  State<RegisterStep1Page> createState() => _RegisterStep1PageState();
}

class _RegisterStep1PageState extends State<RegisterStep1Page> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  bool agree = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  void dispose() {
    nameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    passCtrl.dispose();
    confirmCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (!_formKey.currentState!.validate()) return;
    if (!agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Setujui Syarat & Ketentuan untuk melanjutkan')),
      );
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterStep2Page(name: nameCtrl.text, phone: phoneCtrl.text, email: emailCtrl.text)));
  }

  bool _isValidGmail(String value) {
    final email = value.trim();
    if (email.isEmpty) return false;
    final validFormat = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
    return validFormat && email.toLowerCase().endsWith('@gmail.com');
  }

  PasswordStrength _passwordStrength(String value) {
    final password = value.trim();
    if (password.isEmpty) return PasswordStrength.empty;

    final hasLower = RegExp(r'[a-z]').hasMatch(password);
    final hasUpper = RegExp(r'[A-Z]').hasMatch(password);
    final hasDigit = RegExp(r'\d').hasMatch(password);
    final hasSpecial = RegExp(r'''[!@#$%^&*(),.?":{}|<>\[\]\\\/\-_=+~`;'']''').hasMatch(password);
    if (password.length < 8) return PasswordStrength.weak;
    if (hasSpecial) return PasswordStrength.strong;
    if (hasUpper && hasLower && hasDigit) return PasswordStrength.medium;
    return PasswordStrength.weak;
  }

  String _passwordStrengthLabel(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.empty:
        return '-';
      case PasswordStrength.weak:
        return 'Lemah';
      case PasswordStrength.medium:
        return 'Sedang';
      case PasswordStrength.strong:
        return 'Kuat';
    }
  }

  Color _passwordStrengthColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.empty:
        return const Color(0xFFE8E4DC);
      case PasswordStrength.weak:
        return AppColors.red;
      case PasswordStrength.medium:
        return const Color(0xFFF59E0B);
      case PasswordStrength.strong:
        return AppColors.brightGreen;
    }
  }

  List<Color> _passwordBars(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.empty:
        return const [Color(0xFFE8E4DC), Color(0xFFE8E4DC), Color(0xFFE8E4DC)];
      case PasswordStrength.weak:
        return const [AppColors.red, Color(0xFFE8E4DC), Color(0xFFE8E4DC)];
      case PasswordStrength.medium:
        return const [Color(0xFFF59E0B), Color(0xFFF59E0B), Color(0xFFE8E4DC)];
      case PasswordStrength.strong:
        return const [AppColors.brightGreen, AppColors.brightGreen, AppColors.brightGreen];
    }
  }

  String? _nameValidator(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Wajib diisi';
    if (name.length <= 4) return 'Minimal 5 karakter';
    return null;
  }

  String? _phoneValidator(String? value) => value == null || value.isEmpty ? 'Wajib diisi' : null;

  String? _emailValidator(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Wajib diisi';
    if (!_isValidGmail(email)) return 'Email harus lengkap dan berakhiran @gmail.com';
    return null;
  }

  String? _passwordValidator(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'Wajib diisi';
    if (password.length < 8) return 'Minimal 8 karakter';
    if (_passwordStrength(password) == PasswordStrength.weak) return 'Password terlalu lemah';
    return null;
  }

  String? _confirmValidator(String? value) {
    final confirm = value ?? '';
    if (confirm.isEmpty) return 'Wajib diisi';
    if (confirm != passCtrl.text) return 'Password tidak sama';
    return null;
  }

  InputDecoration _hintDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
    Widget? prefix,
    required bool hasText,
  }) {
    return authInputDecoration(hint: hint, icon: icon, suffixIcon: suffixIcon, prefix: prefix).copyWith(
      hintStyle: TextStyle(
        color: hasText ? Colors.black : AppColors.gray,
      ),
    );
  }

  Widget? _fieldCheckIcon(bool show) => show ? const Icon(Icons.check_circle, color: AppColors.brightGreen) : null;

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      lightBottom: true,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _header(context),
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF9F8F6),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: _card(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) => Container(
    height: 186,
    child: Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: const BoxDecoration(color: AppColors.navy),
          ),
        ),
        Positioned(
          top: -62,
          right: -42,
          child: _HeaderCircle(size: 198, color: const Color(0x800F3460)),
        ),
        Positioned(
          top: 42,
          left: -76,
          child: _HeaderCircle(size: 150, color: const Color(0x800F3460)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(children: [
            const SizedBox(height: 18),
            Row(children: [
              GestureDetector(onTap: () => Navigator.pop(context), child: Container(width: 30, height: 30, decoration: BoxDecoration(color: Colors.white.withOpacity(.12), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16))),
              const Spacer(),
              const SizedBox(width: 30),
            ]),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: Text(
                  'Buat Akun Baru',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Syne',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    height: 0.95,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(children: [Expanded(child: Container(height: 5, decoration: BoxDecoration(color: AppColors.orange, borderRadius: BorderRadius.circular(5)))), Expanded(child: Container(height: 5, decoration: BoxDecoration(color: Colors.white.withOpacity(.20), borderRadius: BorderRadius.circular(5))))]),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const [
              _StepCircle(active: true, label: 'Data Diri', value: '1'),
              _StepCircle(active: false, label: 'Kendaraan', value: '2'),
            ]),
          ]),
        ),
      ],
    ),
  );

  Widget _card() => Container(
    padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE6E1DA))),
    child: Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _label('Nama Lengkap *'),
          TextFormField(
            controller: nameCtrl,
            onChanged: (_) => setState(() {}),
            decoration: _hintDecoration(
              hint: 'Isi nama lengkap anda',
              icon: Icons.person,
              suffixIcon: _fieldCheckIcon(nameCtrl.text.trim().length > 4),
              hasText: nameCtrl.text.trim().isNotEmpty,
            ),
            validator: _nameValidator,
          ),
          const SizedBox(height: 8),
          _label('Nomor HP *'),
          TextFormField(
            controller: phoneCtrl,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, _PhoneNumberFormatter()],
            onChanged: (_) => setState(() {}),
            decoration: _hintDecoration(
              hint: 'xxx-xxxx-xxxx',
              icon: Icons.phone,
              prefix: const Padding(
                padding: EdgeInsets.only(left: 16, right: 8),
                child: Center(
                  widthFactor: 1,
                  child: Text('+62', style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.w700)),
                ),
              ),
              hasText: phoneCtrl.text.trim().isNotEmpty,
            ),
            validator: _phoneValidator,
          ),
          const SizedBox(height: 8),
          _label('Email *'),
          TextFormField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => setState(() {}),
            decoration: _hintDecoration(
              hint: 'Isi email anda',
              icon: Icons.mail,
              suffixIcon: _fieldCheckIcon(_isValidGmail(emailCtrl.text.trim())),
              hasText: emailCtrl.text.trim().isNotEmpty,
            ),
            validator: _emailValidator,
          ),
          const SizedBox(height: 8),
          _label('Buat Password *'),
          TextFormField(
            controller: passCtrl,
            obscureText: obscurePassword,
            onChanged: (_) => setState(() {}),
            decoration: _hintDecoration(
              hint: 'Minimal 8 karakter',
              icon: Icons.lock,
              suffixIcon: IconButton(
                onPressed: () => setState(() => obscurePassword = !obscurePassword),
                icon: Icon(obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.gray),
              ),
              hasText: passCtrl.text.isNotEmpty,
            ),
            validator: _passwordValidator,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Text('Kekuatan password:', style: TextStyle(fontSize: 11, color: AppColors.gray)),
              const SizedBox(width: 6),
              _bar(_passwordBars(_passwordStrength(passCtrl.text))[0]),
              _bar(_passwordBars(_passwordStrength(passCtrl.text))[1]),
              _bar(_passwordBars(_passwordStrength(passCtrl.text))[2]),
              Text(
                ' ${_passwordStrengthLabel(_passwordStrength(passCtrl.text))}',
                style: TextStyle(fontSize: 10, color: _passwordStrengthColor(_passwordStrength(passCtrl.text))),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _label('Konfirmasi Password *'),
          TextFormField(
            controller: confirmCtrl,
            obscureText: obscureConfirmPassword,
            onChanged: (_) => setState(() {}),
            decoration: _hintDecoration(
              hint: 'Ulangi password',
              icon: Icons.lock,
              suffixIcon: IconButton(
                onPressed: () => setState(() => obscureConfirmPassword = !obscureConfirmPassword),
                icon: Icon(obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.gray),
              ),
              hasText: confirmCtrl.text.isNotEmpty,
            ),
            validator: _confirmValidator,
          ),
          const SizedBox(height: 8),
          Row(children: [Checkbox(value: agree, onChanged: (v) => setState(() => agree = v ?? false), activeColor: AppColors.orange, visualDensity: VisualDensity.compact), const Text('Saya setuju dengan ', style: TextStyle(fontSize: 11, color: AppColors.gray)), const Text('Syarat & Ketentuan', style: TextStyle(fontSize: 11, color: AppColors.orange, fontWeight: FontWeight.w700))]),
          const SizedBox(height: 12),
          OrangeButton(
            text: 'Lanjut',
            onTap: _next,
            textStyle: const TextStyle(fontFamily: 'PlusJakartaSans', fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Center(child: GestureDetector(onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage())), child: const Text.rich(TextSpan(text: 'Sudah punya akun? ', style: TextStyle(color: AppColors.gray), children: [TextSpan(text: 'Masuk', style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.w800))]), style: TextStyle(fontSize: 13)))),
          const SizedBox(height: 24),
        ]),
      ),
    ),
  );

  Widget _label(String s) => Padding(padding: const EdgeInsets.only(bottom: 5), child: Text(s, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.darkGray)));

  Widget _bar(Color c) => Container(width: 49, height: 5, margin: const EdgeInsets.only(right: 6), decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(6)));
}

enum PasswordStrength { empty, weak, medium, strong }

class _StepCircle extends StatelessWidget {
  final bool active;
  final String label;
  final String value;
  const _StepCircle({required this.active, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Column(children: [CircleAvatar(radius: 14, backgroundColor: active ? AppColors.orange : Colors.white.withOpacity(.13), child: Text(value, style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500, fontFamily: 'PlusJakartaSans'))), const SizedBox(height: 2), Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 10.5, color: active ? AppColors.orange : Colors.white.withOpacity(.28), fontFamily: 'PlusJakartaSans', fontWeight: FontWeight.w500))]);
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

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > 11 ? digits.substring(0, 11) : digits;
    final buffer = StringBuffer();

    for (var index = 0; index < limited.length; index++) {
      buffer.write(limited[index]);
      if ((index == 2 || index == 6) && index != limited.length - 1) {
        buffer.write(' ');
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
