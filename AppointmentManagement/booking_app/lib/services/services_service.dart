import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/services.dart';

class ServicesService {
  static const String baseUrl = "http://localhost:8080";

  Future<List<Services>> getServices() async {
    final res = await http.get(Uri.parse('$baseUrl/services'));

    final List data = jsonDecode(res.body);
    return data.map((e) => Services.fromJson(e)).toList();
  }

  Future<void> addService(Services s) async {
    await http.post(
      Uri.parse('$baseUrl/services'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(s.toJson()),
    );
  }

  Future<void> updateService(Services s) async {
    await http.put(
      Uri.parse('$baseUrl/services/${s.id}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(s.toJson()),
    );
  }

  Future<void> deleteService(int id) async {
    await http.delete(Uri.parse('$baseUrl/services/$id'));
  }
}