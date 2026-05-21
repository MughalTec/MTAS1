import 'package:cloud_firestore/cloud_firestore.dart';

enum BookingStatus { pending, confirmed, cancelled, completed, noShow }

class BookingModel {

  final String id;
  final String clientName;
  final String serviceName;
  final DateTime startTime;
  final DateTime endTime;
  final String status;

  BookingModel({
    required this.id,
    required this.clientName,
    required this.serviceName,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {

    return BookingModel(
      id: json['id'].toString(),
      clientName: json['client_name'],
      serviceName: json['service_name'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      status: json['status'],
    );
  }
}






/* class BookingModel {
  final String id;
  final String providerId;
  final String serviceId;
  final String serviceName;
  final int serviceDurationMinutes;
  final double servicePrice;
  final String clientName;
  final String clientEmail;
  final String clientPhone;
  final String? clientNotes;
  final DateTime startTime;
  final DateTime endTime;
  final BookingStatus status;
  final String? cancellationReason;
  final String? meetingLink;
  final String? providerNotes;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.providerId,
    required this.serviceId,
    required this.serviceName,
    required this.serviceDurationMinutes,
    required this.servicePrice,
    required this.clientName,
    required this.clientEmail,
    required this.clientPhone,
    this.clientNotes,
    required this.startTime,
    required this.endTime,
    this.status = BookingStatus.confirmed,
    this.cancellationReason,
    this.meetingLink,
    this.providerNotes,
    required this.createdAt,
  });

  bool get isUpcoming => startTime.isAfter(DateTime.now()) &&
      status != BookingStatus.cancelled;

  bool get isPast => endTime.isBefore(DateTime.now());

  bool get canBeCancelled =>
      status == BookingStatus.confirmed || status == BookingStatus.pending;

  String get statusLabel {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.noShow:
        return 'No Show';
    }
  }

  factory BookingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BookingModel(
      id: doc.id,
      providerId: data['providerId'] ?? '',
      serviceId: data['serviceId'] ?? '',
      serviceName: data['serviceName'] ?? '',
      serviceDurationMinutes: data['serviceDurationMinutes'] ?? 60,
      servicePrice: (data['servicePrice'] ?? 0).toDouble(),
      clientName: data['clientName'] ?? '',
      clientEmail: data['clientEmail'] ?? '',
      clientPhone: data['clientPhone'] ?? '',
      clientNotes: data['clientNotes'],
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      status: BookingStatus.values.firstWhere(
            (e) => e.name == data['status'],
        orElse: () => BookingStatus.confirmed,
      ),
      cancellationReason: data['cancellationReason'],
      meetingLink: data['meetingLink'],
      providerNotes: data['providerNotes'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'providerId': providerId,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'serviceDurationMinutes': serviceDurationMinutes,
      'servicePrice': servicePrice,
      'clientName': clientName,
      'clientEmail': clientEmail,
      'clientPhone': clientPhone,
      'clientNotes': clientNotes,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'status': status.name,
      'cancellationReason': cancellationReason,
      'meetingLink': meetingLink,
      'providerNotes': providerNotes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
  factory BookingModel.fromJson(
      Map<String, dynamic> json) {

    return BookingModel(

      id: json['ID'].toString(),

      providerId:
      json['Provider_ID'].toString(),

      serviceId:
      json['Service_ID'].toString(),

      serviceName:
      json['ServiceName'] ?? '',

      serviceDurationMinutes:
      json['ServiceDurationMinutes'] ?? 0,

      servicePrice:
      (json['ServicePrice'] ?? 0)
          .toDouble(),

      clientName:
      json['ClientName'] ?? '',

      clientEmail:
      json['ClientEmail'] ?? '',

      clientPhone:
      json['ClientPhone'] ?? '',

      startTime:
      DateTime.parse(
        json['Start_Time'],
      ),

      endTime:
      DateTime.parse(
        json['End_Time'],
      ),

      createdAt:
      DateTime.parse(
        json['Created_At'],
      ),
    );
  }
}*/
