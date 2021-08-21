import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:voyage1/Pages/home.dart';
import 'package:voyage1/Pages/nota_api.dart';
import 'package:voyage1/main.dart';

import 'package:voyage1/login.dart';
import 'package:http/http.dart' as http;

class addcoment extends StatefulWidget {
  String cidade;
  String estado;
  String token;
  String placeid;

  addcoment(this.token, this.placeid, this.cidade, this.estado);
  @override
  _addcomentState createState() => _addcomentState();
}

class _addcomentState extends State<addcoment> {
  var teste = true;
  TextEditingController comentController = TextEditingController();
  TextEditingController notaController = TextEditingController();





  _clickbutton() async {}

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
              child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
              maxHeight: viewportConstraints.maxHeight + 206,
            ),
            child: Expanded(
              child: Container(
                width: double.infinity,
                height: 700,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFF9E1C9), Color(0xFF00CDA5)]),
                ),
                child: Column(
                  children: [
                    Image.asset('images/v.png', scale: 7,),
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
                              controller: notaController,
                              keyboardType: TextInputType.number,

                              decoration: InputDecoration(
                                labelText: 'Nota',
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
                          height: 105,
                          width: 315,
                          child: Material(
                            borderRadius: BorderRadius.circular(20),
                            elevation: 10.0,
                            shadowColor: Colors.grey,
                            child: TextField(
                              maxLines: 5,
                              minLines: 4,
                              keyboardType: TextInputType.text,
                              controller: comentController,

                              decoration: InputDecoration(
                                labelText: 'Comentário',
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
                              var comentario = comentController.text;
                              var nota = notaController.text;

                              String token = widget.token;
                              String id = widget.placeid;
                              print(id);

                              http.Response response =
                                  await NotaApi2.nota(comentario, nota, token, id);

                              var ver = jsonDecode(response.body);


                              if (response.statusCode == 201){
                                print('${response.body}');

                                String token = ver['token'];
                                print('${ver['token']}');

                                Navigator.pop(context);
                              }
                              else if (response.statusCode == 400){

                                if (ver[0]['message'] != null){
                                  setState(() {
                                    final snackBar = SnackBar(
                                      content: Text('${ver[0]['message']}'),
                                      action: SnackBarAction(
                                        label: 'X',
                                        onPressed: () {
                                        },
                                      ),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  });

                                }

                            }},
                            child: Text(
                              "ADD COMENTARIO",
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
                            Navigator.pop(context);
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
        },
      ),
    );
  }
}
