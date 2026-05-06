import 'package:postgres/postgres.dart';

class DatabaseConnection {
  static late PostgreSQLConnection conn;

  static Future<void> connect() async {
    conn = PostgreSQLConnection(
      'remotedev.mughaltec.com',
      5432,
      'MTAS',
      username: 'postgres',
      password: 'super',
    );

    await conn.open();
    print("DB Connected");
  }

  static Future<List<Map<String, dynamic>>> getCompanies() async {
    var result = await conn.query('SELECT * FROM mtas."tblCompany"');

    return result.map((row) => {
      "ID": row[0],
      "CompanyName": row[1],
      "BillingAddress": row[2],
      "City": row[3],
      "State": row[4],
      "ZipCode": row[5],
      "Country": row[6],
    }).toList();
  }

  static Future<List<Map<String, dynamic>>> getLocations() async {
    var result = await conn.query('SELECT * FROM mtas."tblLocation"');

    return result.map((row) => {
      "ID": row[0],
      "LocationName": row[1],
      "Address": row[2],
      "City": row[3],
      "State": row[4],
      "Country": row[5],
      "TimeZone": row[6],
      "PhoneNo": row[7],
      "Active": row[8],
    }).toList();
  }


  static Future<List<Map<String, dynamic>>> getUsers() async {
    var result = await conn.query('SELECT * FROM mtas."tblUser"');

    return result.map((row) => {
      "ID": row[0],
      "Name": row[1],
      "UserID": row[2],
      "Email": row[3],
      "PhoneNo": row[4],
      "Address": row[5],
      "Password": row[6],
      "Role": row[7],
      "Active": row[8],
    }).toList();
  }


  static Future<List<Map<String, dynamic>>> getServices() async {
    var result = await conn.query('''
    SELECT s."ID",
           s."LocationID",
           l."LocationName",
           s."ServiceName",
           s."Description",
           s."Duration_minutes",
           s."Buffer_Before",
           s."Buffer_After",
           s."Price",
           s."Active"
    FROM mtas."tblServices" s
    LEFT JOIN mtas."tblLocation" l 
      ON s."LocationID" = l."ID"
    ORDER BY s."ID" DESC
  ''');

    return result.map((row) => row.toColumnMap()).toList();
  }

}