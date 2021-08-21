import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class UploadApi {
  static Future<dynamic> upload(image, token) async {
    var url = 'http://voyage-api-2021.azurewebsites.net/api/usuarios/foto';
    var header = {
    "Content-Type" : "application/json-patch+json",
      "Authorization": "bearer $token"
    };
    var type = "image/jpeg";


    var imageBytes = image.readAsBytesSync();
    String mpfile = base64Encode(imageBytes);
    print(mpfile);

    var params = {
      "base64Image": mpfile,
    };

    var _body = json.encode(params);

    var response = await http.post(url,headers: header, body: _body);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return response;

  }
  static Future<dynamic> uploadplace(image, token, id) async {
    var url = 'http://voyage-api-2021.azurewebsites.net/api/pontos-turisticos/fotos?pontoTuristicoId=${id}';
    var header = {
      "Content-Type" : "application/json-patch+json",
      "Authorization": "bearer $token"
    };
    var type = "image/jpeg";


    var imageBytes = image.readAsBytesSync();
    String mpfile = base64Encode(imageBytes);
    print(mpfile);

    var params = {
      "base64Images": [mpfile] };

    var _body = json.encode(params);
    print(_body);
    var response = await http.post(url,headers: header, body: _body);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return response;

  }
}
