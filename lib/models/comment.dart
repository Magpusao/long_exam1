class Comment {
  final int id;
  final String body;
  final int postId;
  final int userId;
  final int likes;
  final String username;
  final String fullName;

  const Comment({
    required this.id,
    required this.body,
    required this.postId,
    required this.userId,
    required this.likes,
    required this.username,
    required this.fullName,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    return Comment(
      id: json['id'] ?? 0,
      body: json['body'] ?? '',
      postId: json['postId'] ?? json['post_id'] ?? 0,
      userId: user is Map<String, dynamic>
          ? user['id'] ?? 0
          : json['userId'] ?? json['user_id'] ?? 0,
      likes: json['likes'] ?? 0,
      username: user is Map<String, dynamic> ? user['username'] ?? '' : '',
      fullName: user is Map<String, dynamic> ? user['fullName'] ?? '' : '',
    );
  }
}
