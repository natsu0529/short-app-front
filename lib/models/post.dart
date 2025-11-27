import 'user.dart';

class Post {
  final int postId;
  final User user;
  final String context;
  final int likeCount;
  final DateTime time;
  final bool isLiked;
  final int? likeId;

  const Post({
    required this.postId,
    required this.user,
    required this.context,
    required this.likeCount,
    required this.time,
    this.isLiked = false,
    this.likeId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['post_id'],
      user: User.fromJson(json['user']),
      context: json['context'] ?? '',
      likeCount: json['like_count'] ?? 0,
      time: DateTime.parse(json['time']),
      isLiked: json['is_liked'] ?? false,
      likeId: json['like_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'user': user.toJson(),
      'context': context,
      'like_count': likeCount,
      'time': time.toIso8601String(),
      'is_liked': isLiked,
      'like_id': likeId,
    };
  }

  Post copyWith({
    int? postId,
    User? user,
    String? context,
    int? likeCount,
    DateTime? time,
    bool? isLiked,
    int? likeId,
  }) {
    return Post(
      postId: postId ?? this.postId,
      user: user ?? this.user,
      context: context ?? this.context,
      likeCount: likeCount ?? this.likeCount,
      time: time ?? this.time,
      isLiked: isLiked ?? this.isLiked,
      likeId: likeId ?? this.likeId,
    );
  }

  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h';
    } else if (diff.inDays == 1) {
      return 'yesterday';
    } else {
      return '${diff.inDays}d';
    }
  }
}
