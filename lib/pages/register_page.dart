import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_mobile_money_tracker_login_register/models/user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _isObscureConfirm = true;
  bool _agree = true;

  void _register() async {
    final prefs = await SharedPreferences.getInstance();

    final user = User(
      username: usernameController.text,
      password: passwordController.text,
    );
    prefs.setString('user_data', jsonEncode(user.toJson()));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registrasi berhasil!')),
    );

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Lengkung atas
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                ),
              ),
            ),
          ),

          // Lengkung bawah
          Positioned(
            bottom: -60,
            left: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFA03B), Color(0xFFFFFB00)],
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(100),
                ),
              ),
            ),
          ),

          // Konten utama
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      "Sign Up",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Username
                    buildInputField(
                      controller: usernameController,
                      hintText: "Username",
                      icon: Icons.person_outline,
                      validator: (value) =>
                      value!.isEmpty ? 'Username wajib diisi' : null,
                    ),

                    const SizedBox(height: 16),

                    // Password
                    buildInputField(
                      controller: passwordController,
                      hintText: "Password",
                      icon: Icons.lock_outline,
                      obscureText: _isObscure,
                      isPassword: true,
                      onToggle: () =>
                          setState(() => _isObscure = !_isObscure),
                      validator: (value) => value!.length < 4
                          ? 'Password minimal 4 karakter'
                          : null,
                    ),

                    const SizedBox(height: 16),

                    // Konfirmasi Password
                    buildInputField(
                      controller: confirmPasswordController,
                      hintText: "Konfirmasi Password",
                      icon: Icons.lock_outline,
                      obscureText: _isObscureConfirm,
                      isPassword: true,
                      onToggle: () => setState(() =>
                      _isObscureConfirm = !_isObscureConfirm),
                      validator: (value) => value != passwordController.text
                          ? 'Konfirmasi tidak cocok'
                          : null,
                    ),

                    const SizedBox(height: 16),

                    // Checkbox Terms
                    Row(
                      children: [
                        Checkbox(
                          value: _agree,
                          onChanged: (val) {
                            setState(() => _agree = val!);
                          },
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                              children: const [
                                TextSpan(text: 'Saya menyetujui '),
                                TextSpan(
                                  text: 'Syarat & Ketentuan',
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Tombol Daftar
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate() && _agree) {
                            _register();
                          } else if (!_agree) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Harap setujui syarat & ketentuan"),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 6,
                          backgroundColor: const Color(0xFF7F00FF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "CREATE ACCOUNT",
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Link ke login
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text(
                        "Sudah punya akun? Sign in",
                        style: GoogleFonts.poppins(
                          color: Colors.deepPurple,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required String? Function(String?) validator,
    bool obscureText = false,
    bool isPassword = false,
    void Function()? onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              obscureText ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: onToggle,
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}
