import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final double x;
  final double y;
  const Loading({super.key, this.x = 0.5, this.y = 0.3});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
          scaleY: x,
          scaleX: y,
          child: LinearProgressIndicator(
            color: Theme.of(context).iconTheme.color,
          )
        );
  }
}