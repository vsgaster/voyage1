import 'dart:convert';

import 'package:http/http.dart' as http;

class LoginApi2{
  static Future<dynamic> register(String email, String senha, String estado, String cidade, String nome, String sobrenome) async {
    var url = 'http://voyage-api-2021.azurewebsites.net/api/usuarios/registrar';
    var header = {"Content-Type" : "application/json-patch+json"};
    Map params = {
      "nome" : nome,
      "sobrenome" : sobrenome,
      "email" : email,
      "senha" : senha,
      "logradouro": "string",
      "numero": "string",
      "cep": 27600000,
      "complemento": "string",
      "bairro": "string",
      "cidade": "Valença",
      "estado": "RJ"
    };

    var _body = json.encode(params);

    var response = await http.post(url,headers: header, body: _body);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return response;

  }
}