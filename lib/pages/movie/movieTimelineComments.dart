

import 'package:flutter/material.dart';
import 'package:fluttert/commentCard.dart';
import 'package:fluttert/tools/textField.dart';

class MovieTimelineComments extends StatefulWidget {
  const MovieTimelineComments({super.key});

  @override
  State<MovieTimelineComments> createState() => _MovieTimelineCommentsState();
}

class _MovieTimelineCommentsState extends State<MovieTimelineComments> {
  double time = 70;
  Color movieTheme = Color.fromARGB(255, 255, 119, 0);
  late double mediaWidth = MediaQuery.of(context).size.width;
  TextStyle buttonText = TextStyle(
    color: Colors.white,
    fontFamily: 'Outfit',
    fontSize: 15
  );

  String? selectedItem = 'Top';
  List<String> items = ['Top', 'Trending', 'New'];


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal:10, vertical: 5),
              width: mediaWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '34:24',
                    style: TextStyle(
                      fontFamily: 'Oswald',
                      fontSize: 15,
                      color: movieTheme,
                      fontWeight: FontWeight.w100
                    ),
                    ),
                  SizedBox(width: 10,),
                  SizedBox(
                    width: mediaWidth - 100,
                    child: Text(
                    'Dr Lecter prevents Will from killing the Social Worker',
                    style: TextStyle(
                      fontFamily: 'oswald',
                      fontSize: 15,
                      color: Color.fromARGB(255, 216, 216, 216),
                      
                    ),
                    textAlign: TextAlign.justify,
            ),
                  ),
                ],
              ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: (){
                  
                }, 
                icon: Icon(Icons.arrow_back_ios)),
              Container(
                height: 70,
                width: 125,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://www.cinepremiere.com.mx/wp-content/uploads/2020/07/hannibal_4.jpg'),
                    fit: BoxFit.cover
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15))
                ),

              ),
              
              IconButton(
                onPressed: (){}, 
                icon: Icon(Icons.arrow_forward_ios)
                ),
            ],
          ),
          Slider(
            value: time,
            min: 0,
            max: 100,
            activeColor: movieTheme,
            onChanged: (time) => setState(() => this.time = time,)
          ),   
          

          Row(
            children: [
              ElevatedButton(
                onPressed: (){
                  
                }, 
                child: Text('Not accurate?', style: buttonText,),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 21, 21, 21),
                ),
              ),
          SizedBox(width: 10,),
          SizedBox(
            width: 100,
            child: DropdownButtonFormField<String>(
              dropdownColor: Color.fromARGB(255, 31, 31, 31),
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              value: selectedItem, 
              items: items.map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: buttonText,),
                )).toList(),
              onChanged: (item) => setState(() => selectedItem = item),
              ),
          ),
            ],
          ),

          Expanded(
            child: ListView(
              children:[
                // CommentCardWidget(),
                // CommentCardWidget(),
                // CommentCardWidget()
              ]
            )
            ),
          
          // TextFieldCustom()
          //Image(image: NetworkImage(''))
        ]
        ),
    );
  }
}