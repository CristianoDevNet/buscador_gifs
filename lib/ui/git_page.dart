import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class GitPage extends StatelessWidget {
  final Map _gitData;

  GitPage(this._gitData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_gitData["title"]),
          backgroundColor: Colors.black,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () async {
                var request = await HttpClient().getUrl(
                    Uri.parse(_gitData["images"]["fixed_height"]["url"]));
                var response = await request.close();

                
                Uint8List bytes =
                    await consolidateHttpClientResponseBytes(response);
                await Share.file('ESYS AMLOG', 'amlog.gif', bytes, 'image/gif');
              },
            )
          ],
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: CachedNetworkImage(
            imageUrl: _gitData["images"]["fixed_height"]["url"],
          ),
        ));
  }
}
