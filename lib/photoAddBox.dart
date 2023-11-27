import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttert/models/tribeModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'package:fluttert/providers/postProvider.dart';
import 'package:fluttert/tools/loading.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PhotoDialogueBox extends StatefulWidget {
  final String req;
  final String id;
  final String movie;
  final BuildContext cxt;
  // final PostProvider provider;
  const PhotoDialogueBox({
    super.key, 
    required this.req, 
    required this.id, 
    required this.movie,
    required this.cxt,
    // required this.provider
    });

  @override
  State<PhotoDialogueBox> createState() => _PhotoDialogueBoxState();
}

class _PhotoDialogueBoxState extends State<PhotoDialogueBox> {
  // late TextEditingController _textController;
  final _title = TextEditingController();
  final _caption = TextEditingController();
  final _photoUrl = TextEditingController();
  bool isStampStatusPublic = true;
  double btnsize = 18;
  File? img;
  final GlobalKey<ScaffoldMessengerState> scaffoldMKey = GlobalKey<ScaffoldMessengerState>();
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
    
  // }

  // Future<void> putData(String Value) async{
  //   final response = await http.post(
  //     Uri.parse('${Globals().url}/api/ts/list/'),
      
  //   );
  // }
  


  @override
  Future pickImage(ImageSource source) async {
    try {
      final img = await ImagePicker().pickImage(source: source);
      if (img==null) return;
      // final crpimg = await ImageCropper().cropImage(
      //   sourcePath: img.path,
      // );

      // final imgtmp = File(crpimg!.path);
      File? imgtmp = File(img.path);
      imgtmp = await selectAndCropImage(imgtmp);
      if(mounted){
        setState(() {
          this.img = imgtmp;

        });
      }
    } on PlatformException catch(e) {
      print('Failed');
    }

  }

Future<File?> selectAndCropImage(File image) async {
  // Use the image_picker package to select an image from the gallery or take a photo
  // final image = await ImagePicker().getImage(source: ImageSource.gallery);
  final txtColor = Theme.of(context).iconTheme.color;
  final bgColor = Theme.of(context).scaffoldBackgroundColor;
  
  if (image != null) {
    // Use the image_cropper package to crop the selected image
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      // aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1), // Set the desired aspect ratio
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: bgColor,
          toolbarWidgetColor: txtColor,
          activeControlsWidgetColor: bgColor,
          backgroundColor: bgColor,
          lockAspectRatio: false,
          showCropGrid: true,
          )
       ] // Set the im]age quality
    );

    if (croppedImage != null) {
      return File(croppedImage.path);
      // setState(() {
      //   this.img = File(image.path);
      // });
    } else {
      return null;
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg( ' No img found', Icon(Icons.close), false));
  }
}


  @override
  Widget build(BuildContext context) {
    // final PostProvider postProvider = widget.provider;
    double wd = MediaQuery.of(context).size.width-100;
    final provider = Provider.of<PostProvider>(widget.cxt);
    BuildContext cContext = widget.cxt;
    return 
    // provider.inProgress?
    // Loading():
    Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: Text('Add Photo'),
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            int count = 0;
            Navigator.of(context).popUntil((_) => count++ >= 2);
          },
          icon:Icon(Icons.close)
          ),
        actions: <Widget>[
          Builder(
            builder: (cContext) {
              return 
              // pvdr.inProgress==true
              // ?
              // Center(child: CircularProgressIndicator(color: Colors.red,))
              // :
              IconButton(
                color: Color.fromARGB(255, 233, 30, 30),
                onPressed: (){
                  Provider.of<PostProvider>(widget.cxt,listen: false).postImgData(context, _title.text, _caption.text,widget.movie,img!.path);
                  // Navigator.pop(context);
                },
                icon: Icon(Icons.check, ),
                // child: Text('Save'),
              );
            }
          ),
        ],
      ),
      body: Container(
              height: MediaQuery.of(context).size.height*0.8,

        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                    controller: _title,
                    decoration: InputDecoration(
                      // prefixIcon: Icon(Icons.photo_camera),
                      hintText: 'Post Title',
                      border: OutlineInputBorder(),
                      iconColor: Colors.white,
                      
                    ),
                    keyboardType: TextInputType.multiline,
                  ),
                  SizedBox(height: 5,),
                  TextField(
                    controller: _caption,
                    decoration: InputDecoration(
                      // prefixIcon: Icon(Icons.photo_camera),
                      hintText: 'Post content',
                      border: OutlineInputBorder(),
                      iconColor: Colors.white,
                    ),
                    maxLines: 8,
                    keyboardType: TextInputType.multiline,
                  ),
                  SizedBox(height: 10,),
                  img != null ?
                  Center(
                    child: Image.file(
                      img!,
                      width: wd,
                      height: wd,
                      fit: BoxFit.cover,
                      )
                  )
                  :SizedBox(height: 0,),
                  SizedBox(height: 5,),
                  ButtonBar(
                    alignment: MainAxisAlignment.start,
                    children: [
                      ElevatedButton.icon(
                        onPressed: (){
                          pickImage(ImageSource.gallery);
                        }, 
                        icon: Icon(Icons.image), 
                        label: Text('Gallery')
                      ),
                      ElevatedButton.icon(
                        onPressed: (){
                          pickImage(ImageSource.camera);
                        }, 
                        icon: Icon(Icons.photo_camera), 
                        label: Text('Camera')
                      ),
                      // IconButton(onPressed: (){
                      //   if(mounted){
                      //     setState(){
                      //     img = null;
                      //   }
                      //   }
                      // }, 
                      // icon: Icon(Icons.cancel)
                      // )
                    ],
                  ),
                  
                  // TextField(
                  //   controller: _photoUrl,
                  //   decoration: InputDecoration(
                  //     // prefixIcon: Icon(Icons.photo_camera),
                  //     hintText: 'Photo URL',
                  //     border: OutlineInputBorder(),
                  //     iconColor: Colors.white,
                      
                  //   ),
                  //   maxLines: 1,
                  //   keyboardType: TextInputType.multiline,
                  // ),
                  // isStampStatusPublic? 
                  //   ElevatedButton.icon(
                  //     onPressed: (){
                  //       setState(() {
                  //         isStampStatusPublic = !isStampStatusPublic;
                  //       });
                  //     }, 
                  //     label: Text('Public'),
                  //     icon: Icon(Icons.public, size: btnsize,),
                  //   ):
                  //   ElevatedButton.icon(
                  //     onPressed: (){
                  //       setState(() {
                  //         isStampStatusPublic = !isStampStatusPublic;
                  //       });
                  //     }, 
                  //     label: Text('Private'),
                  //     icon: Icon(Icons.lock, size: 15,),
                  //   ),

                  
              ],
            ),
          ),
        ),
      ));
      






    // //////
    // return AlertDialog(
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(10)
    //   ),
    //   title: widget.req == 'PUT'? Text('Edit Post'): Text('Add Post'),
    //   content: 
    //   Column(
    //     mainAxisSize: MainAxisSize.min,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       TextField(
    //           controller: _title,
    //           decoration: InputDecoration(
    //             // prefixIcon: Icon(Icons.photo_camera),
    //             hintText: 'Post Title',
    //             border: OutlineInputBorder(),
    //             iconColor: Colors.white,
                
    //           ),
    //           keyboardType: TextInputType.multiline,
    //         ),
    //         SizedBox(height: 5,),
    //         TextField(
    //           controller: _caption,
    //           decoration: InputDecoration(
    //             // prefixIcon: Icon(Icons.photo_camera),
    //             hintText: 'Post content',
    //             border: OutlineInputBorder(),
    //             iconColor: Colors.white,
                
    //           ),
    //           maxLines: 3,
    //           keyboardType: TextInputType.multiline,
    //         ),
    //         // isStampStatusPublic? 
    //         //   ElevatedButton.icon(
    //         //     onPressed: (){
    //         //       setState(() {
    //         //         isStampStatusPublic = !isStampStatusPublic;
    //         //       });
    //         //     }, 
    //         //     label: Text('Public'),
    //         //     icon: Icon(Icons.public, size: btnsize,),
    //         //   ):
    //         //   ElevatedButton.icon(
    //         //     onPressed: (){
    //         //       setState(() {
    //         //         isStampStatusPublic = !isStampStatusPublic;
    //         //       });
    //         //     }, 
    //         //     label: Text('Private'),
    //         //     icon: Icon(Icons.lock, size: 15,),
    //         //   ),
    //     ],
    //   ),
      
    //   actions: <Widget>[
    //     ElevatedButton(
    //       onPressed: (){
    //         Navigator.of(context).pop();
    //       }, 
    //       style: ElevatedButton.styleFrom(
    //         backgroundColor: Colors.transparent
    //       ),
    //       child: Text('Cancel'),
    //     ),
    //     ElevatedButton(
    //       onPressed: (){
    //         postData(_title.text, _caption.text);
    //         Navigator.pop(context);
    //       },
          
    //       child: Text('Save'),
    //     ),
    //   ],
    //   backgroundColor: Theme.of(context).colorScheme.secondary,
    // );
  }

  Future<void> postData(String title, String caption) async {
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    String url = '${Globals().url}api/post/create/';
    // final response = await http.post(Uri.parse('${Globals().url}api/post/create/'),
    // body: json.encode({'title':title, 'caption':caption, 'movie':widget.movie, 'post_type':'photo'}),
    // headers: {
    //     'Content-Type':'application/json; charset=utf-8',
    //     HttpHeaders.authorizationHeader: 'Bearer $id_token',
    //   },
    // );

    // Create a multipart request
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Set the authorization header
    request.headers['Authorization'] = 'Bearer $id_token';

    // Add the title field
    request.fields['title'] = title;

    // Add the captions field
    request.fields['caption'] = caption;
    request.fields['post_type'] = 'photo';


    request.fields['movie'] = widget.movie.toString();

    // Add the image file
    

    request.files.add(
      await http.MultipartFile.fromPath(
        'image', 
        img!.path
        )
      );

    // Send the request
    var response = await request.send();

    if(response.statusCode==201){
      ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(' Post created successfully', Icon(Icons.edit), true));
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 2);
      // int count=0;
    //   Navigator.popUntil(context, (route) {
    //   // Check if there are at least two routes remaining in the stack
    //   count++;
    //   return count==3;
    // });
    } else {
        ScaffoldMessenger.of(context).showSnackBar(Globals().flashmsg(' Post created successfully', Icon(Icons.edit), true));
        throw Exception(response.stream);
    }
  } 
}