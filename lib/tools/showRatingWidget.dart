import 'package:flutter/material.dart';

class ShowRatingWidget extends StatefulWidget {
  final int maxRating;
  final int rating;
  final Color color;
  final double size;

  ShowRatingWidget({
    this.maxRating = 5,
    this.rating = 0,
    this.color = Colors.amber,
    this.size = 20.0,
  });
  

  @override
  _ShowRatingWidgetState createState() => _ShowRatingWidgetState();
}

class _ShowRatingWidgetState extends State<ShowRatingWidget> {
  int _currRating = 5;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(widget.maxRating, (index) {
        return Icon(
            // Show filled star if index is less than rating
            index < widget.rating.floor()
                ? Icons.star
                : Icons.star_border,
            color: widget.color,
            size: widget.size,
          );
        
      }),
    );
  }
}

// class RatingWidget extends StatefulWidget {
//   @override
//   _RatingWidgetState createState() => _RatingWidgetState();
// }

// class _RatingWidgetState extends State<RatingWidget> {
//   double _rating = 0;
  
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: List.generate(5, (index) {
//         return IconButton(
//           icon: Icon(
//             index < _rating ? Icons.star : Icons.star_border,
//             color: Colors.amber,
//           ),
//           onPressed: () {
//             setState(() {
//               _rating = index + 1;
//             });
//           },
//         );
//       }),
//     );
//   }
// }
