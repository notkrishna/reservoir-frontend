import 'package:flutter/material.dart';
import 'package:fluttert/diary/dialoguebox.dart';
import 'package:fluttert/providers/progressDetailProvider.dart';
import 'package:provider/provider.dart';

class AddProgressStamp extends StatelessWidget {
  final String id;
  final String movie;
  final BuildContext cxt;
  final pway;
  const AddProgressStamp({
    super.key,
    required this.id,
    required this.movie,
    required this.cxt,
    required this.pway
    });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Color.fromARGB(255, 41, 41, 41),
      label: Text('Timestamp'),
      icon: Icon(Icons.add),
      onPressed: (){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context){
            return ChangeNotifierProvider(
              create: (context) => ProgressDetailProvider(),
              child: DialogueBox(
                movie: movie,
                cxt: cxt, 
                pway: pway
                ),
            );
          }
        )
      );
      }
    );
  }
}

