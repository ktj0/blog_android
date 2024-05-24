class Comment {
  int id;
  String comment;
  String username;
  String createdAt;
  String modifiedAt;
  int likeCount;

  Comment({
    required this.id,
    required this.comment,
    required this.username,
    required this.createdAt,
    required this.modifiedAt,
    required this.likeCount,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      comment: json['comment'],
      username: json['username'],
      createdAt: json['createdAt'],
      modifiedAt: json['modifiedAt'],
      likeCount: json['likeCount'],
    );
  }
}
