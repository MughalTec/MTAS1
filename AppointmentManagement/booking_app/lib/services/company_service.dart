import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/company.dart';

class CompanyService {
  static const String baseUrl = "http://localhost:8080";

  Future<List<Company>> getCompanies() async {
    final res = await http.get(Uri.parse('$baseUrl/companies'));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data as List)
          .map((e) => Company.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to load companies");
    }
  }

  Future<void> addCompany(Company company) async {
    await http.post(
      Uri.parse('$baseUrl/companies'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(company.toJson()),
    );
  }

  Future<void> updateCompany(Company company) async {
    await http.put(
      Uri.parse('$baseUrl/companies/${company.id}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(company.toJson()),
    );
  }

  Future<void> deleteCompany(int id) async {
    await http.delete(Uri.parse('$baseUrl/companies/$id'));
  }
}