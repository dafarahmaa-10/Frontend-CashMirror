import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import 'add_transaction_screen.dart';
import 'report_screen.dart';
import 'budget_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final green = Color(0xFF85BB65);
  final yellow = Color(0xFFD4E157);

  bool isDarkMode = true;

  int tabIndex = 0;
  int filterIndex = 0;

  DateTime selectedDate = DateTime.now();

  int income = 0;
  int expense = 0;
  int balance = 0;

  List transactions = [];
  List budgets = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  String rupiah(int number) {
    final format = NumberFormat.currency(
      locale: "id_ID",
      symbol: "Rp ",
      decimalDigits: 0,
    );
    return format.format(number);
  }

  String getDateLabel() {
    if (filterIndex == 0) {
      return DateFormat("dd MMM yyyy").format(selectedDate);
    }

    if (filterIndex == 1) {
      final start = selectedDate.subtract(Duration(days: 6));

      return "${DateFormat("dd MMM").format(start)} - ${DateFormat("dd MMM").format(selectedDate)}";
    }

    return DateFormat("MMMM yyyy").format(selectedDate);
  }

  Future<void> loadData() async {
    try {
      final summary = await ApiService.getSummary();
      final trx = await ApiService.getTransactions();
      final budgetData = await ApiService.getBudgetSummary();

      setState(() {
        income = summary["income"] ?? 0;
        expense = summary["expense"] ?? 0;
        balance = summary["balance"] ?? 0;

        transactions = trx;
        budgets = budgetData;
      });
    } catch (e) {
      print("ERROR DASHBOARD: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = isDarkMode ? Colors.black : Colors.white;
    Color textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,

      body: Stack(
        children: [
          Positioned(
            top: -120,
            left: 0,
            right: 0,
            child: Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.2,
                  colors: [green.withOpacity(0.4), Colors.transparent],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                /// HEADER
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PopupMenuButton<String>(
                        icon: Icon(Icons.menu, color: green),

                        onSelected: (value) {
                          if (value == "report") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ReportScreen(isDarkMode: isDarkMode),
                              ),
                            );
                          }

                          if (value == "budget") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    BudgetScreen(isDarkMode: isDarkMode),
                              ),
                            );
                          }

                          if (value == "darkmode") {
                            setState(() {
                              isDarkMode = !isDarkMode;
                            });
                          }
                        },

                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: "report",
                            child: Row(
                              children: [
                                Icon(Icons.pie_chart),
                                SizedBox(width: 10),
                                Text("Laporan"),
                              ],
                            ),
                          ),

                          PopupMenuItem(
                            value: "budget",
                            child: Row(
                              children: [
                                Icon(Icons.account_balance_wallet),
                                SizedBox(width: 10),
                                Text("Budget"),
                              ],
                            ),
                          ),

                          PopupMenuItem(
                            value: "darkmode",
                            child: Row(
                              children: [
                                Icon(
                                  isDarkMode
                                      ? Icons.dark_mode
                                      : Icons.light_mode,
                                ),
                                SizedBox(width: 10),
                                Text(isDarkMode ? "Light Mode" : "Dark Mode"),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Column(
                        children: [
                          Icon(Icons.attach_money, color: green),
                          Text("Total", style: TextStyle(color: Colors.grey)),
                          Text(
                            rupiah(balance),
                            style: TextStyle(
                              color: green,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 24),
                    ],
                  ),
                ),

                /// TAB
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    tab("PENGELUARAN", 0),
                    SizedBox(width: 30),
                    tab("PEMASUKAN", 1),
                  ],
                ),

                SizedBox(height: 20),

                /// CARD
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          padding: EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: isDarkMode
                                ? Color(0xFF1A1A1A)
                                : Colors.white,
                            border: Border.all(color: green.withOpacity(0.3)),
                          ),

                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                /// TITLE
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Center(
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "Cash",
                                              style: TextStyle(
                                                color: textColor,
                                              ),
                                            ),
                                            TextSpan(
                                              text: "Mirror",
                                              style: TextStyle(color: green),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 10),

                                Text(
                                  getDateLabel(),
                                  style: TextStyle(color: Colors.grey),
                                ),

                                SizedBox(height: 10),

                                /// FILTER
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    filter("Hari", 0),
                                    filter("Minggu", 1),
                                    filter("Bulan", 2),
                                  ],
                                ),

                                SizedBox(height: 20),

                                /// WARNING BUDGET
                                Column(
                                  children: budgets.map((b) {
                                    if (b["percentage"] >= 60) {
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 10),
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.warning,
                                              color: Colors.orange,
                                            ),

                                            SizedBox(width: 10),

                                            Expanded(
                                              child: Text(
                                                "Budget ${b["category"]} hampir habis (${b["percentage"]}%)",
                                                style: TextStyle(
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }

                                    return SizedBox();
                                  }).toList(),
                                ),

                                SizedBox(height: 20),

                                /// CIRCLE
                                Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: yellow,
                                      width: 12,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      tabIndex == 0
                                          ? rupiah(expense)
                                          : rupiah(income),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 20),

                                /// ADD BUTTON
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: yellow,
                                        width: 2,
                                      ),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.add, color: yellow),
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                AddTransactionScreen(
                                                  type: tabIndex == 0
                                                      ? "expense"
                                                      : "income",
                                                  isDarkMode: isDarkMode,
                                                ),
                                          ),
                                        );

                                        await loadData();
                                      },
                                    ),
                                  ),
                                ),

                                SizedBox(height: 20),

                                /// LIST TRANSAKSI
                                transactions.isEmpty
                                    ? Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Text(
                                          "Belum ada transaksi",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      )
                                    : Column(
                                        children: transactions.map((trx) {
                                          return item(trx);
                                        }).toList(),
                                      ),

                                SizedBox(height: 100),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tab(String text, int i) {
    return GestureDetector(
      onTap: () {
        setState(() {
          tabIndex = i;
        });
      },
      child: Text(
        text,
        style: TextStyle(
          color: tabIndex == i ? green : Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget filter(String text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          filterIndex = index;
        });
      },
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              color: filterIndex == index ? green : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),

          if (filterIndex == index)
            Container(
              margin: EdgeInsets.only(top: 4),
              height: 2,
              width: 20,
              color: green,
            ),
        ],
      ),
    );
  }

  Widget item(dynamic trx) {
  final isExpense = trx["type"] == "expense";

  return GestureDetector(
    onTap: () {
      final categoryController =
          TextEditingController(text: trx["category"]);

      final amountController =
          TextEditingController(text: trx["amount"].toString());

      showDialog(
        context: context,
        builder: (context) {

          final textColor =
              isDarkMode ? Colors.white : Colors.black;

          return AlertDialog(
            backgroundColor:
                isDarkMode ? Color(0xFF1A1A1A) : Colors.white,

            title: Text(
              "Edit Transaksi",
              style: TextStyle(color: textColor),
            ),

            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// KATEGORI
                TextField(
                  controller: categoryController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: "Kategori",
                    labelStyle: TextStyle(
                      color:
                          isDarkMode ? Colors.grey : Colors.black54,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: isDarkMode
                            ? Colors.grey
                            : Colors.black54,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                /// JUMLAH
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: "Jumlah",
                    labelStyle: TextStyle(
                      color:
                          isDarkMode ? Colors.grey : Colors.black54,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: isDarkMode
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

                  await ApiService.deleteTransaction(trx["id"]);

                  Navigator.pop(context);

                  loadData();

                },
                child: Text(
                  "Hapus",
                  style: TextStyle(color: Colors.red),
                ),
              ),

              /// UPDATE
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode
                      ? Color(0xFF2A2A2A)
                      : Colors.white,
                ),
                onPressed: () async {

                  await ApiService.updateTransaction(
                    trx["id"],
                    trx["type"],
                    categoryController.text,
                    int.parse(amountController.text),
                  );

                  Navigator.pop(context);

                  loadData();

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
    },

    child: Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDarkMode ? Color(0xFF2A2A2A) : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        children: [

          Icon(
            isExpense ? Icons.arrow_downward : Icons.arrow_upward,
            color: isExpense ? Colors.orange : Colors.green,
          ),

          SizedBox(width: 12),

          Expanded(
            child: Text(
              trx["category"],
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),

          Text(
            rupiah(trx["amount"]),
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}
}
