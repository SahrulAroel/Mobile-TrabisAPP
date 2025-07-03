
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "http://127.0.0.1:8000/api"; // Ganti dengan URL API kamu

  // Register
  static Future<Map<String, dynamic>> register(String name, String email, String password, String confirmPassword) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      body: {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": confirmPassword,
      },
    );

    return jsonDecode(response.body);
  }

  // Login
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      body: {
        "email": email,
        "password": password,
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['status']) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", data['token']);
    }

    return data;
  }

  // Get token
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // Get profile
  static Future<Map<String, dynamic>> profile() async {
    String? token = await getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/profile"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return jsonDecode(response.body);
  }

  // Logout
  static Future<Map<String, dynamic>> logout() async {
    String? token = await getToken();

    final response = await http.post(
      Uri.parse("$baseUrl/logout"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (data['status']) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove("token");
    }

    return data;
  }

  // Cek status login
  static Future<bool> isLoggedIn() async {
    String? token = await getToken();
    return token != null;
  }

  // Hapus token secara paksa
  static Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }
}
