import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddTransactionScreen extends StatefulWidget {
  final String type;
  final bool isDarkMode;

  const AddTransactionScreen({
    Key? key,
    required this.type,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final categoryController = TextEditingController();
  final amountController = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDarkMode ? Colors.black : Color(0xFFF5F5F5);
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(
          widget.type == "expense" ? "Tambah Pengeluaran" : "Tambah Pemasukan",
          style: TextStyle(color: textColor),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: categoryController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: "Kategori",
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),

            SizedBox(height: 20),

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: "Jumlah",
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),

            SizedBox(height: 30),

            loading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.isDarkMode
                          ? Color(0xFF2A2A2A)
                          : Colors.white,
                    ),
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });

                      bool success = await ApiService.addTransaction(
                        widget.type,
                        categoryController.text,
                        int.parse(amountController.text),
                      );

                      setState(() {
                        loading = false;
                      });

                      if (success) {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "Simpan",
                      style: TextStyle(color: Color(0xFF85BB65)),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
