import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:httpexpo/models/Gif.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<Gif>> _listadoGifs;

  Future<List<Gif>> _getGifs() async {
    final response = await http.get(
        "https://api.giphy.com/v1/gifs/trending?api_key=S2a9zt1K87kBuM1hVqvFX0oOeMN7QYiZ&limit=10&offset=0&rating=g&bundle=messaging_non_clips");

    if (response.statusCode == 200) {

      String body = utf8.decode(response.bodyBytes);

      final jsonData = jsonDecode(body);

      List<Gif> gifs = [];

      for (var item in json Data["data"]) {
        gifs.add(
          Gif(item["title"], item["images"]["fixed_height"]["url"]));
      }
      return gifs;

    } else {
      throw Exception("Falló la conexión");
    }
  }

  @override
  void initState() {
    super.initState();
    _listadoGifs = _getGifs(); // Asignar el resultado de _getGifs() a _listadoGifs
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: "http",
      home: Scaffold(
        appBar: AppBar(
          title: Text("HTTP"),
        ),
        body:FutureBuilder(future: _listadoGifs, builder: (context , snapshot){
          if (snapshot.hasData){
            return ListView(
              children: _ListGifs(snapshot.data),
            );
          }else if (snapshot.hasError){
            print(snapshot.error);
            return Text("ERROR");
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        
        )
      ),
    );
  }

List<Widget> _listGifs(List<Gif> data){
  List<Widget> gifs = [];

for (var gif in data) {
  gifs.add(
    Card(child: Column(
      children: [
        Image.network(gif.url),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(gif.name),
        ),
      ],
    ))
  );
}
return gifs;

}


}
