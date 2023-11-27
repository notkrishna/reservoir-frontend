import 'package:flutter/material.dart';
import 'dart:ui';

class ExpandableText extends StatefulWidget {
  final String text;
  final int limit;
  final Color textColor;
  const ExpandableText({
    Key? key, 
    required this.text, 
    required this.limit, 
    required this.textColor
    }): super(key: key);
  @override
  _ExpandableTextState createState() => _ExpandableTextState();

}
class _ExpandableTextState extends State<ExpandableText> {
  late String firstText;
  late String secondText;
  bool flag = true;
  
  
  @override
  void initState(){
    super.initState();
    if(widget.text.length>widget.limit){
      firstText = widget.text.substring(0,widget.limit);
      secondText = widget.text.substring(widget.limit+1,widget.text.length);
    } else {
      firstText = widget.text;
      secondText = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    Color? textColor = Theme.of(context).iconTheme.color;
    return Container(
      child: secondText.isEmpty?Text(
        widget.text,
        style: TextStyle(
          color: widget.textColor, 
          fontFamily: 'Outfit', 
          fontSize: 14
          ),
        textAlign: TextAlign.justify,
        ):Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              flag ? firstText + ' ...' : widget.text,
              style: TextStyle(
                color: widget.textColor,
                fontFamily: 'Lexend', 
                fontSize: 14,
                ),
              textAlign: TextAlign.justify,

             ),
            InkWell(
              onTap: (){
                setState(() {
                  flag = !flag;
                });
              }, 
              child: Text(
                flag ? 'show more' : 'show less',
                style: TextStyle(
                  color: Color.fromARGB(255, 102, 102, 102), 
                  fontFamily: 'Outfit', 
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                  ),

                )
            ),
          ]
        )
        // Column(
        //   children: [
        //     Text(firstText),
        //     ElevatedButton(onPressed: (){}, child: Text('Show More')),
        //     ]
        // ),
    );
  }
}