class Tribe {
  final String id;
  final String user;
  final String postType;
  late final String usertag;
  final String profilePic;
  final String movie;
  final String title;
  final String caption;
  final String photoUrl;
  final String postedAt;
  final bool isLiked;
  final int likeCount;
  final int commentCount;

  Tribe({
    required this.id,
    required this.user,
    required this.postType,
    required this.usertag,
    required this.profilePic,
    required this.title,
    required this.caption,
    required this.movie,
    required this.photoUrl,
    required this.postedAt,
    required this.isLiked,
    required this.likeCount,
    required this.commentCount,
  });

  factory Tribe.fromJson(Map<String,dynamic> json) {
    return Tribe(
      id: json['id'], 
      user: json['user'], 
      postType: json['post_type'],
      usertag: json['usertag'], 
      profilePic: json['profile_pic'],
      title: json['title'], 
      caption: json['caption'], 
      movie: json['movie'],
      photoUrl: json['photo_url'] as String? ?? "",
      postedAt: json['posted_at'],
      isLiked: json['is_liked'],
      likeCount: json['like_count'],
      commentCount: json['comment_count'],
    );
  }
}

class PostComment {
  final String id;
  final String post;
  final String comment;
  final String user;
  final String usertag;
  final String profilePic;
  PostComment({
    required this.id,
    required this.post,
    required this.comment,
    required this.user,
    required this.usertag,
    required this.profilePic,
  });
  factory PostComment.fromJson(Map<String,dynamic> json) {
    return PostComment(
      id: json['id'], 
      post: json['post'], 
      comment: json['comment'], 
      user: json['user'],
      usertag: json['usertag'],
      profilePic:json['profile_pic'],
      );
  }
}

class TribeLike {
  final String id;
  final String user;
  final String post;

  TribeLike({
    required this.id,
    required this.user,
    required this.post,
  });

  factory TribeLike.fromJson(Map<String,dynamic> json) {
    return TribeLike(
      id: json['id'], 
      user: json['user'], 
      post: json['post'],
    );
  }
}