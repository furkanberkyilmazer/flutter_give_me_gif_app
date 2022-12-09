import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'loading_widget.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

//https://g.tenor.com/v1/search?q=excited&key=LIVDSRZULELA&limit=8
class _HomePageState extends State<HomePage> {
  String searchWord = "Türkiye";
  List<String> gifs = [];
  var gifData;
  TextEditingController _controller = TextEditingController();

  Future<void> getGifDataFromAPI() async {
    gifData = await http.get(Uri.parse(
        'https://g.tenor.com/v1/search?q=$searchWord&key=LIVDSRZULELA&limit=8'));
    final gifDataParsed = jsonDecode(gifData.body);
    //print(gifDataParsed['results'][0]['media'][0]['tinygif']['url']);
    gifs.clear();
    setState(() {
      for (int i = 0; i < 8; i++) {
        gifs.add(gifDataParsed['results'][i]['media'][0]['tinygif']['url']);
        print(gifDataParsed['results'][i]['media'][0]['tinygif']['url']);
      }
    });
  }

  void getInitialData() async {
    await getGifDataFromAPI();

  }

  @override
  void initState() {
    getInitialData(); //init state de asyn olmadığı için yukarda bir üst fonk yazdık.
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        child:
        (gifs.isEmpty)
            ? const LoadingWidget()
            :Scaffold(
        appBar: AppBar(
          title: Text('Give me gif!!!'),
        ),
        body:SingleChildScrollView( //bu olmazsa klavye açıldığında ekran taşma olur.
          child:Center(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: TextField(
                  onChanged: (value) {
                    searchWord = value;
                  },
                  controller: _controller,
                  decoration: InputDecoration(
                      hintText: 'Aramak istediğin kelimeyi gir',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0))),
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                onPressed: ()  {

                  getGifDataFromAPI();




                },
                style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
                child: Text("Gif Getir"),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,

                child:
                (gifs.isEmpty==true)?LoadingWidget():
                ListView.separated(
                  itemCount: 8,
                  itemBuilder: (_, int index) {
                    return GifCard(gifs[index]);
                  },
                  separatorBuilder: (_, __) {
                    return Divider(
                      color: Colors.blueGrey,
                      thickness: 5,
                      height: 5,
                    );
                  },
                ),
              ),

            ],
          ),
        ),
        ),
      ),
    );
  }
}
class GifCard extends StatelessWidget {
  final String gifUrl;

  GifCard(this.gifUrl);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image(
        fit: BoxFit.cover,
        image: NetworkImage(gifUrl),
      ),
    );
  }
}
