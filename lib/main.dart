import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterapi2024/models/Gif.dart';
import 'package:http/http.dart' as http; // emcapsula en http

void main() => runApp(MyApp()); // llama al primer widget que se ejecutará

/*
void main() {
    runApp(MyApp);
}*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // es el estilo de la app
      title: "Primera App", // nombre de la app
      home: Inicio(),
    );
  }
}

class Inicio extends StatefulWidget {
  Inicio({super.key});

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  Future<List<Gif>?> _listadoGifts = Future.value(); // esperar a resolver

  Future<List<Gif>> _getGifs() async {
    String urlString = "https://api.giphy.com/v1/gifs/trending?api_key=R5tiq34dauKCuNCzU0HN5j9KXH31432D&limit=25&offset=0&rating=g&bundle=messaging_non_clips";
    Uri uri = Uri.parse(urlString);

    final response = await http.get(uri);
    List<Gif> gifs = [];
    if (response.statusCode == 200) {
      // correcto
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var item in jsonData["data"]) {
        gifs.add(Gif(item["title"], item["images"]["original"]["url"]));
      }
      return gifs;
    } else {
      throw Exception("Error");
    }
  }

  @override
  void initState() {
    super.initState();
    _listadoGifts = _getGifs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // estructura básica de una app
      // estructura de una app movil
      appBar: AppBar(
        title: Text("Primera App Title"),
      ),
      body: Center(
          child: FutureBuilder(
        future: _listadoGifts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(children: _listGifs(snapshot.data),);
          } else if (snapshot.hasError) {
            print(snapshot.error);

            return Text("error");
          }

          return Text("data2");
        },
      )),
    );
  }

  List<Widget> _listGifs(data) {
    List<Widget> gifs = [];
    for (var gif in data) {
      gifs.add(
          Image.network(
            gif.url, //  URL de  imagen
            width: 200.0, // Ancho de la imagen
            height: 200.0, // Altura de la imagen
            fit: BoxFit.contain, // Ajuste de la imagen dentro del contenedor
          )
      );
    }
    return gifs;
  }
}
