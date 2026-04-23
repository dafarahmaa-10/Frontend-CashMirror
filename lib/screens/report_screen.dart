import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';

class ReportScreen extends StatefulWidget {

  final bool isDarkMode;

  const ReportScreen({
    Key? key,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {

  List report = [];
  bool loading = true;

  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  /// WARNA PIE CHART
  final List<Color> chartColors = [
    Colors.orange,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.indigo,
    Colors.amber,
    Colors.cyan,
    Colors.pink
  ];

  @override
  void initState() {
    super.initState();
    loadReport();
  }

  void loadReport() async {

    try {

      final data = await ApiService.getReport();

      setState(() {
        report = data;
        loading = false;
      });

    } catch (e) {

      print("REPORT ERROR: $e");

      setState(() {
        loading = false;
      });

    }

  }

  /// PIE CHART DATA
  List<PieChartSectionData> buildChart() {

    if (report.isEmpty) return [];

    final total = report.fold<int>(
      0,
      (sum, item) => sum + ((item["total"] ?? 0) as num).toInt(),
    );

    if (total == 0) return [];

    return report.asMap().entries.map((entry) {

      final index = entry.key;
      final item = entry.value;

      final value = ((item["total"] ?? 0) as num).toInt();
      final percentage = (value / total) * 100;

      return PieChartSectionData(
        value: value.toDouble(),
        title: "${percentage.toStringAsFixed(0)}%",
        radius: 80,
        color: chartColors[index % chartColors.length],
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );

    }).toList();

  }

  @override
  Widget build(BuildContext context) {

    final bgColor = widget.isDarkMode ? Colors.black : Color(0xFFF5F5F5);
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;

    return Scaffold(

      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(
          "Laporan Pengeluaran",
          style: TextStyle(color: textColor),
        ),
      ),

      body: loading
          ? Center(child: CircularProgressIndicator())

          : report.isEmpty
              ? Center(
                  child: Text(
                    "Belum ada data laporan",
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                )

              : Column(
                  children: [

                    SizedBox(height: 30),

                    /// PIE CHART
                    SizedBox(
                      height: 250,
                      child: PieChart(
                        PieChartData(
                          sections: buildChart(),
                          centerSpaceRadius: 40,
                          sectionsSpace: 2,
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    /// LIST KATEGORI
                    Expanded(
                      child: ListView.builder(
                        itemCount: report.length,
                        itemBuilder: (context, index) {

                          final item = report[index];

                          final category = item["category"] ?? "-";
                          final total = ((item["total"] ?? 0) as num).toInt();

                          return ListTile(

                            leading: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: chartColors[index % chartColors.length],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),

                            title: Text(
                              category,
                              style: TextStyle(color: textColor),
                            ),

                            trailing: Text(
                              formatter.format(total),
                              style: TextStyle(color: textColor),
                            ),

                          );

                        },
                      ),
                    )

                  ],
                ),
    );
  }
}