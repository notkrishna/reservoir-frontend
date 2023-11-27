
import 'package:flutter/widgets.dart';

class UserProfile{
  final String usertag;
  final String bio;
  final int followerCount;
  final int ratingCount;
  final double avgRating;
  final String profilePic;
  final String coverPic;

  const UserProfile({
    required this.usertag,
    required this.bio,
    required this.avgRating,
    required this.followerCount,
    required this.ratingCount,
    required this.profilePic,
    required this.coverPic,
  });
  
  factory UserProfile.fromJson(Map<String, dynamic> json){
    return UserProfile(
      usertag: json['usertag'], 
      bio: json['bio'],
      avgRating: json['avg_rating'],
      followerCount: json['follower_count'],
      ratingCount: json['rating_count'],
      profilePic: json['profile_pic'],
      coverPic: json['cover_pic']
    );
  }
}

class BlockedUser{
  final String blockedUsertag;
  final String blockedUser;

  const BlockedUser({
    required this.blockedUsertag,
    required this.blockedUser
  });
  
  factory BlockedUser.fromJson(Map<String, dynamic> json){
    return BlockedUser(
      blockedUsertag: json['blockedUsertag'] as String? ?? '', 
      blockedUser: json['blocked'],
    );
  }
}