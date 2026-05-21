class Location {
  int? id;
  String locationname;
  String address;
  String city;
  String state;
  String country;
  String timezone;
  String phoneno;
  bool active;

  Location({
    this.id,
    required this.locationname,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.timezone,
    required this.phoneno,
    required this.active,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['ID'],
      locationname: json['LocationName'] ?? "",
      address: json['Address'] ?? "",
      city: json['City'] ?? "",
      state: json['State'] ?? "",
      country: json['Country'] ?? "",
      timezone: json['TimeZone'] ?? "",
      phoneno: json['PhoneNo'] ?? "",
      active: json['Active'] == true ||
          json['Active'] == 1 ||
          json['Active'].toString() == "true",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'LocationName': locationname,
      'Address': address,
      'City': city,
      'State': state,
      'Country': country,
      'TimeZone': timezone,
      'PhoneNo': phoneno,
      'Active': active,
    };
  }
}