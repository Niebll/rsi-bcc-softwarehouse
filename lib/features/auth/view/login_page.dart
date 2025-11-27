import 'dart:convert';
import 'package:bcc_rsi/features/auth/view/register_page.dart';
import 'package:bcc_rsi/features/home/view/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_font_weight.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk mengambil input email & password
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Untuk toggle visibility password
  bool _obscurePassword = true;

  // Indikator loading ketika proses login berlangsung
  bool _isLoading = false;

  // ---------------------------------------------------------
  // 🔥 FUNCTION: LOGIN KE API BACKEND
  // ---------------------------------------------------------
  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validasi sederhana
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan password tidak boleh kosong")),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Endpoint login API
    final url = "https://pg-vincent.bccdev.id/rsi/api/auth/login";

    try {
      // Mengirim request POST berupa email & password
      final res = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      final data = jsonDecode(res.body);

      // Jika status 200 & token tersedia → login sukses
      if (res.statusCode == 200 && data["token"] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Login berhasil")),
        );

        print("TOKEN: ${data['token']}");

        // Navigate ke Dashboard
        context.go('/dashboard');

      } else {
        // Jika gagal login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Login gagal")),
        );
      }
    } catch (e) {
      // Error network / server
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    setState(() => _isLoading = false);
  }

  // ---------------------------------------------------------
  // UI / LAYOUT LOGIN PAGE
  // ---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // LayoutBuilder → mendeteksi apakah desktop / mobile
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 900;

          return Row(
            children: [

              // -----------------------------------------
              // 🔵 BAGIAN KIRI (HANYA MUNCUL DI DESKTOP)
              // -----------------------------------------
              if (isDesktop)
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color(0XFF0098D9),
                          Color(0XFF005173),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo BCC
                        Padding(
                          padding: const EdgeInsets.only(left: 40, top: 40),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                Image.asset('assets/images/BCC.png', width: 200),
                              ],
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Ilustrasi gambar login
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset(
                            'assets/images/Login.png',
                            width: 400,
                          ),
                        ),

                        const Spacer(),

                        // Tagline BCC SH di bagian bawah kiri
                        Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Text(
                            'Tech community where minds drive to continually innovate\nand create valuable digital solutions to solve the problems',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // -----------------------------------------
              // 🟠 BAGIAN KANAN (FORM LOGIN)
              // -----------------------------------------
              Expanded(
                flex: isDesktop ? 4 : 1,
                child: Container(
                  color: const Color(0xFFF5F5F5),

                  child: Center(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 80 : 24,
                        vertical: 40,
                      ),

                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            // Logo BCC (hanya muncul di mobile)
                            if (!isDesktop)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 40),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/images/BCC.png', width: 200),
                                  ],
                                ),
                              ),

                            // Text heading
                            const Text(
                              'Welcome back to',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w400,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'BCC Software House',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: AppFontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),

                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                                children: [
                                  TextSpan(text: 'Sign in to '),
                                  TextSpan(
                                    text: 'continue',
                                    style: TextStyle(
                                      color: Color(0xFF00BCD4),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(text: ' your journey'),
                                ],
                              ),
                            ),

                            const SizedBox(height: 40),

                            // -----------------------------------------
                            // 📨 INPUT EMAIL
                            // -----------------------------------------
                            const Text(
                              'Email Address',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),

                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                              ),
                            ),

                            const SizedBox(height: 4),
                            const Text(
                              'Use your registered email domain.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // -----------------------------------------
                            // 🔐 INPUT PASSWORD
                            // -----------------------------------------
                            const Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),

                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),

                                // Icon untuk show/hide password
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Input your password correctly.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),

                                // Tombol lupa password
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // -----------------------------------------
                            // 🟧 LOGIN BUTTON
                            // -----------------------------------------
                            ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF7043),
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),

                              // Menampilkan loading saat login
                              child: _isLoading
                                  ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                                  : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
