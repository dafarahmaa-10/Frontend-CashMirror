import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {

  @override
  _RegisterScreenState createState() => _RegisterScreenState();

}

class _RegisterScreenState extends State<RegisterScreen> {

  final email = TextEditingController();
  final password = TextEditingController();

  bool loading = false;

  void register() async {

    setState(() {
      loading = true;
    });

    bool success = await ApiService.register(
      email.text,
      password.text,
    );

    setState(() {
      loading = false;
    });

    if (success) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Register berhasil"))
      );

      Navigator.pop(context);

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Register gagal"))
      );

    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Register"),
      ),

      body: Padding(

        padding: EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: email,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),

            SizedBox(height: 20),

            TextField(
              controller: password,
              obscureText: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),

            SizedBox(height: 30),

            loading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF85BB65),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: Text(
                      "Register",
                      style: TextStyle(color: Colors.white),
                      ),
                  ),

          ],

        ),

      ),

    );

  }

}