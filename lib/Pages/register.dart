import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:voyage1/Pages/ragister_api.dart';
import 'package:voyage1/main.dart';

import 'package:voyage1/login.dart';
import 'package:http/http.dart' as http;

class register extends StatefulWidget {
  String cidade;
  String estado;

  register(this.cidade, this.estado);

  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<register> {
  var teste = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController nomeController = TextEditingController();
  TextEditingController sobrenomeController = TextEditingController();
  TextEditingController logradouroController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  TextEditingController complementoController = TextEditingController();

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
              maxHeight: 4296,
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
                    Image.asset(
                      'images/v.png',
                      scale: 8.5,
                    ),
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
                              controller: nomeController,
                              decoration: InputDecoration(
                                labelText: 'Nome',
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
                              controller: sobrenomeController,
                              decoration: InputDecoration(
                                labelText: 'Sobrenome',
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
                              String nome = nomeController.text;
                              String sobrenome = sobrenomeController.text;
                              String cidade = widget.cidade;
                              String estado = widget.estado;
                              String email = emailController.text;
                              String senha = senhaController.text;

                              http.Response response = await LoginApi2.register(
                                  email,
                                  senha,
                                  estado,
                                  cidade,
                                  nome,
                                  sobrenome);

                              if (response.statusCode == 201) {
                                print('${response.body}');
                                var ver = jsonDecode(response.body);
                                String token = ver['token'];
                                print('${ver['token']}');

                                showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('CONFIRMAÇÂO DE E-MAIL'),
                                    content: const Text(
                                        'Para que possa prossegir com o login, confirme seu e-mai sua caixa de mensagens'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => login())),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (response.statusCode == 400) {
                                if (senha == '') {
                                  setState(() {
                                    final snackBar = SnackBar(
                                      content:
                                          Text('Senha é um campo obrigatório!'),
                                      action: SnackBarAction(
                                        label: 'X',
                                        onPressed: () {},
                                      ),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  });
                                } else if (nome == '') {
                                  setState(() {
                                    final snackBar = SnackBar(
                                      content:
                                          Text('Nome é um campo obrigatório!'),
                                      action: SnackBarAction(
                                        label: 'X',
                                        onPressed: () {},
                                      ),
                                    );

                                    Scaffold.of(context).showSnackBar(snackBar);
                                  });
                                } else if (sobrenome == '') {
                                  setState(() {
                                    final snackBar = SnackBar(
                                      content: Text(
                                          'Sobreome é um campo obrigatório!'),
                                      action: SnackBarAction(
                                        label: 'X',
                                        onPressed: () {},
                                      ),
                                    );

                                    Scaffold.of(context).showSnackBar(snackBar);
                                  });
                                }

                                print('${response.body}');
                                var ver = jsonDecode(response.body);
                                if (ver['errors']['Email'][0] != null) {
                                  setState(() {
                                    final snackBar = SnackBar(
                                      content: Text(
                                          'E-mail é um ${ver['errors']['Email'][0]}'),
                                      action: SnackBarAction(
                                        label: 'X',
                                        onPressed: () {},
                                      ),
                                    );

                                    Scaffold.of(context).showSnackBar(snackBar);
                                  });
                                }
                                print('${ver['errors']['Email'][0]}');

                                if (ver[0]['message'] != null) {
                                  setState(() {
                                    final snackBar = SnackBar(
                                      content: Text('${ver[0]['message']}'),
                                      action: SnackBarAction(
                                        label: 'X',
                                        onPressed: () {},
                                      ),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  });
                                }
                              }
                            },
                            child: Text(
                              "CADASTRAR",
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
        },
      ),
    );
  }
}
