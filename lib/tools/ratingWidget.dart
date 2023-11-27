import 'package:flutter/material.dart';

class RatingWidget extends StatefulWidget {
  final int maxRating;
  final int rating;
  final Color color;
  final double size;
  final Function(int)? onRatingChanged;

  RatingWidget({
    this.maxRating = 5,
    this.rating = 0,
    this.color = Colors.white,
    this.size = 22.0,
    required this.onRatingChanged,
  });
  

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  int _currRating = 0;
  @override
  void initState() {
    super.initState();
    _currRating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
  
    return Row(
      // mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(widget.maxRating, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              // Update rating when user taps on a star
              _currRating = index + 1;
            });
            widget.onRatingChanged?.call(_currRating);
          },
          child: Icon(
            // Show filled star if index is less than rating
            index < _currRating.floor()
                ? Icons.star
                : Icons.star_border,
            color: Theme.of(context).iconTheme.color,
            size: widget.size,
          ),
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
