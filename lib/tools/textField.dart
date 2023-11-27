import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class TextFieldCustom extends StatefulWidget {
  final TextEditingController controller;
  const TextFieldCustom({super.key, required this.controller});

  @override
  State<TextFieldCustom> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {
  double time = 70;
  Color movieTheme = Color.fromARGB(255, 255, 119, 0);
  late double mediaWidth = MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    return Container(
            decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      //color:Color.fromARGB(255, 21, 21, 21),
                      // gradient: LinearGradient(
                        
                      //   colors: [
                      //     Color.fromARGB(255, 21, 21, 21),                          
                      //     Colors.black,
                      //     Color.fromARGB(255, 21, 21, 21),
                      //     Color.fromARGB(255, 21, 21, 21),                          
                      //     ] 
                      //   ),
                    
                    ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                
                Flexible(
                  child: TextField(
                    controller: widget.controller,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      filled: true,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.emoji_emotions), 
                        onPressed: (){},
                        //color: Color.fromARGB(255, 212, 212, 212),
                        splashColor: Colors.transparent,
                        ),
                      //fillColor: Color.fromARGB(255, 21, 21, 21),
                      hintText: 'Comment ...',
                      hintStyle: TextStyle(fontFamily: 'Outfit',color: Color.fromARGB(255, 212, 212, 212)),
                      
                      border: InputBorder.none
                    ),
                  ),
                ),
                IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.send),
                  //color: Color.fromARGB(255, 207, 207, 207),
                  iconSize: 25,
                  splashColor: Colors.transparent,

                  )
              ],
            ),
          );
  }
}