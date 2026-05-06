import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserService {
  static const String baseUrl = "http://localhost:8080";

  Future<List<User>> getUsers() async {
    final res = await http.get(Uri.parse('$baseUrl/users'));

    if (res.statusCode == 200) {
      final List decoded = jsonDecode(res.body);
      return decoded.map((e) => User.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load users");
    }
  }

  Future<void> addUser(User user) async {
    await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );
  }

  Future<void> updateUser(User user) async {
    await http.put(
      Uri.parse('$baseUrl/users/${user.id}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );
  }

  Future<void> deleteUser(int id) async {
    await http.delete(Uri.parse('$baseUrl/users/$id'));
  }
}