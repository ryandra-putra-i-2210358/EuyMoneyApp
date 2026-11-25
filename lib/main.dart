import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_mobile_money_tracker_login_register/pages/login_page.dart';
import 'package:tugas_mobile_money_tracker_login_register/pages/main_page.dart';
import 'package:tugas_mobile_money_tracker_login_register/pages/register_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  static final ThemeData _appTheme = ThemeData(
    primarySwatch: Colors.green,
    textTheme: GoogleFonts.montserratTextTheme(),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EuyMoney - Money Tracker',
      debugShowCheckedModeBanner: false,
      theme: _appTheme,
      home: isLoggedIn ? const MainPage() : const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/main': (context) => const MainPage(),
      },
    );
  }
}
