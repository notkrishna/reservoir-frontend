import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class TrendingHeader extends StatefulWidget {
  final String text;
  const TrendingHeader({super.key, required this.text});

  @override
  State<TrendingHeader> createState() => _TrendingHeaderState();
}

class _TrendingHeaderState extends State<TrendingHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 26,
          child: Text(
                  widget.text,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 17,
                    //fontWeight: FontWeight.bold,
                    //color: Color.fromARGB(255, 239, 239, 239)
                  ),
                  textAlign: TextAlign.left,
                ),
        ),
        // Text(
        //         'GLOBAL',
        //         style: TextStyle(
        //           fontFamily: 'Poppins',
        //           fontSize: 14,
        //           //fontWeight: FontWeight.bold,
        //           color: Color.fromARGB(255, 209, 209, 209)
        //         ),
        //         textAlign: TextAlign.left,
        //       ),
      ]
    );
  }
}