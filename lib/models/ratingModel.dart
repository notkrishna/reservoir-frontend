import 'package:http/http.dart';

class Rating {
  final String id;
  final int rating;
  final String review;
  final String movie;
  final String movie_name;
  final String usertag;
  final String userProfilePic;
  final String user;
  final int commentCount;
  final String coverImgUrl;
  final bool isLiked;
  final int likeCount;
  // final bool isReviewed;

  Rating({
    required this.id, 
    required this.rating, 
    this.review = "", 
    required this.movie, 
    required this.movie_name, 
    required this.usertag, 
    required this.userProfilePic, 
    required this.user,
    required this.commentCount,
    required this.coverImgUrl,
    required this.likeCount,
    required this.isLiked,
    // required this.isReviewed,
    });

  factory Rating.fromJson(Map<String,dynamic> json) {
    return Rating(
      id: json['id'], 
      rating: json['rating'], 
      review: json['review'],
      movie: json['movie'], 
      movie_name: json['movie_name'],
      usertag: json['usertag'],
      userProfilePic: json['profile_pic'],
      user: json['user'],
      commentCount: json['comment_count'],
      likeCount: json['like_count'],
      isLiked: json['is_liked'],
      coverImgUrl: json['coverImgUrl'] as String? ?? "https://png.pngtree.com/png-vector/20210609/ourmid/pngtree-mountain-network-placeholder-png-image_3423368.jpg",
      
      // isReviewed: json['isReviewed']
    );
  }
}

class RatingComment {
  final String id;
  final String rating;
  final String comment;
  final String user;
  final String usertag;
  RatingComment({
    required this.id,
    required this.rating,
    required this.comment,
    required this.user,
    required this.usertag,
  });
  factory RatingComment.fromJson(Map<String,dynamic> json) {
    return RatingComment(id: json['id'], rating: json['rating'], comment: json['comment'], user: json['user'], usertag: json['usertag']);
  }
}