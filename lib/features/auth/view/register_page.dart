import 'package:bcc_rsi/features/auth/view/login_page.dart';
import 'package:bcc_rsi/features/project_request/view/project_request_user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_font_weight.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // ================================
  //      TEXT FIELD CONTROLLER
  // ================================
  final _nameController = TextEditingController();
  final _rePasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true; // untuk toggle visibility password

  // ============================
  //       REGISTER FUNCTION
  // ============================
  Future<void> registerUser() async {

    // ===== VALIDATION INPUT =====
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _rePasswordController.text.trim().isEmpty) {

      // Jika ada field kosong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields must be filled")),
      );
      return;
    }

    // ===== CEK PASSWORD SAMA =====
    if (_passwordController.text.trim() != _rePasswordController.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password does not match")),
      );
      return;
    }

    // Endpoint register API
    final url = Uri.parse("https://pg-vincent.bccdev.id/rsi/api/auth/register");

    // Body request untuk API
    final body = {
      "name": _nameController.text.trim(),
      "email": _emailController.text.trim(),
      "password": _passwordController.text.trim(),
      "phone": "081286863129" // MASIH HARDCODE → bisa diganti menjadi input sendiri
    };

    try {
      // ====== REQUEST POST ======
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      // debug log
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      // ====== HANDLE RESPONSE ======
      if (response.statusCode == 200 || response.statusCode == 201) {

        // Jika berhasil daftar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Register success!")),
        );

        // Pindah ke halaman request project
        context.go('/requesting');

      } else {
        // Jika gagal (misal email sudah digunakan)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Register failed: ${response.body}")),
        );
      }
    } catch (e) {
      // Jika terjadi error lain (network error)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // ============================
  //           BUILD UI
  // ============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {

          // Deteksi apakah tampilan desktop atau mobile
          bool isDesktop = constraints.maxWidth > 900;

          return Row(
            children: [

              // =======================================
              //  BAGIAN KIRI (HANYA MUNCUL DI DESKTOP)
              // =======================================
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

                    // BAGIAN POSTER / BRANDING
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        // Logo BCC
                        Padding(
                          padding: const EdgeInsets.only(left: 40, top: 40),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Image.asset('assets/images/BCC.png', width: 200),
                          ),
                        ),

                        const Spacer(),

                        // Ilustrasi
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset(
                            'assets/images/Login.png',
                            width: 400,
                          ),
                        ),

                        const Spacer(),

                        // Tagline
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

              // =======================================
              //          FORM REGISTER (KANAN)
              // =======================================
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

                            // Logo BCC jika mobile
                            if (!isDesktop)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 40),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/BCC.png',
                                    width: 200,
                                  ),
                                ),
                              ),

                            // Judul Form
                            const Text(
                              'Create Your Account',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: AppFontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Sub-judul
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(fontSize: 16, color: Colors.grey),
                                children: [
                                  TextSpan(text: 'Join us to '),
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

                            // =======================================
                            //                FIELD NAMA
                            // =======================================
                            const Text(
                              'Full Name',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _nameController,
                              decoration: _inputStyle(),
                            ),
                            const SizedBox(height: 24),

                            // =======================================
                            //                FIELD EMAIL
                            // =======================================
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
                              decoration: _inputStyle(),
                            ),
                            const SizedBox(height: 24),

                            // =======================================
                            //                FIELD PASSWORD
                            // =======================================
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
                              decoration: _passwordStyle(),
                            ),

                            const SizedBox(height: 24),

                            // =======================================
                            //          FIELD CONFIRM PASSWORD
                            // =======================================
                            const Text(
                              'Confirm Password',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _rePasswordController,
                              obscureText: _obscurePassword,
                              decoration: _passwordStyle(),
                            ),

                            const SizedBox(height: 32),

                            // =======================================
                            //            BUTTON REGISTER
                            // =======================================
                            ElevatedButton(
                              onPressed: () => registerUser(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF7043),
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // =======================================
                            //                   DIVIDER
                            // =======================================
                            Row(
                              children: [
                                Expanded(child: Divider(color: Colors.grey.shade300)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    'OR',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(child: Divider(color: Colors.grey.shade300)),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // =======================================
                            //            BUTTON LOGIN
                            // =======================================
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                                  children: [
                                    const TextSpan(text: "Already have an "),
                                    WidgetSpan(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const LoginPage(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Account?',
                                          style: TextStyle(
                                            color: Color(0xFF00BCD4),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
          );
        },
      ),
    );
  }

  // ================================
  // STYLING: INPUT FIELD TEMPLATE
  // ================================
  InputDecoration _inputStyle() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }

  // ================================
  // STYLING: PASSWORD FIELD
  // ================================
  InputDecoration _passwordStyle() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
      ),
    );
  }

  // Dispose controller untuk menghindari memory leak
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
