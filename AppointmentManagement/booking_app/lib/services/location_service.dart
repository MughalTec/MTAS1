import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location.dart';

class LocationService {
  static const String baseUrl = "http://localhost:8080";

  Future<List<Location>> getLocations() async {
    final res = await http.get(Uri.parse('$baseUrl/locations'));

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data as List)
          .map((e) => Location.fromJson(e))
          .toList();
    } else {
      throw Exception("Failed to load locations");
    }
  }

  Future<void> addLocation(Location location) async {
    await http.post(
      Uri.parse('$baseUrl/locations'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(location.toJson()),
    );
  }

  Future<void> updateLocation(Location location) async {
    await http.put(
      Uri.parse('$baseUrl/locations/${location.id}'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(location.toJson()),
    );
  }

  // ✅ FIXED NAME (important)
  Future<void> deleteLocation(int id) async {
    await http.delete(Uri.parse('$baseUrl/locations/$id'));
  }
}