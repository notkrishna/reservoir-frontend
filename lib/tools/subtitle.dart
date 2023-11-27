import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';


class SubtitleWidget extends StatefulWidget {
  final String text;
  final double size;
  const SubtitleWidget({super.key, required this.text, this.size = 18});

  @override
  State<SubtitleWidget> createState() => _SubtitleWidgetState();
}

class _SubtitleWidgetState extends State<SubtitleWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: 
      // Wrap(
      //             crossAxisAlignment: WrapCrossAlignment.center,
      //             children: [
      //               Icon(Icons.local_fire_department),
                    Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: widget.size,
                      fontFamily: 'Lexend',
                      color: Colors.grey
                      ),
                    ),
                //     Icon(Icons.keyboard_arrow_down),

                //   ],
                // ),
    );
  }
}


