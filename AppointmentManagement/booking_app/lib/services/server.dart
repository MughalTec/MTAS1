import 'dart:io';
import 'dart:convert';
import '../../services/database_connection.dart';

void main() async {
  var server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);

  print('API Server running on port 8080');

  await DatabaseConnection.connect();
  var connection = DatabaseConnection.conn;

  await for (HttpRequest request in server) {

    print("PATH: ${request.uri.path}");

    // CORS
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    request.response.headers.add('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    request.response.headers.add('Access-Control-Allow-Headers', '*');

    if (request.method == 'OPTIONS') {
      request.response.statusCode = HttpStatus.noContent;
      await request.response.close();
      continue;
    }

    // User Get
/*    if (request.method == 'GET' && request.uri.path == '/bookings') {
      var data = await DatabaseConnection.getUsers();
      request.response.headers.contentType = ContentType.json;
      request.response.write(jsonEncode(data));
      await request.response.close();
      continue;
    }*/


    // Company Get
    if (request.method == 'GET' && request.uri.path == '/companies') {
      var data = await DatabaseConnection.getCompanies();
      request.response.headers.contentType = ContentType.json;
      request.response.write(jsonEncode(data));
      await request.response.close();
      continue;
    }

    // Company Post
    if (request.method == 'POST' && request.uri.path == '/companies') {
      var body = await utf8.decoder.bind(request).join();
      var data = jsonDecode(body);

      await connection.query(
        '''INSERT INTO mtas."tblCompany"
    ("CompanyName","BillingAddress","City","State","ZipCode","Country")
    VALUES (@name,@address,@city,@state,@zip,@country)''',
        substitutionValues: {
          "name": data["CompanyName"],
          "address": data["BillingAddress"],
          "city": data["City"],
          "state": data["State"],
          "zip": data["ZipCode"],
          "country": data["Country"],
        },
      );

      request.response.write(jsonEncode({"status": "success"}));
      await request.response.close();
      continue;
    }

    // Company Update
    if (request.method == 'PUT' && request.uri.pathSegments.first == 'companies') {
      var id = int.parse(request.uri.pathSegments[1]);

      var body = await utf8.decoder.bind(request).join();
      var data = jsonDecode(body);

      await connection.query(
        '''UPDATE mtas."tblCompany" SET
    "CompanyName"=@name,
    "BillingAddress"=@address,
    "City"=@city,
    "State"=@state,
    "ZipCode"=@zip,
    "Country"=@country
    WHERE "ID"=@id''',
        substitutionValues: {
          "id": id,
          "name": data["CompanyName"],
          "address": data["BillingAddress"],
          "city": data["City"],
          "state": data["State"],
          "zip": data["ZipCode"],
          "country": data["Country"],
        },
      );

      request.response.write(jsonEncode({"status": "updated"}));
      await request.response.close();
      continue;
    }

    // Company Delete
    if (request.method == 'DELETE' && request.uri.pathSegments.first == 'companies') {
      var id = int.parse(request.uri.pathSegments[1]);

      await connection.query(
        'DELETE FROM mtas."tblCompany" WHERE "ID"=@id',
        substitutionValues: {"id": id},
      );

      request.response.write(jsonEncode({"status": "deleted"}));
      await request.response.close();
      continue;
    }





    // Location Get
    if (request.method == 'GET' && request.uri.path == '/locations') {
      var data = await DatabaseConnection.getLocations();
      request.response.headers.contentType = ContentType.json;
      request.response.write(jsonEncode(data));
      await request.response.close();
      continue;
    }

    // Location Post
    if (request.method == 'POST' && request.uri.path == '/locations') {
      var body = await utf8.decoder.bind(request).join();
      var data = jsonDecode(body);

      await connection.query(
        '''INSERT INTO mtas."tblLocation"
    ("LocationName","Address","City","State","Country","TimeZone","PhoneNo","Active")
    VALUES (@locationname,@address,@city,@state,@country,@timezone,@phoneno,@active)''',
        substitutionValues: {
          "locationname": data["LocationName"],
          "address": data["Address"],
          "city": data["City"],
          "state": data["State"],
          "country": data["Country"],
          "timezone": data["TimeZone"],
          "phoneno": data["PhoneNo"],
          "active": data["Active"],
        },
      );

      request.response.write(jsonEncode({"status": "success"}));
      await request.response.close();
      continue;
    }

    // Location Update
    if (request.method == 'PUT' && request.uri.pathSegments.first == 'locations') {
      var id = int.parse(request.uri.pathSegments[1]);

      var body = await utf8.decoder.bind(request).join();
      var data = jsonDecode(body);

      await connection.query(
        '''UPDATE mtas."tblLocation" SET
    "LocationName"=@locationname,
    "Address"=@address,
    "City"=@city,
    "State"=@state,
    "Country"=@country,
    "TimeZone"=@timezone,
    "PhoneNo"=@phoneno,
    "Active"=@active
    WHERE "ID"=@id''',
        substitutionValues: {
          "id": id,
          "locationname": data["LocationName"],
          "address": data["Address"],
          "city": data["City"],
          "state": data["State"],
          "country": data["Country"],
          "timezone": data["TimeZone"],
          "phoneno": data["PhoneNo"],
          "active": data["Active"],
        },
      );

      request.response.write(jsonEncode({"status": "updated"}));
      await request.response.close();
      continue;
    }

    // Location Delete
    if (request.method == 'DELETE' && request.uri.pathSegments.first == 'locations') {
      var id = int.parse(request.uri.pathSegments[1]);

      await connection.query(
        'DELETE FROM mtas."tblLocation" WHERE "ID"=@id',
        substitutionValues: {"id": id},
      );

      request.response.write(jsonEncode({"status": "deleted"}));
      await request.response.close();
      continue;
    }





    // User Get
    if (request.method == 'GET' && request.uri.path == '/users') {
      var data = await DatabaseConnection.getUsers();
      request.response.headers.contentType = ContentType.json;
      request.response.write(jsonEncode(data));
      await request.response.close();
      continue;
    }

    // User Post
    if (request.method == 'POST' && request.uri.path == '/users') {
      var body = await utf8.decoder.bind(request).join();
      var data = jsonDecode(body);

      await connection.query(
        '''INSERT INTO mtas."tblUser"
    ("Name","UserID","Email","PhoneNo","Address","Password","Role","Active")
    VALUES (@name,@userId,@email,@phoneno,@address,@password,@role,@active)''',
        substitutionValues: {
          "name": data["Name"],
          "userId": data["UserID"],
          "email": data["Email"],
          "phoneno": data["PhoneNo"],
          "address": data["Address"],
          "password": data["Password"],
          "role": data["Role"],
          "active": data["Active"],
        },
      );

      request.response.write(jsonEncode({"status": "success"}));
      await request.response.close();
      continue;
    }

    // User Update
    if (request.method == 'PUT' && request.uri.pathSegments.first == 'users') {
      var id = int.parse(request.uri.pathSegments[1]);

      var body = await utf8.decoder.bind(request).join();
      var data = jsonDecode(body);

      await connection.query(
        '''UPDATE mtas."tblUser" SET
    "Name"=@name,
    "UserID"=@userId,
    "Email"=@email,
    "PhoneNo"=@phoneno,
    "Address"=@address,
    "Password"=@password,
    "Role"=@role,
    "Active"=@active
    WHERE "ID"=@id''',
        substitutionValues: {
          "id": id,
          "name": data["Name"],
          "userId": data["UserID"],
          "email": data["Email"],
          "phoneno": data["PhoneNo"],
          "address": data["Address"],
          "password": data["Password"],
          "role": data["Role"],
          "active": data["Active"],
        },
      );

      request.response.write(jsonEncode({"status": "updated"}));
      await request.response.close();
      continue;
    }

    // User Delete
    if (request.method == 'DELETE' && request.uri.pathSegments.first == 'users') {
      var id = int.parse(request.uri.pathSegments[1]);

      await connection.query(
        'DELETE FROM mtas."tblUser" WHERE "ID"=@id',
        substitutionValues: {"id": id},
      );

      request.response.write(jsonEncode({"status": "deleted"}));
      await request.response.close();
      continue;
    }



    // Services Get
    if (request.method == 'GET' && request.uri.path == '/services') {
      var result = await connection.query('''
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

      var data = result.map((e) => e.toColumnMap()).toList();

      request.response.headers.contentType = ContentType.json;
      request.response.write(jsonEncode(data));
      await request.response.close();
      continue;
    }

    // Services Post
    if (request.method == 'POST' && request.uri.path == '/services') {
      var body = await utf8.decoder.bind(request).join();
      var data = jsonDecode(body);

      await connection.query('''
    INSERT INTO mtas."tblServices"
    ("LocationID","ServiceName","Description","Duration_minutes",
     "Buffer_Before","Buffer_After","Price","Active")
    VALUES (@locationId,@serviceName,@description,@duration,
            @before,@after,@price,@active)
  ''', substitutionValues: {
        "locationId": data["LocationID"],
        "serviceName": data["ServiceName"],
        "description": data["Description"],
        "duration": data["Duration_minutes"],
        "before": data["Buffer_Before"],
        "after": data["Buffer_After"],
        "price": data["Price"],
        "active": data["Active"],
      });

      request.response.write(jsonEncode({"status": "success"}));
      await request.response.close();
      continue;
    }

    // Services Update
    if (request.method == 'PUT' && request.uri.pathSegments.first == 'services') {
      var id = int.parse(request.uri.pathSegments[1]);

      var body = await utf8.decoder.bind(request).join();
      var data = jsonDecode(body);

      await connection.query('''
    UPDATE mtas."tblServices" SET
    "LocationID"=@locationId,
    "ServiceName"=@serviceName,
    "Description"=@description,
    "Duration_minutes"=@duration,
    "Buffer_Before"=@before,
    "Buffer_After"=@after,
    "Price"=@price,
    "Active"=@active
    WHERE "ID"=@id
  ''', substitutionValues: {
        "id": id,
        "locationId": data["LocationID"],
        "serviceName": data["ServiceName"],
        "description": data["Description"],
        "duration": data["Duration_minutes"],
        "before": data["Buffer_Before"],
        "after": data["Buffer_After"],
        "price": data["Price"],
        "active": data["Active"],
      });

      request.response.write(jsonEncode({"status": "updated"}));
      await request.response.close();
      continue;
    }

    // Services Delete
    if (request.method == 'DELETE' && request.uri.pathSegments.first == 'services') {
      var id = int.parse(request.uri.pathSegments[1]);

      await connection.query(
        'DELETE FROM mtas."tblServices" WHERE "ID"=@id',
        substitutionValues: {"id": id},
      );

      request.response.write(jsonEncode({"status": "deleted"}));
      await request.response.close();
      continue;
    }

  }
}