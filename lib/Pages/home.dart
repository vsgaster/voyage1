import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter

import 'dart:io';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:voyage1/Pages/location_api.dart';
import 'package:voyage1/Pages/placepage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:voyage1/Pages/test.dart';
import 'package:voyage1/Pages/uparimagem_api.dart';

void main() {}

class HomeP extends StatefulWidget {
  String cidade;
  String estado;
  String token;
  String foto;

  HomeP(this.token, this.cidade, this.estado);

  @override
  _HomePState createState() => _HomePState();
}

class _HomePState extends State<HomeP> {
  TextEditingController buscaController = TextEditingController();
  File tmpfile;
  var _image;
  final picker = ImagePicker();
  var photo = '';
  var _busca = null;

  Future<dynamic> getlocation() async {
    var response2 = await LocationApi.getlocationPermission();

    widget.cidade = response2['cidade'];
    widget.estado = response2['estado'];
    if(_busca == null)
      buscaController.text = widget.cidade;

    print(widget.cidade);
    print(widget.estado);

    return response2;
  }

  Future<dynamic> _pickImage() async {
    imageCache.clear();
    imageCache.clearLiveImages();
    File selected = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      photo = '';
      _image = selected;
      print(selected);
    });
    http.Response response = await UploadApi.upload(_image, widget.token);
    print(response.body);
    photo = response.body;
    setState(() {
      photo = response.body;
      print(photo);
    });
  }

  Future<dynamic> _getpontosturisticos() async {
    http.Response response;
    if (_busca ==  null){
      var url = 'http://voyage-api-2021.azurewebsites.net/api/pontos-turisticos/por-cidade?cidade=${widget.cidade}';
      var header = {"Authorization": "bearer ${widget.token}"};
      response = await http.get(url, headers: header);
      if (response.body == ''){
        url = 'http://voyage-api-2021.azurewebsites.net/api/pontos-turisticos/';
        response = await http.get(url, headers: header);
        var resposta = json.decode(response.body);
        return resposta;
      }
      var resposta = json.decode(response.body);
      _getuserimage();
      return resposta;
    }else{
      var url = 'http://voyage-api-2021.azurewebsites.net/api/pontos-turisticos/por-cidade?cidade=${_busca}';
      var header = {"Authorization": "bearer ${widget.token}"};
      response = await http.get(url, headers: header);
      if (response.body == ''){
        url = 'http://voyage-api-2021.azurewebsites.net/api/pontos-turisticos/';
        response = await http.get(url, headers: header);
        var resposta = json.decode(response.body);
        return resposta;
      }
      var resposta = json.decode(response.body);
      return resposta;
    }

  }

  Future<dynamic> _getuserimage() async {
    imageCache.clear();
    imageCache.clearLiveImages();


    http.Response response2;

    var url2 = 'http://voyage-api-2021.azurewebsites.net/api/usuarios/foto';
    var header = {"Authorization": "bearer ${widget.token}"};
    response2 = await http.get(url2, headers: header);

    var foto = json.decode(response2.body);
    print(foto);

    photo = foto['url'];
    getlocation();
    return photo;
  }

  @override
  void initState() {
    super.initState();
    _getpontosturisticos();
  }

  List<bool> _fav = [false, false, false, false, false,false, false, false, false, false];

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
                  child: FutureBuilder(
                    future: getlocation(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return TextField(
                            onSubmitted: (text){
                              setState(() {
                                _busca = text;
                                buscaController.text = _busca;
                              });
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.location_on,
                                  color: Color(0xFF419484)),
                              labelText: 'Busca',
                              fillColor: Color(0),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(13))),
                            ),
                          );
                        default:
                          return TextField(
                            onSubmitted: (text){
                              setState(() {
                                _busca = text;
                                buscaController.text = _busca;
                              });
                            },
                            controller: buscaController,

                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.location_on,
                                  color: Color(0xFF419484)),
                              labelText: 'Busca',
                              fillColor: Color(0),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(13))),
                            ),
                          );
                      }
                    },
                  ))),
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
                      if(snapshot.data == ""){
                        return Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                    new AssetImage("images/v.jpg"))));}
                      else
                        return Container(
                            height: 43,
                            width: 43,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                    new NetworkImage("${snapshot.data}"))));
                  }
                },
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _getpontosturisticos(),
          builder: (context, snapshot) {
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
                List imagens;
                var total = snapshot.data.length;
                if (snapshot.hasError)
                  return Container(
                      width: double.infinity,
                      height: 600,
                      alignment: Alignment.center,
                      child: Text('Sem Conexão'));
                else{
                  print(total);
                  return Container(
                    color: Color(0xFFFFFFFF),
                    child: Column(
                      children: [
                        for (var i = 0; i < total; i++)

                          Padding(
                              padding: EdgeInsets.fromLTRB(1, 5, 1, 5),
                              child: Container(
                                  height: 300,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: snapshot.data[i]['fotos'].length > 0 ? NetworkImage('${snapshot.data[i]['fotos'][0]['url']}') : AssetImage('images/v.jpg')
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        String estado = widget.estado;
                                        String cidade = widget.cidade;
                                        String token = widget.token;
                                        String imageurl = 'oi';
                                        String nome = snapshot.data[i]['nome'];
                                        String id = snapshot.data[i]['id'];
                                        bool fav = _fav[i];

                                        print(id);

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => PlacePage(
                                                    imageurl,
                                                    nome,
                                                    fav,
                                                    id,
                                                    token,
                                                    cidade,
                                                    estado)));
                                      });
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                                icon: _fav[i]
                                                    ? Icon(Icons.bookmark_added,
                                                        color:
                                                            Color(0xFF19574B))
                                                    : Icon(
                                                        Icons.bookmark_border,
                                                        color:
                                                            Color(0xFF19574B),
                                                      ),
                                                onPressed: () {
                                                  setState(() {
                                                    if (_fav[i]) {
                                                      _fav[i] = false;
                                                    } else {
                                                      _fav[i] = true;
                                                    }
                                                  });
                                                })
                                          ],
                                        ),
                                        Spacer(),
                                        Container(
                                            width: double.infinity,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0),
                                            ),
                                            child: ClipRect(
                                              child: BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                      sigmaY: 4, sigmaX: 4),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    8, 3, 0, 0),
                                                            child: Text(
                                                              '${snapshot.data[i]['nome']}',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 15,
                                                                  color: Color(
                                                                      0xFFFFFFFF)),
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    0, 3, 8, 0),
                                                            child: Text(
                                                              '${snapshot.data[i]['visitantes']} Visitantes',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 15,
                                                                  color: Color(
                                                                      0xFFFFFFFF)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    8, 0, 0, 3),
                                                            child: Text(
                                                              '${snapshot.data[i]['cidade']}-RJ',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 15,
                                                                  color: Color(
                                                                      0xFFFFFFFF)),
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          Padding(
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    0, 0, 8, 3),
                                                            child: Text(
                                                              '${snapshot.data[i]['avaliacoes'].length} Comentários',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Roboto',
                                                                  fontSize: 15,
                                                                  color: Color(
                                                                      0xFFFFFFFF)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )),
                                            ))
                                      ],
                                    ),
                                  ))),
                      ],
                    ),
                  );}
            }
          },
        ),
      ),
    );
  }
}
