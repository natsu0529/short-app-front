// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get navTimeline => '时间线';

  @override
  String get navRanking => '排行榜';

  @override
  String get navProfile => '个人资料';

  @override
  String get tabLatest => '最新';

  @override
  String get tabFollowing => '关注';

  @override
  String get tabTrending => '热门';

  @override
  String get tabPopularPosts => '热门帖子';

  @override
  String get tabLikes => '点赞';

  @override
  String get tabLevel => '等级';

  @override
  String get tabFollowers => '粉丝';

  @override
  String get newPost => '发布新帖';

  @override
  String get enterText => '输入文字';

  @override
  String get cancel => '取消';

  @override
  String get post => '发布';

  @override
  String posted(String text) {
    return '已发布: $text';
  }

  @override
  String get followed => '已关注';

  @override
  String get follow => '关注';

  @override
  String get editProfile => '编辑资料';

  @override
  String get name => '姓名';

  @override
  String get bio => '简介';

  @override
  String get url => '网址';

  @override
  String get save => '保存';

  @override
  String get logout => '退出登录';

  @override
  String get profileSaved => '资料已保存';

  @override
  String get loggedOut => '已退出登录';

  @override
  String get totalLikes => '总点赞数';

  @override
  String get level => '等级';

  @override
  String get myRanking => '我的排名';

  @override
  String get following => '关注';

  @override
  String get followers => '粉丝';

  @override
  String get status => '状态';

  @override
  String get statusActive => '活跃';

  @override
  String get likedPosts => '点赞的帖子';

  @override
  String likesCount(String count) {
    return '$count 点赞';
  }

  @override
  String viewingUserPosts(String user) {
    return '查看 $user 的帖子';
  }

  @override
  String get sourceLatest => '最新';

  @override
  String get sourceFollowing => '关注';

  @override
  String get sourceTrending => '热门';

  @override
  String get sourceLiked => '已点赞';

  @override
  String minutesAgo(int count) {
    return '$count分钟前';
  }

  @override
  String hoursAgo(int count) {
    return '$count小时前';
  }

  @override
  String get yesterday => '昨天';

  @override
  String daysAgo(int count) {
    return '$count天前';
  }

  @override
  String followersCount(String count) {
    return '$count 粉丝';
  }

  @override
  String levelDisplay(int level) {
    return 'Lv.$level';
  }

  @override
  String userPost(String user) {
    return '$user 的帖子';
  }

  @override
  String get liked => '已点赞';

  @override
  String get loginRequired => '请登录';

  @override
  String get login => '登录';

  @override
  String get register => '注册';

  @override
  String get email => '邮箱';

  @override
  String get password => '密码';

  @override
  String get username => '用户名';

  @override
  String get displayName => '显示名称';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get alreadyHaveAccount => '已有账号？';

  @override
  String get dontHaveAccount => '没有账号？';

  @override
  String get orContinueWith => '或者';

  @override
  String get signInWithGoogle => '使用Google登录';

  @override
  String get unfollow => '取消关注';

  @override
  String get unfollowed => '已取消关注';

  @override
  String get loading => '加载中...';

  @override
  String get error => '发生错误';

  @override
  String get retry => '重试';

  @override
  String get noPostsYet => '暂无帖子';

  @override
  String get noPosts => '没有帖子';

  @override
  String get appTitle => 'Short App';

  @override
  String get loginDescription => '与世界分享你的精彩瞬间';
}
