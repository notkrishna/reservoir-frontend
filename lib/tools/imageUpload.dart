// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image_cropper/image_cropper.dart';

// class ImageUpload{
//   static Future<File> pickImage({
//     required bool isGallery,
//     required Future<File> Function(File file) cropImage,

//   }) async {
//     final source = isGallery?ImageSource.gallery:ImageSource.camera;
//       final img = await ImagePicker().pickImage(source: source);
//       if (img == null) return null;

//   }
// }