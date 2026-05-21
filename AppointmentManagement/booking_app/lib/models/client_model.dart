class ClientModel {

  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  ClientModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {

    return ClientModel(
      id: json['ID'],
      firstName: json['First_Name'],
      lastName: json['Last_Name'],
      email: json['Email'],
      phone: json['Phone'],
    );
  }

  String get fullName => "$firstName $lastName";
}