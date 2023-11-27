class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String user;
  final String post_id;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.user,
    required this.post_id,
  });
  factory NotificationModel.fromJson(Map<String,dynamic> json) {
    return NotificationModel(id: json['id'], title: json['title'], body: json['body'], user: json['user'], post_id:json['post_id']);
  }
}