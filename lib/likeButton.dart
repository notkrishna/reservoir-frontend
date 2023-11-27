import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class LikeButtonWidget extends StatefulWidget {
  @override
  _LikeButtonWidgetState createState() => _LikeButtonWidgetState();
}
class _LikeButtonWidgetState extends State<LikeButtonWidget> {
  bool isLiked = false;
  int likeCount = 2033;

  @override
  Widget build(BuildContext context) {
    final double size = 16;
    
    return LikeButton(
      isLiked: isLiked,
      size: size,
      likeCount: likeCount,
      likeBuilder: (isLiked) {
        final color = isLiked ? Color.fromARGB(255, 255, 0, 115): Colors.white;
        return Icon(
          isLiked ? Icons.favorite: Icons.favorite_outline, 
          color: Colors.red, 
          size: size,);
    
      },
      likeCountPadding: EdgeInsets.only(left: 7),
      countBuilder: (count, isLiked, text) {
        final color = Color.fromARGB(255, 0, 0, 0);
        return Text(
          text,
          style: TextStyle(
            //color: color,
            fontFamily: 'Outfit', 
            fontSize: 14,
            
          ),
        );
      },
      onTap: (isLiked) async {
        this.isLiked = !isLiked;
        likeCount += this.isLiked ? 1 : -1;
        return !isLiked;
      },
      );
      
    
  }
}