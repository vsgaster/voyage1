import 'dart:convert';

import 'package:http/http.dart' as http;

class NotaApi2{
  static Future<dynamic> nota(coment, nota, token, id) async {
    var url = 'http://voyage-api-2021.azurewebsites.net/api/avaliacoes';
    var header = {"Authorization": "bearer ${token}",
      "Content-Type" : "application/json-patch+json"};
    Map params = {
      "comentario" : coment,
      "nota" : nota,
      "pontoTuristicoId" : id,
    };

    var _body = json.encode(params);
    print(_body);

    var response = await http.post(url,headers: header, body: _body);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return response;

  }
}