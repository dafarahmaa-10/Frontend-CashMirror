import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(CashMirrorApp());
}

class CashMirrorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CashMirror',

      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Color(0xFFF5F5F5),
        cardColor: Colors.white,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),

      home: LoginScreen(),
    );
  }
}