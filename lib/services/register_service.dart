import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterService {
  final String baseUrl = 'https://demo-blog.mashupstack.com/api';

  Future<bool?> register(String name, String email, String password,
      String password_confirmation) async {
    final url = Uri.parse('$baseUrl/register');
    final body = jsonEncode({
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password_confirmation
    });

    final response = await http
        .post(url, body: body);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}