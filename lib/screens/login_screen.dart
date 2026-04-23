import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'register_screen.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();

  bool isLoading = false;

  void login() async {
    // 🔥 VALIDASI
    if (email.text.isEmpty || password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email & Password wajib diisi")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    bool success = await ApiService.login(
      email.text,
      password.text,
    );

    setState(() {
      isLoading = false;
    });

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login gagal")),
      );
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// TITLE
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
                children: [
                  TextSpan(
                    text: "Cash",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                    text: "Mirror",
                    style: TextStyle(color: Color(0xFF85BB65)),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            /// EMAIL
            TextField(
              controller: email,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Masukkan email",
                hintStyle: TextStyle(color: Colors.grey),
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),

            SizedBox(height: 10),

            /// PASSWORD
            TextField(
              controller: password,
              obscureText: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Masukkan password",
                hintStyle: TextStyle(color: Colors.grey),
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),

            SizedBox(height: 20),

            /// LOGIN BUTTON
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: isLoading ? null : login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF85BB65),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      "Login",
                    style: TextStyle(color: Colors.white),
                    ),
                  ),

            SizedBox(height: 10),

            /// REGISTER
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RegisterScreen()),
                );
              },
              child: Text(
                "Belum punya akun? Register",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}