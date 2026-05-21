import 'dart:convert';
import 'package:http/http.dart' as http;

class bookingService {

  static Future<List> getbookings() async {

    final res = await http.get(
      Uri.parse('http://localhost:8080/bookings'),
    );

    return jsonDecode(res.body);
  }
}