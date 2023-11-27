import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';


class HeadingWidget extends StatefulWidget {
  final String heading;
  final double size;
  const HeadingWidget({super.key, required this.heading, this.size = 30});

  @override
  State<HeadingWidget> createState() => _HeadingWidgetState();
}

class _HeadingWidgetState extends State<HeadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: 
      // Wrap(
      //             crossAxisAlignment: WrapCrossAlignment.center,
      //             children: [
      //               Icon(Icons.local_fire_department),
                    Text(
                    widget.heading,
                    style: TextStyle(
                      fontSize: widget.size,
                      fontFamily: 'Poppins',
                      ),
                    ),
                //     Icon(Icons.keyboard_arrow_down),

                //   ],
                // ),
    );
  }
}


