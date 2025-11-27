// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get navTimeline => 'タイムライン';

  @override
  String get navRanking => 'ランキング';

  @override
  String get navProfile => 'プロフィール';

  @override
  String get tabLatest => '最新';

  @override
  String get tabFollowing => 'フォロー中';

  @override
  String get tabTrending => 'トレンド';

  @override
  String get tabPopularPosts => '人気投稿';

  @override
  String get tabLikes => 'いいね';

  @override
  String get tabLevel => 'レベル';

  @override
  String get tabFollowers => 'フォロワー';

  @override
  String get newPost => '新規投稿';

  @override
  String get enterText => 'テキストを入力';

  @override
  String get cancel => 'キャンセル';

  @override
  String get post => '投稿';

  @override
  String posted(String text) {
    return '投稿しました: $text';
  }

  @override
  String get followed => 'フォローしました';

  @override
  String get follow => 'フォローする';

  @override
  String get editProfile => 'プロフィール編集';

  @override
  String get name => '名前';

  @override
  String get bio => 'Bio';

  @override
  String get url => 'URL';

  @override
  String get save => '保存';

  @override
  String get logout => 'ログアウト';

  @override
  String get profileSaved => 'プロフィールを保存しました';

  @override
  String get loggedOut => 'ログアウトしました';

  @override
  String get totalLikes => '総獲得いいね';

  @override
  String get level => 'レベル';

  @override
  String get myRanking => 'My ランキング';

  @override
  String get following => 'フォロー';

  @override
  String get followers => 'フォロワー';

  @override
  String get status => '状態';

  @override
  String get statusActive => 'アクティブ';

  @override
  String get likedPosts => 'いいねした投稿';

  @override
  String likesCount(String count) {
    return '$count いいね';
  }

  @override
  String viewingUserPosts(String user) {
    return '$user の投稿を表示中';
  }

  @override
  String get sourceLatest => '最新';

  @override
  String get sourceFollowing => 'フォロー中';

  @override
  String get sourceTrending => 'トレンド';

  @override
  String get sourceLiked => 'いいね済み';

  @override
  String minutesAgo(int count) {
    return '$count分前';
  }

  @override
  String hoursAgo(int count) {
    return '$count時間前';
  }

  @override
  String get yesterday => '昨日';

  @override
  String daysAgo(int count) {
    return '$count日前';
  }

  @override
  String followersCount(String count) {
    return '$count フォロワー';
  }

  @override
  String levelDisplay(int level) {
    return 'Lv.$level';
  }

  @override
  String userPost(String user) {
    return '$user の投稿';
  }
}
