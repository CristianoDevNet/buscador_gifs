import 'dart:convert';
import 'dart:math';
import 'package:buscador_gifs/ui/git_page.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
//import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

String _search;

class _HomePageState extends State<HomePage> {
  int _offset = 0;

  Future<Map> _getGif() async {
    http.Response response;

    if (_search == null || _search.trim().isEmpty) {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=vSrByLCQJKwIKTHCExLcIAfN0O9lNz4B&limit=20&rating=G");
    } else {
      _offset = new Random().nextInt(1000);

      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=vSrByLCQJKwIKTHCExLcIAfN0O9lNz4B&q=$_search&limit=19&offset=$_offset&rating=G&lang=en");
    }

    return json.decode(response.body);
  }

  // @override
  // void initState() {
  //   super.initState();

  //   _getGif().then((map) {
  //     print(map);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          title: Image.network(
              "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
          centerTitle: true),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquise Aqui",
                  labelStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.start,
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGif(),
              builder: (conext, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container();
                    // Container(
                    //     alignment: Alignment.center,
                    //     child: CircularProgressIndicator(
                    //       valueColor:
                    //           AlwaysStoppedAnimation<Color>(Colors.white),
                    //       strokeWidth: 1,
                    //     ));
                    break;
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _createGifTable(context, snapshot);
                    break;
                }
              },
            ),
          )
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return RefreshIndicator(
      child: GridView.builder(
          padding: EdgeInsets.all(2),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 1, mainAxisSpacing: 1),
          itemCount:
              _getCount(snapshot.data["data"]), //snapshot.data["data"].length,
          itemBuilder: (context, index) {
            if (_search == null || index < snapshot.data["data"].length) {
              return GestureDetector(
                child:

                    //     FadeInImage.memoryNetwork(
                    //       height: 200,
                    //   placeholder: MemoryImage(bytes),
                    //   image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],

                    // )
                    CachedNetworkImage(
                  imageUrl: snapshot.data["data"][index]["images"]
                      ["fixed_height"]["url"],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white30),
                        strokeWidth: 1,
                      )),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      // context,
                      MaterialPageRoute(
                          builder: (context) =>
                              GitPage(snapshot.data["data"][index]),
                          fullscreenDialog: false));
                },

                // Image.network(

                //   snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                //   height: 300,
                //   fit: BoxFit.cover,
                // ),
              );
            } else {
              return Container(
                child: GestureDetector(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white30,
                        size: 70,
                      )
                    ],
                  ),
                  onTap: () {
                    setState(() {});
                  },
                ),
              );
            }
          }),
      onRefresh: (() {
        setState(() {});
      }),
    );
  }
}
