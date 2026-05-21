
class UserLogin {
  int? id;
  String email;
  String name;
  String provider;
  String providerId;
  String createdAt;
  bool active;
  String lastLogin;

  UserLogin({
    this.id,
    required this.email,
    required this.name,
    required this.provider,
    required this.providerId,
    required this.createdAt,
    required this.active,
    required this.lastLogin,
  });

  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(
      id: json['ID'],
      email: json['Email'] ?? "",
      name: json['Name'] ?? "",
      provider: json['Provider'] ?? "",
      providerId: json['Provider_ID'] ?? "",
      createdAt: json['Created_At'] ?? "",
      lastLogin: json['Last_Login'] ?? "",
      active: json['Active'] == true ||
          json['Active'] == 1 ||
          json['Active'].toString() == "true",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Email': email,
      'Name': name,
      'Provider': provider,
      'Provider_ID': providerId,
      'Created_At': createdAt,
      'Last_Login': lastLogin,
      'Active': active,
    };
  }
}