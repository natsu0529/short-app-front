import 'user.dart';
import 'post.dart';

class Like {
  final int id;
  final User user;
  final Post? post;
  final int? postId;
  final DateTime createdAt;

  const Like({
    required this.id,
    required this.user,
    this.post,
    this.postId,
    required this.createdAt,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id: json['id'],
      user: User.fromJson(json['user']),
      post: json['post'] != null ? Post.fromJson(json['post']) : null,
      postId: json['post_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'post': post?.toJson(),
      'post_id': postId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
