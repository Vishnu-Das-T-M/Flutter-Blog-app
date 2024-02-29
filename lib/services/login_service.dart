import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginService {
  final String baseUrl = 'https://demo-blog.mashupstack.com/api';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final body = jsonEncode({'email': email, 'password': password});

    final response = await http
        .post(url, body: body);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];

      await _storage.write(key: 'token', value: token);
      return token;
    } else {
      throw Exception('Failed to login');
    }
  }
}