import 'package:flutter/material.dart';
import '../services/api_service.dart';

class BudgetScreen extends StatefulWidget {
  final bool isDarkMode;

  const BudgetScreen({
    Key? key,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {

  final categoryController = TextEditingController();
  final amountController = TextEditingController();

  List budgets = [];

  @override
  void initState() {
    super.initState();
    loadBudgets();
  }

  void loadBudgets() async {
    try {
      final data = await ApiService.getBudgets();

      setState(() {
        budgets = data;
      });
    } catch (e) {
      print(e);
    }
  }

  void addBudget() async {
    final category = categoryController.text;
    final amount = int.tryParse(amountController.text) ?? 0;

    bool success = await ApiService.addBudget(category, amount);

    if (success) {
      categoryController.clear();
      amountController.clear();

      loadBudgets();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Budget berhasil ditambahkan")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menambahkan budget")),
      );
    }
  }

  void editBudget(item) {

    final categoryEdit = TextEditingController(text: item["category"]);
    final amountEdit = TextEditingController(text: item["amount"].toString());

    showDialog(
      context: context,
      builder: (context) {

        final textColor =
            widget.isDarkMode ? Colors.white : Colors.black;

        return AlertDialog(
          backgroundColor:
              widget.isDarkMode ? Color(0xFF1A1A1A) : Colors.white,

          title: Text(
            "Edit Budget",
            style: TextStyle(color: textColor),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              TextField(
                controller: categoryEdit,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: "Kategori",
                  labelStyle: TextStyle(
                    color: widget.isDarkMode
                        ? Colors.grey
                        : Colors.black54,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.isDarkMode
                          ? Colors.grey
                          : Colors.black54,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),

              TextField(
                controller: amountEdit,
                keyboardType: TextInputType.number,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: "Jumlah Budget",
                  labelStyle: TextStyle(
                    color: widget.isDarkMode
                        ? Colors.grey
                        : Colors.black54,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.isDarkMode
                          ? Colors.grey
                          : Colors.black54,
                    ),
                  ),
                ),
              ),

            ],
          ),

          actions: [

            /// DELETE
            TextButton(
              onPressed: () async {

                await ApiService.deleteBudget(item["id"]);

                Navigator.pop(context);

                loadBudgets();

              },
              child: Text(
                "Hapus",
                style: TextStyle(color: Colors.red),
              ),
            ),

            /// UPDATE
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isDarkMode
                    ? Color(0xFF2A2A2A)
                    : Colors.white,
              ),
              onPressed: () async {

                await ApiService.updateBudget(
                  item["id"],
                  categoryEdit.text,
                  int.parse(amountEdit.text),
                );

                Navigator.pop(context);

                loadBudgets();

              },
              child: Text(
                "Simpan",
                style: TextStyle(color: Color(0xFF85BB65)),
              ),
            ),

          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final bgColor =
        widget.isDarkMode ? Colors.black : Color(0xFFF5F5F5);

    final textColor =
        widget.isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Text(
          "Budget",
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
              ),
            ),

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: "Jumlah Budget",
              ),
            ),

            SizedBox(height: 20),

            /// BUTTON TAMBAH BUDGET
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    widget.isDarkMode ? Color(0xFF2A2A2A) : Colors.white,
              ),
              onPressed: addBudget,
              child: Text(
                "Tambah Budget",
                style: TextStyle(color: Color(0xFF85BB65)),
              ),
            ),

            SizedBox(height: 30),

            Expanded(
              child: ListView.builder(
                itemCount: budgets.length,
                itemBuilder: (context, index) {

                  final item = budgets[index];

                  return GestureDetector(

                    onTap: () {
                      editBudget(item);
                    },

                    child: ListTile(
                      leading: Icon(
                        Icons.account_balance_wallet,
                        color: Color(0xFF85BB65),
                      ),

                      title: Text(
                        item["category"] ?? "-",
                        style: TextStyle(color: textColor),
                      ),

                      trailing: Text(
                        "Rp ${item["amount"]}",
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}