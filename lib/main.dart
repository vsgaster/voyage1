
import 'dart:convert';

import 'package:geocoder/geocoder.dart';
import 'package:flutter/material.dart';
import 'package:voyage1/Pages/register.dart';
import 'package:voyage1/Pages/test.dart';
import 'package:voyage1/login.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import 'Pages/location_api.dart';

void main(){
  runApp(MaterialApp(
    home: Inicio(),
  ));
}
class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}
class _InicioState extends State<Inicio> {
  var location = new Location();
  var _latitude;
  var _longitude;
  var _cidade;
  var _estado;
  var _cep;

  Future<dynamic> _getlocationPermission() async {
    var serviceEnabled = await location.serviceEnabled();
    if (! serviceEnabled){
      serviceEnabled = await location.requestService();
      if (! serviceEnabled){
        print(serviceEnabled);
        return;
      }
    }
    var permissiongranted = await location.hasPermission();
    if (permissiongranted == PermissionStatus.denied){
      permissiongranted = await location.requestPermission();
      if (permissiongranted != PermissionStatus.granted){

        return;
      }
    }
    var currentlocation = await location.getLocation();

    _latitude = currentlocation.latitude;
    _longitude = currentlocation.longitude;
    print(_latitude);
    print(_longitude);

    http.Response response = await LocationApi.locationn(_latitude, _longitude);

    var json = jsonDecode(response.body);

    print('${json['data'][0]['postal_code']}');
    _cep = json['data'][0]['postal_code'];
    _cidade = json['data'][0]['locality'];
    _estado = json['data'][0]['region_code'];
    print(_estado);
    print(_cidade);
    print(_cep);



  }
  @override
  void initState(){
    super.initState();
    _getlocationPermission();

  }
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(

      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFF9E1C9),Color(0xFF00CDA5)]
            ),
        ),
        child: Column(
          children: [
            Image.asset('images/v.png'),
            Container(
              height: 60,
              width: 220,
              child: ElevatedButton
                (onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => register(_cidade, _estado) ));
              },
                  child: Text("CADASTRE-SE",
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 20,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF9DF1D5),
                    onPrimary: Color(0xFF19574B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  )
              ),
            ),
            Container(
              child: TextButton(
                onPressed: (){
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => login() ));
                },
              child: Text("FAZER LOGIN",
                      style: TextStyle(
                      fontFamily:'Roboto',
                      fontSize: 15,
                      color: Color(0xFF19574B)
                  ),
              ),
              ),
            ),
            Container(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                    child: Text('LOGAR COM',
                          style: TextStyle(
                          fontFamily:'Roboto',
                          fontSize: 15,
                          color: Color(0xFF19574B)
                      ),
                    ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              height: 70,
                              width: 70,
                              child:  IconButton(
                                  onPressed: (){
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: const Text('BOTÂO EM MANUTENÇÃO'),
                                            content: const Text(
                                                'Este botão está fora de funcionalidade no momento'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ),
                                    );
                                  },
                                  icon: Image.asset('images/tt-icon.png')
                              )
                          ),
                           Container(
                                height: 70,
                                width: 70,
                                child:  IconButton(
                                    onPressed: () {
                                      showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title: const Text('BOTÂO EM MANUTENÇÃO'),
                                              content: const Text(
                                                  'Este botão está fora de funcionalidade no momento'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ),
                                      );
                                    },
                                    icon: Image.asset('images/fb-icon.png')
                                )
                            ),
                            Container(
                              height: 70,
                              width: 70,
                              child: IconButton(

                                onPressed: (){
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: const Text('BOTÂO EM MANUTENÇÃO'),
                                          content: const Text(
                                              'Este botão está fora de funcionalidade no momento'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                  );
                                },
                                icon: Image.asset('images/google-icon.png',)
                              )
                            ),
                        ],
                      ),
                  ],
                )
            ),
          ],
        ),
      )
      );
  }
}