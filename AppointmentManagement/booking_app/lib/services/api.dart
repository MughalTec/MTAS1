import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static String baseUrl = "http://192.168.100.36:3000"; // 👈 apna IP

  static Future<List<dynamic>> getUsers() async {
    final res = await http.get(Uri.parse('$baseUrl/users'));

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Error");
    }
  }
}