import 'package:firebase_auth/firebase_auth.dart';

class Timeline {
  final String id;
  final int stamp;
  final String stampText;
  final bool isPublic;
  final String movie;
  final String movie_name;
  final String coverImgUrl;
  final String user;
  final String usertag;
  final int commentCount;
  final bool isLiked;
  final int likeCount;
  
  const Timeline({
    required this.id,
    required this.stamp,
    required this.stampText,
    required this.isPublic,
    required this.movie,
    required this.movie_name,
    required this.coverImgUrl,
    required this.user,
    required this.usertag,
    required this.commentCount,
    required this.likeCount,
    required this.isLiked,
    
  });

  factory Timeline.fromJson(Map<String,dynamic> json){ 
    return Timeline(
    id: json['id'], 
    stamp: json['stamp'],
    stampText: json['stampText'],
    isPublic: json['isPublic'], 
    movie: json['movie'], 
    movie_name: json['movie_name'],
    coverImgUrl: json['coverImgUrl'],
    user: json['user'],
    usertag: json['usertag'],
    commentCount: json['comment_count'],
    likeCount: json['like_count'],
    isLiked: json['is_liked'],
    );
  }
}

class ProgressDetail {
  final String id;
  final int stamp;
  final String stampText;

  const ProgressDetail({
    required this.id,
    required this.stamp,
    required this.stampText,
  });

  factory ProgressDetail.fromJson(Map<String,dynamic> json){ 
    return ProgressDetail(
    id: json['id'], 
    stamp: json['stamp'],
    stampText: json['stampText'],
    );
  }
}

