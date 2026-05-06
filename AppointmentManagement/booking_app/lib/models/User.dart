class User {
  int? id;
  String name;
  String userId;
  String email;
  String phoneNo;
  String address;
  String password;
  String role;
  bool active;

  User({
    this.id,
    required this.name,
    required this.userId,
    required this.email,
    required this.phoneNo,
    required this.address,
    required this.password,
    required this.role,
    required this.active,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['ID'],
      name: json['Name'] ?? "",
      userId: json['UserID'] ?? "",
      email: json['Email'] ?? "",
      phoneNo: json['PhoneNo'] ?? "",
      address: json['Address'] ?? "",
      password: json['Password'] ?? "",
      role: json['Role'] ?? "",
      active: json['Active'] == true ||
          json['Active'] == 1 ||
          json['Active'].toString() == "true",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Name': name,
      'UserID': userId,
      'Email': email,
      'PhoneNo': phoneNo,
      'Address': address,
      'Password': password,
      'Role': role,
      'Active': active,
    };
  }
}