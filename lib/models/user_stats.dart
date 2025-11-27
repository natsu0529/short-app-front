class UserStats {
  final int experiencePoints;
  final int totalLikesReceived;
  final int totalLikesGiven;
  final int followerCount;
  final int followingCount;
  final int postCount;
  final DateTime? lastLevelUp;
  final DateTime? updatedAt;

  const UserStats({
    required this.experiencePoints,
    required this.totalLikesReceived,
    required this.totalLikesGiven,
    required this.followerCount,
    required this.followingCount,
    required this.postCount,
    this.lastLevelUp,
    this.updatedAt,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      experiencePoints: json['experience_points'] ?? 0,
      totalLikesReceived: json['total_likes_received'] ?? 0,
      totalLikesGiven: json['total_likes_given'] ?? 0,
      followerCount: json['follower_count'] ?? 0,
      followingCount: json['following_count'] ?? 0,
      postCount: json['post_count'] ?? 0,
      lastLevelUp: json['last_level_up'] != null
          ? DateTime.parse(json['last_level_up'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'experience_points': experiencePoints,
      'total_likes_received': totalLikesReceived,
      'total_likes_given': totalLikesGiven,
      'follower_count': followerCount,
      'following_count': followingCount,
      'post_count': postCount,
      'last_level_up': lastLevelUp?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  UserStats copyWith({
    int? experiencePoints,
    int? totalLikesReceived,
    int? totalLikesGiven,
    int? followerCount,
    int? followingCount,
    int? postCount,
    DateTime? lastLevelUp,
    DateTime? updatedAt,
  }) {
    return UserStats(
      experiencePoints: experiencePoints ?? this.experiencePoints,
      totalLikesReceived: totalLikesReceived ?? this.totalLikesReceived,
      totalLikesGiven: totalLikesGiven ?? this.totalLikesGiven,
      followerCount: followerCount ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount,
      postCount: postCount ?? this.postCount,
      lastLevelUp: lastLevelUp ?? this.lastLevelUp,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
