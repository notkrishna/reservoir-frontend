import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/api/movieAPI.dart';
import 'package:fluttert/likeButton.dart';
import 'package:fluttert/models/movieModel.dart';
import 'package:fluttert/pages/movie/moviePage.dart';
import 'package:fluttert/tools/loading.dart';

class MovieCard extends StatefulWidget {
  final String id;
  final double height;
  final String coverImgUrl;
  final String movieName;
  const MovieCard({
    Key? key, 
    required this.id, 
    required this.height, 
    this.coverImgUrl = "",
    required this.movieName
    }): super(key: key);

  @override
  _MovieCardState createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  @override
  Widget build(BuildContext context) {
        return GestureDetector(
          onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MoviePage(
              id: widget.id,
            )
          )
        );
      },
          child: Card(
            color: Colors.black,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
            child: Stack(
              alignment: Alignment.center,
              
              children: [
                widget.coverImgUrl!=""?
                Ink.image(
                  height: widget.height,
                  width: 500,
                  image: NetworkImage(widget.coverImgUrl),
                  // colorFilter: ColorFilter.mode(
                  // Color.fromARGB(255, 0, 0, 0).withOpacity(0.7), 
                  // BlendMode.dstATop
                  // ),
                  fit: BoxFit.cover,
                  
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0,sigmaY: 20),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => MoviePage(id: widget.id,)),
                            );
                      },
                    ),
                  ),
                  
                  ):
                  Container(),
                  Positioned(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: 400,
                      child: Text(
                      widget.movieName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        fontSize: 30,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )),
              ]
              ),
          ),
        );
  }

  Widget loadingContainer() {
    bool themeCond= Theme.of(context).scaffoldBackgroundColor==Colors.black;
    Color clr = themeCond?Color.fromARGB(255, 33, 33, 33):Color.fromARGB(255, 232, 232, 232);
    return Container(
      padding: EdgeInsets.all(8.0),
      // height: 50,
      color: clr,
    );
  }
}