import 'user_stats.dart';

class User {
  final int userId;
  final String username;
  final String userName;
  final String userRank;
  final int userLevel;
  final String userMail;
  final String userUrl;
  final String userBio;
  final UserStats? stats;
  final int? rank;

  const User({
    required this.userId,
    required this.username,
    required this.userName,
    this.userRank = '',
    this.userLevel = 1,
    this.userMail = '',
    this.userUrl = '',
    this.userBio = '',
    this.stats,
    this.rank,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      username: json['username'] ?? '',
      userName: json['user_name'] ?? '',
      userRank: json['user_rank'] ?? '',
      userLevel: json['user_level'] ?? 1,
      userMail: json['user_mail'] ?? '',
      userUrl: json['user_URL'] ?? '',
      userBio: json['user_bio'] ?? '',
      stats: json['stats'] != null ? UserStats.fromJson(json['stats']) : null,
      rank: json['rank'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'user_name': userName,
      'user_rank': userRank,
      'user_level': userLevel,
      'user_mail': userMail,
      'user_URL': userUrl,
      'user_bio': userBio,
      'stats': stats?.toJson(),
      'rank': rank,
    };
  }

  User copyWith({
    int? userId,
    String? username,
    String? userName,
    String? userRank,
    int? userLevel,
    String? userMail,
    String? userUrl,
    String? userBio,
    UserStats? stats,
    int? rank,
  }) {
    return User(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userName: userName ?? this.userName,
      userRank: userRank ?? this.userRank,
      userLevel: userLevel ?? this.userLevel,
      userMail: userMail ?? this.userMail,
      userUrl: userUrl ?? this.userUrl,
      userBio: userBio ?? this.userBio,
      stats: stats ?? this.stats,
      rank: rank ?? this.rank,
    );
  }

  String get handle => '@$username';

  String get initials {
    final parts = userName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }
}
