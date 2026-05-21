import 'dart:convert';
import 'package:booking_app/models/booking_model.dart';
import 'package:booking_app/models/client_model.dart';
import 'package:booking_app/models/provider_model.dart';
import 'package:booking_app/models/service_model.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:booking_app/models/booking_model.dart';

import '../models/provider_model.dart';
import '../models/service_model.dart';



class ApiService {
  final _uuid = const Uuid();

  /*static const String baseUrl = "http://localhost:4000";*/
  static const String baseUrl = "http://127.0.0.1:4000";

  static Future<List<dynamic>> getUsers() async {
    final response = await http.get(
      Uri.parse("$baseUrl/users"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception(
      "Failed to load users",
    );
  }


  // =========================
  // SAVE GOOGLE USER TO DB
  // =========================

  static Future<Map<String, dynamic>> saveGoogleUser(User user) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/google"),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "email": user.email,
        "name": user.displayName,
        "provider": "google",
        "provider_id": user.uid,
      }),
    );

    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> saveCompanyDetails({
    required String providerId,
    required String companyName,
    required String billingAddress,
    required String city,
    required String state,
    required String zipCode,
    required String country,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/company-details"),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "provider_id": providerId,
        "companyName": companyName,
        "billingAddress": billingAddress,
        "city": city,
        "state": state,
        "zipCode": zipCode,
        "country": country,
      }),
    );

    return jsonDecode(response.body);
  }




  // SERVICES
  Future<List<ServiceModel>> getServices(String providerId) async {
    final res = await http.get(
      Uri.parse("$baseUrl/services/providers/$providerId"),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return (data['data'] as List)
          .map((e) => ServiceModel.fromJson(e))
          .toList();
    }

    return [];
  }

  // PROVIDER
  static Future<ProviderModel?> getProviderBySlug(String slug) async {
    final response = await http.get(
      Uri.parse("$baseUrl/providers/$slug"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return ProviderModel.fromJson(data['data']);
    }

    return null;
  }

  // =========================
  // CREATE BOOKING
  // =========================

  /*Future<BookingModel> createBooking({

    required ProviderModel provider,
    required ServiceModel service,
    required DateTime startTime,
    required String clientName,
    required String clientEmail,
    required String clientPhone,
    String? clientNotes,

  }) async {


    final endTime = startTime.add(
      Duration(
        minutes:
        service.durationMinutes,
      ),
    );

    final response = await http.post(

      Uri.parse(
        '$baseUrl/bookings/create',
      ),

      headers: {
        "Content-Type":
        "application/json"
      },

      body: jsonEncode({

        "providerId":
        provider.id,

        "serviceId":
        service.id,

        "serviceName":
        service.name,

        "serviceDurationMinutes":
        service.durationMinutes,

        "servicePrice":
        service.price,

        "clientName":
        clientName,

        "clientEmail":
        clientEmail,

        "clientPhone":
        clientPhone,

        "clientNotes":
        clientNotes,

        "startTime":
        startTime.toIso8601String(),

        "endTime":
        endTime.toIso8601String(),

      }),
    );

    if (response.statusCode == 200) {
      final data =
      jsonDecode(response.body);

      return BookingModel.fromJson(
        data['booking'],
      );
    }

    throw Exception(
      "Booking failed",
    );
  }*/

  // ========================================
// GET BOOKINGS
// ========================================

  Future<List<BookingModel>> getBookings() async {

    final response = await http.get(
      Uri.parse('$baseUrl/bookings'),
    );

    final data = jsonDecode(response.body);

    return List<BookingModel>.from(
      data.map((x) => BookingModel.fromJson(x)),
    );
  }


// ========================================
// GET CLIENTS
// ========================================

  Future<List<ClientModel>> getClients() async {

    final response = await http.get(
      Uri.parse('$baseUrl/bookings/clients'),
    );

    final data = jsonDecode(response.body);

    return List<ClientModel>.from(
      data.map((x) => ClientModel.fromJson(x)),
    );
  }


// ========================================
// CREATE CLIENT
// ========================================

  Future<int?> createClient(Map<String, dynamic> body) async {

    final response = await http.post(
      Uri.parse('$baseUrl/bookings/create-client'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    return data['clientId']; // MUST return ID
  }


// ========================================
// CREATE BOOKING
// ========================================

  Future<bool> createBooking(Map<String, dynamic> body) async {

    print("BOOKING BODY: $body"); // DEBUG

    final response = await http.post(
      Uri.parse('$baseUrl/bookings'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      print("ERROR: ${response.body}");
      return false;
    }

    return data['success'] ?? false;
  }

}



