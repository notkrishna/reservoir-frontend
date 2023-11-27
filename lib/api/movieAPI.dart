import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttert/models/movieModel.dart';
import 'package:fluttert/models/userModel.dart';
import 'package:fluttert/pages/globals.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;


// Future<List<Movie>> fetchMovieList() async{
//   try {
//     String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
//     final response = await http.get(
//       Uri.parse('${Globals().user}m/'),
//       headers: {
//           HttpHeaders.authorizationHeader: 'Bearer $id_token',
//       },
//     );
//     if (response.statusCode == 200){
//       final List result = json.decode(response.body);
//       return result.map((e) => Movie.fromJson(e)).toList();
//     } else {
//       throw response.body;
//     }
//   } catch (e) {
//     return <Movie>[];
//   }
// }

Future<String> fetchMovieName(int id) async {
  String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  final response = await http.get(
    Uri.parse('${Globals().url}m/name/${id}/'),
    headers: {
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
    },
  );
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception(response.body);
  }
}

Future<Movie> fetchMovie(String id) async{
    String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
    final response = await http.get(
      Uri.parse('${Globals().url}m/${id}/'),
      headers: {
          HttpHeaders.authorizationHeader: 'Bearer $id_token',
      },
    );
    if (response.statusCode == 200){
      return Movie.fromJson(
        jsonDecode(response.body)
      );
    } else {
      throw Exception(response.body);
    }
  }

// Future<Movie> fetchMovie(int id) async {
//   String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
//     final response = await http.get(
//       Uri.parse('http://192.168.1.9:8000/m/$id'),
//       headers: {
//           HttpHeaders.authorizationHeader: 'Bearer $id_token',
//       },
//     );
//   if (response.statusCode == 200) {
//     var data = jsonDecode(response.body);
//     return Movie.fromJson(data);
//   } else {
//     throw Exception(response.body);
//   }
// }

Future<List<SavedMovies>> fetchSavedMovies() async {
  String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  final response = await http.get(
    Uri.parse('${Globals().url}saved/'),
    headers: {
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
        },
  );
  if (response.statusCode==200){
    return (json.decode(response.body) as List)
    .map((data) => SavedMovies.fromJson(data))
    .toList();
  } else {
    throw Exception(response.body);
  }
}

Future<List<ProgressMovies>> fetchProgressMovies() async {
  String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  final response = await http.get(
    Uri.parse('${Globals().url}progress/'),
    headers: {
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
        },
  );
  if (response.statusCode==200){
    return (json.decode(response.body) as List)
    .map((data) => ProgressMovies.fromJson(data))
    .toList();
  } else {
    throw Exception(response.body);
  }
}

Future<bool> isMovieSaved(int id) async{
  String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  final response = await http.get(
    Uri.parse('${Globals().user}saved/?mn=$id'),
    headers: {
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
    },
  );
  try {
    if (response.statusCode==200) {
      final data = jsonDecode(response.body);
      if (data.length == 0) {
        return false;
      } else {
        return true;
      }
    } else if (response.statusCode == 404) {
      return false;
    } else {
      throw Exception(response.body);
    }
  } catch (e) {
    return false;
  }
}


Future<String> removeMovieSaved(int id) async {
  String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  final response = await http.delete(
    Uri.parse('${Globals().url}saved/delete/$id/'),
    headers: {
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
    },
    
  );
  if (response.statusCode==204){
      return 'Success';
    } else {
      throw Exception(response.body);
    }
}

Future<String> createMovieSaved(int movie_name) async {
  String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
  final response = await http.post(
    Uri.parse('${Globals().user}saved/create/'),
    headers: {
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
        'Content-Type':'application/json',
    },
    body:jsonEncode(
      {
        'movie_name':movie_name,
      }
    )
    
  );
  if (response.statusCode==201){
      return 'Success';
  } else {
    throw Exception(response.body);
  }
}



Future<UserProfile> fetchUserDataById(String user) async {
    try {
      String id_token = await FirebaseAuth.instance.currentUser!.getIdToken();
      final response = await http.get(
        Uri.parse(
        '${Globals().url}api/u/$user',
        ),
        headers: {
        HttpHeaders.authorizationHeader: 'Bearer $id_token',
        },
      );
    if (response.statusCode == 200) {
      return UserProfile.fromJson(jsonDecode(response.body));

    } else {
      throw Exception(response.body);
    }
  } catch (e) {
    throw Exception('error');
  }

}