import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.5:3000';

  // ================= LOGIN =================
  static Future<bool> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password
        }),
      );

      print("LOGIN STATUS: ${res.statusCode}");
      print("LOGIN BODY: ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", data['token']);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("LOGIN ERROR: $e");
      return false;
    }
  }

  // ================= TOKEN =================
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    print("TOKEN: $token");

    return token;
  }

  // ================= SUMMARY =================
  static Future<Map<String, dynamic>> getSummary() async {
    try {
      final token = await getToken();

      final res = await http.get(
        Uri.parse("$baseUrl/summary"),
        headers: {
          "Authorization": "Bearer $token"
        },
      );

      print("SUMMARY STATUS: ${res.statusCode}");
      print("SUMMARY BODY: ${res.body}");

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return {
          "income": 0,
          "expense": 0,
          "balance": 0
        };
      }
    } catch (e) {
      print("SUMMARY ERROR: $e");
      return {
        "income": 0,
        "expense": 0,
        "balance": 0
      };
    }
  }

  // ================= GET TRANSACTIONS =================
  static Future<List<dynamic>> getTransactions() async {
    try {
      final token = await getToken();

      final res = await http.get(
        Uri.parse("$baseUrl/transactions"),
        headers: {
          "Authorization": "Bearer $token"
        },
      );

      print("GET TRX STATUS: ${res.statusCode}");
      print("GET TRX BODY: ${res.body}");

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return [];
      }
    } catch (e) {
      print("GET TRX ERROR: $e");
      return [];
    }
  }

  // ================= ADD TRANSACTION =================
  static Future<bool> addTransaction(
      String type, String category, int amount) async {
    try {
      final token = await getToken();

      final res = await http.post(
        Uri.parse("$baseUrl/transactions"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "type": type,
          "category": category,
          "amount": amount
        }),
      );

      print("ADD STATUS: ${res.statusCode}");

      return res.statusCode == 200;

    } catch (e) {
      print("ADD ERROR: $e");
      return false;
    }
  }

  // ================= DELETE TRANSACTION =================
  static Future<bool> deleteTransaction(int id) async {
    final token = await getToken();

    final res = await http.delete(
      Uri.parse("$baseUrl/transactions/$id"),
      headers: {
        "Authorization": "Bearer $token"
      },
    );

    return res.statusCode == 200;
  }

  // ================= UPDATE TRANSACTION =================
  static Future<bool> updateTransaction(
      int id, String type, String category, int amount) async {

    final token = await getToken();

    final res = await http.put(
      Uri.parse("$baseUrl/transactions/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({
        "type": type,
        "category": category,
        "amount": amount
      }),
    );

    return res.statusCode == 200;
  }

  // ================= REPORT =================
  static Future<List<dynamic>> getReport() async {
    final token = await getToken();

    final res = await http.get(
      Uri.parse("$baseUrl/report"),
      headers: {
        "Authorization": "Bearer $token"
      },
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Gagal mengambil laporan");
    }
  }

  // ================= GET BUDGET =================
  static Future<List<dynamic>> getBudgets() async {
    final token = await getToken();

    final res = await http.get(
      Uri.parse("$baseUrl/budget"),
      headers: {
        "Authorization": "Bearer $token"
      },
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Gagal mengambil budget");
    }
  }

  // ================= ADD BUDGET =================
  static Future<bool> addBudget(String category, int amount) async {
    final token = await getToken();

    final res = await http.post(
      Uri.parse("$baseUrl/budget"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({
        "category": category,
        "amount": amount
      }),
    );

    return res.statusCode == 200;
  }
  static Future<bool> register(String email, String password) async {

  final res = await http.post(

    Uri.parse("$baseUrl/auth/register"),

    headers: {
      "Content-Type": "application/json"
    },

    body: jsonEncode({
      "email": email,
      "password": password
    }),

  );

  print("REGISTER STATUS: ${res.statusCode}");
  print("REGISTER BODY: ${res.body}");

  return res.statusCode == 200;
}
// ================= BUDGET SUMMARY =================
static Future<List<dynamic>> getBudgetSummary() async {

  final token = await getToken();

  final res = await http.get(
    Uri.parse("$baseUrl/budget/summary"),
    headers: {
      "Authorization": "Bearer $token"
    },
  );

  if (res.statusCode == 200) {
    return jsonDecode(res.body);
  } else {
    return [];
  }
}

  // ================= UPDATE BUDGET =================
static Future<bool> updateBudget(
    int id, String category, int amount) async {

  final token = await getToken();

  final res = await http.put(
    Uri.parse("$baseUrl/budget/$id"),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
    body: jsonEncode({
      "category": category,
      "amount": amount
    }),
  );

  return res.statusCode == 200;
}

// ================= DELETE BUDGET =================
static Future<bool> deleteBudget(int id) async {

  final token = await getToken();

  final res = await http.delete(
    Uri.parse("$baseUrl/budget/$id"),
    headers: {
      "Authorization": "Bearer $token"
    },
  );

  return res.statusCode == 200;
}
}