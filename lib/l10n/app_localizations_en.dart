// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navTimeline => 'Timeline';

  @override
  String get navRanking => 'Ranking';

  @override
  String get navProfile => 'Profile';

  @override
  String get tabLatest => 'Latest';

  @override
  String get tabFollowing => 'Following';

  @override
  String get tabTrending => 'Trending';

  @override
  String get tabPopularPosts => 'Popular';

  @override
  String get tabLikes => 'Likes';

  @override
  String get tabLevel => 'Level';

  @override
  String get tabFollowers => 'Followers';

  @override
  String get newPost => 'New Post';

  @override
  String get enterText => 'Enter text';

  @override
  String get cancel => 'Cancel';

  @override
  String get post => 'Post';

  @override
  String posted(String text) {
    return 'Posted: $text';
  }

  @override
  String get followed => 'Followed';

  @override
  String get follow => 'Follow';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get name => 'Name';

  @override
  String get bio => 'Bio';

  @override
  String get url => 'URL';

  @override
  String get save => 'Save';

  @override
  String get logout => 'Logout';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get loggedOut => 'Logged out';

  @override
  String get totalLikes => 'Total Likes';

  @override
  String get level => 'Level';

  @override
  String get myRanking => 'My Ranking';

  @override
  String get following => 'Following';

  @override
  String get followers => 'Followers';

  @override
  String get status => 'Status';

  @override
  String get statusActive => 'Active';

  @override
  String get likedPosts => 'Liked Posts';

  @override
  String likesCount(String count) {
    return '$count likes';
  }

  @override
  String viewingUserPosts(String user) {
    return 'Viewing $user\'s posts';
  }

  @override
  String get sourceLatest => 'Latest';

  @override
  String get sourceFollowing => 'Following';

  @override
  String get sourceTrending => 'Trending';

  @override
  String get sourceLiked => 'Liked';

  @override
  String minutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String hoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String followersCount(String count) {
    return '$count followers';
  }

  @override
  String levelDisplay(int level) {
    return 'Lv.$level';
  }

  @override
  String userPost(String user) {
    return '$user\'s post';
  }
}
