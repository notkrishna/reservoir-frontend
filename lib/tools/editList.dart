import 'package:flutter/material.dart';
import 'package:fluttert/diary/MovieListDialogueEdit.dart';
import 'package:provider/provider.dart';

import '../providers/movieListProvider.dart';

class EditList extends StatelessWidget {
  final BuildContext cxt;
  final String id;
  final String lName;
  const EditList({
    super.key,
    required this.id,
    required this.cxt,
    required this.lName,
    });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: (){
          showDialog(
            context: context, 
            builder: (context) => ChangeNotifierProvider(
              create: (context) => MovieListProvider(),
                builder: (context, child) {
                  return MovieListDialogueBoxEdit(
                    id:id,
                    lname: lName,
                    cxt: cxt,
                    );
                }
              
            )
            );
        }, 
        child: Icon(Icons.edit, size: 18,)
      );
  }
}