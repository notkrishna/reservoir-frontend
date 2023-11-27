class UserM {
  final String user_avatar;
  final String user_background;
  final String username;
  final String movie_name;
  final String post_content;
  final String time_posted;
  const UserM({
    required this.user_avatar,
    required this.user_background,
    required this.username,
    required this.movie_name,
    required this.post_content,
    required this.time_posted,
  });

  static UserM fromJson(json) => UserM(
    user_avatar: json['user_avatar'], 
    user_background: json['user_background'], 
    username: json['username'], 
    movie_name: json['movie_name'], 
    post_content: json['post_content'], 
    time_posted: json['time_posted'],
  );
}