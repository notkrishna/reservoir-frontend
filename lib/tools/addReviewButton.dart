import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

import '../reviewDialogueBox.dart';
import '../reviewDialogueBoxEdit.dart';

class AddReviewButton extends StatelessWidget {
  // final int id;
  final String movie;
  final bool isRated;
  final BuildContext cxt;
  const AddReviewButton({
    super.key,
    // required this.id,
    required this.movie,
    required this.isRated,
    required this.cxt
    });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        backgroundColor: Color.fromARGB(255, 255, 0, 0),
        onPressed: () {
          isRated == false ?
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => ReviewDialogueBox(movie: movie, cxt:cxt))
          ):
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => ReviewDialogueBoxEdit(
              // id: movie,
              movie: movie,
              cxt:cxt,
              pway: 'movie',
              )) 
          );
        },
        icon: Icon(isRated==false?Icons.reviews:Icons.edit),
        label: Text(isRated==false?'Rate or Review':'Edit Review',),
        );
  }
}