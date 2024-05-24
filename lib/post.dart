class Post {
  int id;
  String title;
  String content;
  String createdAt;
  String username;
  List<dynamic> comments;
  int likeCount;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.username,
    required this.comments,
    required this.likeCount,
  });
}
