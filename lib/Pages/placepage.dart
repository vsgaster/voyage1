import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:voyage1/Pages/AddComent%C3%A1rio.dart';
import 'package:voyage1/Pages/location_api.dart';
import 'package:voyage1/Pages/uparimagem_api.dart';

// ignore: must_be_immutable
class PlacePage extends StatefulWidget {
  String cidade;
  String estado;
  String placeid;
  String token;
  String foto;
  String imageurl;
  String nome;
  String descricao;
  bool fav;

  PlacePage(this.imageurl, this.nome, this.fav, this.descricao, this.token,
      this.cidade, this.estado);

  @override
  _PlacePageState createState() => _PlacePageState();
}

class _PlacePageState extends State<PlacePage> {
  var _image;

  Future<dynamic> _pickImage() async {
    imageCache.clear();
    imageCache.clearLiveImages();
    File selected = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = selected;
      print(_image);
    });
    http.Response response =
    await UploadApi.uploadplace(_image, widget.token, widget.descricao);
    print(response.body);
  }

  Future<dynamic> _getpontosturisticos() async {
    http.Response response;
    print(widget.descricao);

    var url =
        'http://voyage-api-2021.azurewebsites.net/api/pontos-turisticos/${widget
        .descricao}';

    var header = {"Authorization": "bearer ${widget.token}"};

    response = await http.get(url, headers: header);
    print(response.body);

    var resposta = json.decode(response.body);
    print(resposta);
    _getuserimage();
    return resposta;
  }

  Future<dynamic> _getuserimage() async {
    imageCache.clear();
    imageCache.clearLiveImages();

    http.Response response2;

    var url2 = 'http://voyage-api-2021.azurewebsites.net/api/usuarios/foto';
    var header = {"Authorization": "bearer ${widget.token}"};
    response2 = await http.get(url2, headers: header);
    print(widget.descricao);
    var foto = json.decode(response2.body);
    print('${foto['url']}');
    widget.foto = foto['url'];
    print('${widget.foto}');

    return widget.foto;
  }
  @override
  void initState() {
    super.initState();
    _getpontosturisticos();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        leadingWidth: 75,
        centerTitle: true,
        elevation: 10,
        backgroundColor: Color(0xFF3BA995),
        leading: Image.asset('images/v.png'),
        title: Padding(
          padding: EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 10),
          child: Container(
              height: 40,
              width: 300,
              child: Material(
                borderRadius: BorderRadius.circular(13),
                elevation: 10.0,
                shadowColor: Colors.grey,
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon:
                    Icon(Icons.location_on, color: Color(0xFF419484)),
                    labelText: '${widget.cidade}',
                    fillColor: Color(0),
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(13))),
                  ),
                ),
              )),
        ),
        actions: <Widget>[
          IconButton(
              iconSize: 50,
              onPressed: () {
                _pickImage();
              },
              icon: FutureBuilder(
                future: _getuserimage(),
                builder: (context, snapshot) {
                  print(snapshot.data);
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: double.infinity,
                        height: 600,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.black),
                          strokeWidth: 5,
                        ),
                      );
                    default:
                      return Icon(Icons.add_a_photo_outlined, size: 35,);
                  }
                },
              ))
        ],
      ),
      body: SingleChildScrollView(
          child: FutureBuilder(
            future: _getpontosturisticos(),
            builder: (context, snapshot) {
              print(snapshot.data);
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Container(
                    width: double.infinity,
                    height: 600,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      strokeWidth: 5,
                    ),
                  );
                default:
                  var total2 = snapshot.data['fotos'].length;

                  var total3 = total2 / 2;
                  var total = snapshot.data['avaliacoes'].length;
                  return Column(
                    children: [
                      Container(
                          height: 350,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image:snapshot.data['fotos'].length > 0 ? NetworkImage('${snapshot.data['fotos'][0]['url']}') : AssetImage('images/v.jpg')
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF3BA995).withOpacity(0.7),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          icon: Icon(
                                            Icons.arrow_back_ios,
                                            color: Color(0xFF19574B),
                                            size: 30,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              Navigator.pop(context);
                                            });
                                          }),
                                      Spacer(),
                                      Flexible(
                                        child: Text(
                                          '${widget.nome}',
                                          overflow: TextOverflow.fade,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 20,
                                              color: Color(0xFFFFFFFF)),
                                        ),
                                      ),
                                      Spacer(),
                                      IconButton(
                                          icon: widget.fav
                                              ? Icon(
                                            Icons.bookmark_added,
                                            color: Color(0xFF19574B),
                                            size: 30,
                                          )
                                              : Icon(
                                            Icons.bookmark_border,
                                            color: Color(0xFF19574B),
                                            size: 30,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (widget.fav) {
                                                widget.fav = false;
                                              } else {
                                                widget.fav = true;
                                              }
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    child: Center(
                                      child: Text(
                                        '${snapshot.data['descricao']}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 15,
                                            color: Color(0xFFFFFFFF)),
                                      ),
                                    ))
                              ],
                            ),
                          )),
                      Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF3BA995),
                          ),
                          width: double.infinity,
                          height: 150,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(color: Color(
                                  0xFF00CDA5)),
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    child: Container(
                                        child: Column(
                                          children: [
                                            for (var i = 0; i < total; i++)
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 7, 0, 7),
                                                child: Row(
                                                  children: [
                                                    if (snapshot
                                                        .data['avaliacoes'][i]['fotoUsuario'] ==
                                                        null)
                                                      CircleAvatar(
                                                        backgroundImage:
                                                        AssetImage(
                                                            'images/v.png'),
                                                      ),
                                                    if (snapshot
                                                        .data['avaliacoes'][i]['fotoUsuario'] !=
                                                        null)
                                                      CircleAvatar(
                                                        backgroundImage:
                                                        NetworkImage('${snapshot
                                                            .data['avaliacoes'][i]['fotoUsuario']}'),
                                                      ),
                                                    Padding(
                                                        padding: EdgeInsets
                                                            .only(left: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            SizedBox(
                                                              width: 200,
                                                              child: Text(
                                                                '${snapshot
                                                                    .data['avaliacoes'][i]['comentario']}',
                                                                overflow: TextOverflow
                                                                    .fade,
                                                                textAlign: TextAlign
                                                                    .start,
                                                                style: TextStyle(
                                                                    fontFamily: 'Roboto',
                                                                    fontSize: 15,
                                                                    color:
                                                                    Color(
                                                                        0xFFFFFFFF)),
                                                              ),
                                                            ),
                                                            Text(
                                                              '${snapshot
                                                                  .data['avaliacoes'][i]['nomeUsuario']}',
                                                              textAlign: TextAlign
                                                                  .start,
                                                              style: TextStyle(
                                                                  fontFamily: 'Roboto',
                                                                  fontSize: 10,
                                                                  color: Color(
                                                                      0xFFFFFFFF)),
                                                            ),
                                                          ],
                                                        )),
                                                    Spacer(),
                                                    Padding(
                                                        padding: EdgeInsets
                                                            .only(right: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Text(
                                                              'Nota',
                                                              textAlign: TextAlign
                                                                  .start,
                                                              style: TextStyle(
                                                                  fontFamily: 'Roboto',
                                                                  fontSize: 15,
                                                                  color: Color(
                                                                      0xFFFFFFFF)),
                                                            ),
                                                            Text(
                                                              '${snapshot
                                                                  .data['avaliacoes'][i]['nota']}',
                                                              textAlign: TextAlign
                                                                  .start,
                                                              style: TextStyle(
                                                                  fontFamily: 'Roboto',
                                                                  fontSize: 10,
                                                                  color: Color(
                                                                      0xFFFFFFFF)),
                                                            ),
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                              )
                                          ],
                                        )),
                                  )),
                            ),
                          )),

                      for (var i = 0; i < total3; i++)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 185,
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                              child: Image.network('${snapshot
                                  .data['fotos'][i]['url']}',
                                height: 175,
                                fit: BoxFit.cover,),
                            ),

                            Container(
                              width: 185,
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                              child: Image.network('${snapshot.data['fotos'][i +
                                  1]['url']}',
                                height: 175,
                                fit: BoxFit.cover,),
                            )


                          ],
                        ),


                    ],
                  );
              }
            },
          )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          print(widget.placeid);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      addcoment(widget.token,
                          widget.descricao, widget.cidade, widget.estado)));
        },
        label: const Text('Add Comentário'),
        icon: const Icon(Icons.chat_bubble),
        backgroundColor: Color(0xFF00CDA5),
      ),
    );
  }
}
