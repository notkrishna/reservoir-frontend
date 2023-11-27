import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/likeButton.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/pages/movie/moviePage.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class MoviePageImg extends StatefulWidget {
  final String imgUrl;
  final String title;
  final String id;
  final bool userHasCover;
  const MoviePageImg({
    Key? key, 
    required this.imgUrl, 
    required this.title,
    required this.id,
    required this.userHasCover,
    }): super(key: key);

  @override
  _MoviePageImgState createState() => _MoviePageImgState();
}

class _MoviePageImgState extends State<MoviePageImg> {
  File? _coverImg;
  final picker = ImagePicker();
  // @override
  // Future<void> _pickImage(String fileN) async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null && mounted) {
  //     final compressedFile = await selectAndCropImage(File(pickedFile.path));
  //     setState(() {
  //       _coverImg = compressedFile;
  //     });
  //     final appDir = await getApplicationDocumentsDirectory();
  //     final nomediaFile = File('${appDir.path}/.nomedia');
  //     if (!await nomediaFile.exists()) {
  //       await nomediaFile.create();
  //     }
  //     final fileName = '$fileN.jpg';
  //     final savedImage = await _coverImg!.copy('${appDir.path}/$fileName');
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('Image saved to: ${savedImage.path}'),
  //     ));
  //     userHasCover(true);
  //   }
  // }

  // Future<File?> selectAndCropImage(File image) async {
  //   // Use the image_picker package to select an image from the gallery or take a photo
  //   // final image = await ImagePicker().getImage(source: ImageSource.gallery);
  //   final txtColor = Theme.of(context).iconTheme.color;
  //   final bgColor = Theme.of(context).scaffoldBackgroundColor;
    
  //   if (image != null) {
  //     // Use the image_cropper package to crop the selected image
  //     CroppedFile? croppedImage = await ImageCropper().cropImage(
  //       sourcePath: image.path,
  //       aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 2), // Set the desired aspect ratio
  //       compressQuality: 100,
  //       uiSettings: [
  //         AndroidUiSettings(
  //           toolbarTitle: 'Crop Image',
  //           toolbarColor: bgColor,
  //           toolbarWidgetColor: txtColor,
  //           activeControlsWidgetColor: bgColor,
  //           backgroundColor: bgColor,
  //           showCropGrid: true,
  //           )
  //       ] // Set the im]age quality
  //     );

  //     if (croppedImage != null) {
  //       return File(croppedImage.path);
  //       // setState(() {
  //       //   this.img = File(image.path);
  //       // });
  //     } else {
  //       return null;
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context, ' No img found', Icon(Icons.close), false));
  //   }
  // }
  // Future<void> userHasCover(bool bValue) async {
  //   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  //   final response = await http.put(Uri.parse('${Globals().url}m/update/cover/${widget.id}/'),
  //   body: json.encode({'userHasCover':bValue}),
  //   headers: {
  //       'Content-Type':'application/json; charset=utf-8',
  //       HttpHeaders.authorizationHeader: 'Bearer $id_token',
  //     },
  //   );
  //   if(response.statusCode!=200){
  //     // ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context, ' Something went wrong', Icon(Icons.close), true));
  //     throw Exception(response.body);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(context, ' Success', Icon(Icons.check), true));
  //   }
  // }




// @override
//   Future<void> _pickImage(String fileN) async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null && mounted) {
//       setState(() {
//         _coverImg = File(pickedFile.path);
//       });
//       final appDir = await getApplicationDocumentsDirectory();
//       final nomedialFile = File('${appDir.path}/.nomedia');
//       if (!await nomedialFile.exists()){
//         await nomedialFile.create();
//       }
//       final fileName = '$fileN.jpg';
//       final savedImage = await _coverImg!.copy('${appDir.path}/$fileName');
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Image saved to: ${savedImage.path}'),
//       ));
//     }
//   }

// @override
//   Future<void> _saveImage() async {
    
//   }
  
  @override
  Widget build(BuildContext context) {
    Color? ThemeColor = Theme.of(context).scaffoldBackgroundColor;
    late Color? imageShadow = Theme.of(context).primaryColor;
    return Align(
    alignment:Alignment.center,
    child: SizedBox(
    //width: MediaQuery.of(context).size.width*0.6,
    child: Card(
      elevation: 0,
      color: Colors.transparent,
      //clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        ),
    child: Stack(
      alignment: Alignment.center,
      
      children: [
        Container(
            height: Globals().moviePosterHeight,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              // gradient: LinearGradient(
              //   colors: [
              //     ThemeColor,
              //     // Color.fromARGB(64, 129, 129, 129),
              //     ThemeColor
              //   ]
              // ),
              image: DecorationImage(
                image: NetworkImage(widget.imgUrl),
                fit: BoxFit.cover,
              )
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0,sigmaY: 50),
              child: Text(''),
            ),
          ),
        Container(
          decoration: BoxDecoration(
          boxShadow: [
              BoxShadow(
                color: imageShadow,
                spreadRadius: 300,
                blurRadius: 90,
                offset: Offset(0, 300),
              ),
            ],
           ),
          ),
          Positioned(
            bottom:0,
            child: Column(
              children: [
                GestureDetector(
                  // onLongPress: () {
                  //   _pickImage(widget.id);
                  //   // _saveImage(widget.id);
                  // },
                  // child: widget.userHasCover==true?
                  // FutureBuilder(
                  //   future: getFilePath(),
                  //   builder:(context, snapshot) {
                  //     if(snapshot.hasData){
                  //       return Image.file(
                  //         File(snapshot.data!),
                  //         height: 200,
                  //         width: 100,
                  //         fit: BoxFit.cover,
                  //         );
                  //     } else if (snapshot.hasError) {
                  //         return Image.network(
                  //           widget.imgUrl,
                  //           height: 200,
                  //           width: 125,
                  //           fit: BoxFit.cover,
                  //         );               
                  //     } else {
                  //       return CircularProgressIndicator();
                  //     }
                  //   },
                  // )
                  // :
                  // child:Image.network(
                  //   widget.imgUrl,
                  //   height: 200,
                  //   width: 125,
                  //   fit: BoxFit.cover,
                  // ),
                  child: Container(),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  width: 350,
                  child: Text(
                  widget.title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 35,
                    color: Theme.of(context).iconTheme.color,
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
          ),
              ],
            )
          ),
        ]
      ),
  )
  )
  );
  }
  // Future<String> getFilePath() async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final filePath = '${directory.path}/${widget.id}.jpg';
  //   return filePath;
  // }
}