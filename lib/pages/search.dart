import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/models/movieModel.dart';
import 'package:fluttert/pages/movie/movieCard.dart';
import 'package:fluttert/pages/searchResult.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final fieldText = TextEditingController();
  void clearText(){
    fieldText.clear();
    fieldText.dispose();
    super.dispose();
  }
  final numbers = List.generate(12, (index) => '$index');

  @override
  Widget build(BuildContext context) => Scaffold(
    extendBodyBehindAppBar: false,
    //backgroundColor: Color.fromARGB(255, 0, 0, 0),
    body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            readOnly: true,
            onTap:() {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => SearchResultPage(),
                  transitionDuration: Duration(seconds: 0),
                  transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
                ),
              );
            },
            style: TextStyle(
              //color: Colors.white,
              fontFamily: 'Outfit',
              fontSize: 20,
            ),
            decoration: InputDecoration(
              //fillColor: Color.fromARGB(255, 35, 35, 35),
              border: InputBorder.none,
              prefixIcon: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                }, 
                icon: const Icon(Icons.arrow_back_ios),
                //color: Colors.white,
                ),
              // suffixIcon: IconButton(
              //   onPressed: clearText,
              //   icon: const Icon(Icons.cancel),
              //   //color: Color.fromARGB(255, 112, 112, 112),
              //   ),
              filled: true,
              //fillColor: Color.fromARGB(255, 25, 25, 25),
              hintStyle: TextStyle(
                color: Colors.grey, 
                fontFamily: 'Outfit', 
                fontSize: 25
                ),
              hintText: 'Search movies, shows, lists',
          ),
          controller: fieldText,
          ),
          SizedBox(height: 2,),
          // Flexible(
          // //   child: FutureBuilder(

          // //   ),
          //   child: GridView.builder(
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 3,
          //       mainAxisSpacing: 2,
          //       mainAxisExtent: 200,
          //       crossAxisSpacing: 2
          //     ),
          //     itemCount: numbers.length,
          //     itemBuilder: (context, index) {
          //       return buildNumber(numbers[index]);
          //     },
          //   ),
          // ),
        ]
        ),
    ),

  );
  Widget buildNumber(String number) => Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: NetworkImage('https://lumiere-a.akamaihd.net/v1/images/revenant_584x800_6d98d1b6.jpeg'),
        fit: BoxFit.cover
      )
    ),
    //width: MediaQuery.of(context).size.width/3 - 6,
    // child: Ink.image(
    //     image: NetworkImage('https://m.media-amazon.com/images/I/91nG1qkExWL._SY741_.jpg')
    //   ),
  );
}




