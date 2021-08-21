import 'dart:convert';

import 'package:http/http.dart' as http;

class LoginApi{
  static Future<dynamic> login(String email, String senha) async {
    var url = 'http://voyage-api-2021.azurewebsites.net/api/usuarios/logar';
    var header = {"Content-Type" : "application/json-patch+json"};
    Map params = {
      "email" : email,
      "senha" : senha
    };

    var _body = json.encode(params);

    var response = await http.post(url,headers: header, body: _body);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return response;

  }
}