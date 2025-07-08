import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<String?> login(String phoneNumber, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phoneNumber': phoneNumber, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['access_token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return token;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  Future<bool> register({
    required String name,
    required String phoneNumber,
    required String password,
    required String role,
    required String sellerStatus,
  }) async {
    final url = Uri.parse('$baseUrl/register');
    final body = jsonEncode({
      'name': name,
      'phoneNumber': phoneNumber,
      'password': password,
      'role': role,
      'sellerStatus': sellerStatus,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    return response.statusCode == 201;
  }

  Future<bool> validateToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return false;

    final url = Uri.parse('$baseUrl/validate-token');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    return response.statusCode == 200;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
