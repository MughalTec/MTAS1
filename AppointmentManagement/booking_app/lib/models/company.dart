class Company {
  int? id;
  String companyname;
  String billingaddress;
  String city;
  String state;
  String zipcode;
  String country;

  Company({
    this.id,
    required this.companyname,
    required this.billingaddress,
    required this.city,
    required this.state,
    required this.zipcode,
    required this.country,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['ID'],
      companyname: json['CompanyName'],
      billingaddress: json['BillingAddress'],
      city: json['City'],
      state: json['State'],
      zipcode: json['ZipCode'],
      country: json['Country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'CompanyName': companyname,
      'BillingAddress': billingaddress,
      'City': city,
      'State': state,
      'ZipCode': zipcode,
      'Country': country,
    };
  }
}