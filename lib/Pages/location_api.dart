import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:location/location.dart';
class LocationApi{

  static Future<dynamic> getlocationPermission() async {
    var location = Location();
    var _latitude;
    var _longitude;
    var _cidade;
    var _estado;

    var currentlocation = await location.getLocation();

    _latitude = currentlocation.latitude;
    _longitude = currentlocation.longitude;
    print(_latitude);
    print(_longitude);

    http.Response response = await LocationApi.locationn(_latitude, _longitude);

    var json = jsonDecode(response.body);


    _cidade = json['data'][0]['locality'];
    _estado = json['data'][0]['region_code'];

    var lista = {
      "cidade" : _cidade,
      "estado" : _estado
    };

    return lista;


  }
  static Future<dynamic> locationn(latitude, longitude) async {
    var key = '93246e6feedbd73fd67d52ba99e2be30';
    var url = 'http://api.positionstack.com/v1/reverse?access_key=${key}&query=${latitude},${longitude}';
    var header = {"Content-Type" : "application/json-patch+json"};


    var response = await http.get(url);



    return response;

  }
}