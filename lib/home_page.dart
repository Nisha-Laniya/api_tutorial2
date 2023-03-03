import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Photos> photoList = [];

  Future<List<Photos>> getPhotos() async {
    final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/photos"));
    var data = jsonDecode(response.body.toString());
    if(response.statusCode == 200) {
        for(Map i in data) {
          Photos photos = Photos(title: i['title'], url: i['url'], id: i['id']);
          photoList.add(photos);
        }
        return photoList;
    } else {
      return photoList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Integration'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
                future: getPhotos(),
                  builder: (context,AsyncSnapshot<List<Photos>> snapshot) {
                    if(!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(color: Colors.red,),
                      );
                    }
                    else {
                      return ListView.builder(
                          itemCount: photoList.length,
                          itemBuilder: (context,index) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(snapshot.data![index].url),
                              ),
                              title: Text(snapshot.data![index].id.toString()),
                              subtitle: Text(snapshot.data![index].title),
                            );
                          }
                      );
                    }
                  }
              ))
        ],
      ),
    );
  }
}

class Photos {

  String title, url;
  int id;

  Photos({
    required this.title,
    required this.url,
    required this.id
  });

}