import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:fluttert/tools/heading.dart';

class MovieDetail extends StatefulWidget {
  const MovieDetail({super.key});

  @override
  State<MovieDetail> createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingWidget(heading: 'About'),
            SizedBox(height: 15,),
            aboutHead('Crew'),

            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  aboutDescMultiple('John Lasseter', 'Director'),

                ],
              ),
            ),


            SizedBox(height: 10,),
            aboutHead('Starring'),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  aboutDescMultiple('Owen Wilson', 'Lightning McQueen'),
                  aboutDescMultiple('Owen Wilson', 'Lightning McQueen'),
                  aboutDescMultiple('Owen Wilson', 'Lightning McQueen'),
                  aboutDescMultiple('Owen Wilson', 'Lightning McQueen'),
                  aboutDescMultiple('Owen Wilson', 'Lightning McQueen'),

                ],
              ),
            ),            
            SizedBox(height: 10,),
            aboutHead('Production companies'),
            aboutDesc('Pixar'),
            SizedBox(height: 10,),
            aboutHead('Distributed by'),
            aboutDesc('Disney'),
            SizedBox(height: 10,),
            aboutHead('Release date'),
            aboutDesc('May 26 2006'),
            SizedBox(height: 10,),
            aboutHead('Country'),
            aboutDesc('USA'),
            SizedBox(height: 10,),
            aboutHead('Budget'),
            aboutDesc('\$120 million'),
            SizedBox(height: 10,),
            aboutHead('Box office'),
            aboutDesc('\$462 million'),
            SizedBox(height: 10,),


          ],
        )
      ),
    );
  }
  
  Widget aboutHead(String text){
    return Text(
      text,
      style: TextStyle(
        // color: Colors.grey,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins'
      ),
      );
  }

  Widget aboutDesc(String text){
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).iconTheme.color!, 
          width: 2
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // scrollDirection: Axis.horizontal,
          children: [
            Text(
            text,
            style: TextStyle(
              fontSize: 20,
              // color: Colors.grey,
              fontWeight: FontWeight.normal,
              fontFamily: 'Poppins'
              ),
            ),
            
          ]
        ),
      ),
    );
  }
  Widget aboutDescMultiple(String text, String text2){
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).iconTheme.color!, 
          width: 2
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // scrollDirection: Axis.horizontal,
          children: [
            Text(
            text,
            style: TextStyle(
              fontSize: 20,
              // color: Colors.grey,
              fontWeight: FontWeight.normal,
              fontFamily: 'Poppins'
              ),
            ),
            Text(
            text2,
            style: TextStyle(
              fontSize: 12,
              color: Color.fromARGB(255, 106, 106, 106),
              fontWeight: FontWeight.normal,
              fontFamily: 'Poppins'
              ),
            ),
            
            
          ]
        ),
      ),
    );
  }

}