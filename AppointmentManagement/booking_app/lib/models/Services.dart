class Services {
  int? id;
  int locationId;
  String? locationName;
  String serviceName;
  String description;
  int durationMinutes;
  int bufferBefore;
  int bufferAfter;
  double price;
  bool active;

  Services({
    this.id,
    required this.locationId,
    this.locationName,
    required this.serviceName,
    required this.description,
    required this.durationMinutes,
    required this.bufferBefore,
    required this.bufferAfter,
    required this.price,
    required this.active,
  });

  factory Services.fromJson(Map<String, dynamic> json) {
    return Services(
      id: json['ID'] is int ? json['ID'] : int.tryParse(json['ID'].toString()) ?? 0,

      locationId: json['LocationID'] is int
          ? json['LocationID']
          : int.tryParse(json['LocationID'].toString()) ?? 0,

      locationName: json['LocationName'] ?? "",

      serviceName: json['ServiceName'] ?? "",
      description: json['Description'] ?? "",

      durationMinutes: json['Duration_minutes'] is int
          ? json['Duration_minutes']
          : int.tryParse(json['Duration_minutes'].toString()) ?? 0,

      bufferBefore: json['Buffer_Before'] is int
          ? json['Buffer_Before']
          : int.tryParse(json['Buffer_Before'].toString()) ?? 0,

      bufferAfter: json['Buffer_After'] is int
          ? json['Buffer_After']
          : int.tryParse(json['Buffer_After'].toString()) ?? 0,

      price: (json['Price'] is num)
          ? json['Price'].toDouble()
          : double.tryParse(json['Price'].toString()) ?? 0,

      active: json['Active'] == true ||
          json['Active'] == 1 ||
          json['Active'].toString() == "true",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'LocationID': locationId,
      'ServiceName': serviceName,
      'Description': description,
      'Duration_minutes': durationMinutes,
      'Buffer_Before': bufferBefore,
      'Buffer_After': bufferAfter,
      'Price': price,
      'Active': active,
    };
  }
}