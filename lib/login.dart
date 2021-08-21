import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:voyage1/Pages/location_api.dart';
import 'package:voyage1/Pages/login_api.dart';
import 'package:voyage1/main.dart';
import 'package:voyage1/Pages/home.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
class login extends StatefulWidget {

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  var location = new Location();
  var _longitude;
  var _latitude;
  var _cidade;
  var _estado;
  var teste = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

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
    _cidade = json['data'][0]['locality'];
    _estado = json['data'][0]['region_code'];
    print(_estado);
    print(_cidade);




  }

  void _trocafundo() {
    setState(() {
      if (teste == true) {
        print('$teste');
        return teste = false;
      } else
        print('$teste');
      return teste = true;
    });
  }
  @override
  void initState(){
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return FutureBuilder(
              future: _getlocationPermission(),
              builder: (context, snapshot){


                return SingleChildScrollView(
                  child: ConstrainedBox(
                   constraints: BoxConstraints(
                     minHeight: viewportConstraints.maxHeight,
                     maxHeight: viewportConstraints.maxHeight + 206,
                   ),
                   child: Expanded(
                     child: Container(
                       height: 700,
                       decoration: BoxDecoration(
                         gradient: LinearGradient(
                             begin: Alignment.topCenter,
                             end: Alignment.bottomCenter,
                             colors: [Color(0xFFF9E1C9), Color(0xFF00CDA5)]),
                       ),
                       child: Column(
                         children: [
                           Image.asset('images/v.png'),
                           Padding(
                             padding: EdgeInsets.only(
                                 top: 0, bottom: 30, left: 0, right: 0),
                             child: Container(
                                 height: 45,
                                 width: 315,
                                 child: Material(
                                   borderRadius: BorderRadius.circular(20),
                                   elevation: 10.0,
                                   shadowColor: Colors.grey,
                                   child: TextField(
                                     controller: emailController,
                                     decoration: InputDecoration(
                                       labelText: 'E-mail',
                                       fillColor: Color(0xFF9DF1D5),
                                       filled: true,
                                       border: OutlineInputBorder(
                                           borderRadius:
                                           BorderRadius.all(Radius.circular(20))),
                                     ),
                                   ),
                                 )),
                           ),
                           Padding(
                             padding: EdgeInsets.only(
                                 top: 0, bottom: 35, left: 0, right: 0),
                             child: Container(
                                 height: 45,
                                 width: 315,
                                 child: Material(
                                   borderRadius: BorderRadius.circular(20),
                                   elevation: 10.0,
                                   shadowColor: Colors.grey,
                                   child: TextField(
                                     controller: senhaController,
                                     obscureText: teste,
                                     decoration: InputDecoration(
                                       suffixIcon: IconButton(
                                         onPressed: _trocafundo,
                                         icon: const Icon(Icons.remove_red_eye,
                                             color: Color(0xFF00CDA5)),
                                       ),
                                       labelText: 'Senha',
                                       fillColor: Color(0xFF9DF1D5),
                                       filled: true,
                                       border: OutlineInputBorder(
                                           borderRadius:
                                           BorderRadius.all(Radius.circular(20))),
                                     ),
                                   ),
                                 )),
                           ),
                           Padding(
                             padding:
                             EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
                             child: Container(
                               height: 60,
                               width: 220,
                               child: ElevatedButton(
                                   onPressed: () async {
                                     String email = emailController.text;
                                     String senha = senhaController.text;
                                     if (email == '') {
                                       setState(() {
                                         final snackBar = SnackBar(
                                           content: Text(
                                               'Senha e/ou Email são campos obrigatórios!'),
                                           action: SnackBarAction(
                                             label: 'X',
                                             onPressed: () {
                                               // código para desfazer a ação!
                                             },
                                           ),
                                         );
                                         // Encontra o Scaffold na árvore de widgets
                                         // e o usa para exibir o SnackBar!
                                         Scaffold.of(context).showSnackBar(snackBar);
                                       });
                                     }
                                     http.Response response =
                                     await LoginApi.login(email, senha);

                                     if (response.statusCode == 200){
                                       print('${response.body}');
                                       var ver = jsonDecode(response.body);
                                       String token = ver['token'];
                                       print('${ver['token']}');

                                       Navigator.push(
                                           context,
                                           MaterialPageRoute(
                                               builder: (context) => HomeP(token, _cidade, _estado)));}
                                     else if (response.statusCode == 400)
                                       print('${response.body}');
                                     var ver = jsonDecode(response.body);


                                     setState(() {
                                       final snackBar = SnackBar(
                                         content: Text('Senha e/ou Email incorreto!'),
                                         action: SnackBarAction(
                                           label: 'X',
                                           onPressed: () {
                                             // código para desfazer a ação!
                                           },
                                         ),
                                       );
                                       // Encontra o Scaffold na árvore de widgets
                                       // e o usa para exibir o SnackBar!
                                       Scaffold.of(context).showSnackBar(snackBar);
                                     });
                                   },
                                   child: Text(
                                     "ENTRAR",
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
                                   )),
                             ),
                           ),
                           Padding(
                             padding:
                             EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
                             child: Container(
                               child: TextButton(
                                 onPressed: () {
                                   Navigator.push(
                                       context,
                                       MaterialPageRoute(
                                           builder: (context) => Inicio()));
                                 },
                                 child: Text(
                                   "VOLTAR",
                                   style: TextStyle(
                                       fontFamily: 'Roboto',
                                       fontSize: 15,
                                       color: Color(0xFF19574B)),
                                 ),
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                   ),
                 ));
          });
        },
      ),
    );
  }
}
