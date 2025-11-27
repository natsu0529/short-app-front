import 'user.dart';

class Follow {
  final int id;
  final User user;
  final User aimUser;
  final DateTime time;

  const Follow({
    required this.id,
    required this.user,
    required this.aimUser,
    required this.time,
  });

  factory Follow.fromJson(Map<String, dynamic> json) {
    return Follow(
      id: json['id'],
      user: User.fromJson(json['user']),
      aimUser: User.fromJson(json['aim_user']),
      time: DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'aim_user': aimUser.toJson(),
      'time': time.toIso8601String(),
    };
  }
}
