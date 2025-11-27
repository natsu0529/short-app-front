import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// No description provided for @navTimeline.
  ///
  /// In ja, this message translates to:
  /// **'タイムライン'**
  String get navTimeline;

  /// No description provided for @navRanking.
  ///
  /// In ja, this message translates to:
  /// **'ランキング'**
  String get navRanking;

  /// No description provided for @navProfile.
  ///
  /// In ja, this message translates to:
  /// **'プロフィール'**
  String get navProfile;

  /// No description provided for @tabLatest.
  ///
  /// In ja, this message translates to:
  /// **'最新'**
  String get tabLatest;

  /// No description provided for @tabFollowing.
  ///
  /// In ja, this message translates to:
  /// **'フォロー中'**
  String get tabFollowing;

  /// No description provided for @tabTrending.
  ///
  /// In ja, this message translates to:
  /// **'トレンド'**
  String get tabTrending;

  /// No description provided for @tabPopularPosts.
  ///
  /// In ja, this message translates to:
  /// **'人気投稿'**
  String get tabPopularPosts;

  /// No description provided for @tabLikes.
  ///
  /// In ja, this message translates to:
  /// **'いいね'**
  String get tabLikes;

  /// No description provided for @tabLevel.
  ///
  /// In ja, this message translates to:
  /// **'レベル'**
  String get tabLevel;

  /// No description provided for @tabFollowers.
  ///
  /// In ja, this message translates to:
  /// **'フォロワー'**
  String get tabFollowers;

  /// No description provided for @newPost.
  ///
  /// In ja, this message translates to:
  /// **'新規投稿'**
  String get newPost;

  /// No description provided for @enterText.
  ///
  /// In ja, this message translates to:
  /// **'テキストを入力'**
  String get enterText;

  /// No description provided for @cancel.
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get cancel;

  /// No description provided for @post.
  ///
  /// In ja, this message translates to:
  /// **'投稿'**
  String get post;

  /// No description provided for @posted.
  ///
  /// In ja, this message translates to:
  /// **'投稿しました: {text}'**
  String posted(String text);

  /// No description provided for @followed.
  ///
  /// In ja, this message translates to:
  /// **'フォローしました'**
  String get followed;

  /// No description provided for @follow.
  ///
  /// In ja, this message translates to:
  /// **'フォローする'**
  String get follow;

  /// No description provided for @editProfile.
  ///
  /// In ja, this message translates to:
  /// **'プロフィール編集'**
  String get editProfile;

  /// No description provided for @name.
  ///
  /// In ja, this message translates to:
  /// **'名前'**
  String get name;

  /// No description provided for @bio.
  ///
  /// In ja, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @url.
  ///
  /// In ja, this message translates to:
  /// **'URL'**
  String get url;

  /// No description provided for @save.
  ///
  /// In ja, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @logout.
  ///
  /// In ja, this message translates to:
  /// **'ログアウト'**
  String get logout;

  /// No description provided for @profileSaved.
  ///
  /// In ja, this message translates to:
  /// **'プロフィールを保存しました'**
  String get profileSaved;

  /// No description provided for @loggedOut.
  ///
  /// In ja, this message translates to:
  /// **'ログアウトしました'**
  String get loggedOut;

  /// No description provided for @totalLikes.
  ///
  /// In ja, this message translates to:
  /// **'総獲得いいね'**
  String get totalLikes;

  /// No description provided for @level.
  ///
  /// In ja, this message translates to:
  /// **'レベル'**
  String get level;

  /// No description provided for @myRanking.
  ///
  /// In ja, this message translates to:
  /// **'My ランキング'**
  String get myRanking;

  /// No description provided for @following.
  ///
  /// In ja, this message translates to:
  /// **'フォロー'**
  String get following;

  /// No description provided for @followers.
  ///
  /// In ja, this message translates to:
  /// **'フォロワー'**
  String get followers;

  /// No description provided for @status.
  ///
  /// In ja, this message translates to:
  /// **'状態'**
  String get status;

  /// No description provided for @statusActive.
  ///
  /// In ja, this message translates to:
  /// **'アクティブ'**
  String get statusActive;

  /// No description provided for @likedPosts.
  ///
  /// In ja, this message translates to:
  /// **'いいねした投稿'**
  String get likedPosts;

  /// No description provided for @likesCount.
  ///
  /// In ja, this message translates to:
  /// **'{count} いいね'**
  String likesCount(String count);

  /// No description provided for @viewingUserPosts.
  ///
  /// In ja, this message translates to:
  /// **'{user} の投稿を表示中'**
  String viewingUserPosts(String user);

  /// No description provided for @sourceLatest.
  ///
  /// In ja, this message translates to:
  /// **'最新'**
  String get sourceLatest;

  /// No description provided for @sourceFollowing.
  ///
  /// In ja, this message translates to:
  /// **'フォロー中'**
  String get sourceFollowing;

  /// No description provided for @sourceTrending.
  ///
  /// In ja, this message translates to:
  /// **'トレンド'**
  String get sourceTrending;

  /// No description provided for @sourceLiked.
  ///
  /// In ja, this message translates to:
  /// **'いいね済み'**
  String get sourceLiked;

  /// No description provided for @minutesAgo.
  ///
  /// In ja, this message translates to:
  /// **'{count}分前'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In ja, this message translates to:
  /// **'{count}時間前'**
  String hoursAgo(int count);

  /// No description provided for @yesterday.
  ///
  /// In ja, this message translates to:
  /// **'昨日'**
  String get yesterday;

  /// No description provided for @daysAgo.
  ///
  /// In ja, this message translates to:
  /// **'{count}日前'**
  String daysAgo(int count);

  /// No description provided for @followersCount.
  ///
  /// In ja, this message translates to:
  /// **'{count} フォロワー'**
  String followersCount(String count);

  /// No description provided for @levelDisplay.
  ///
  /// In ja, this message translates to:
  /// **'Lv.{level}'**
  String levelDisplay(int level);

  /// No description provided for @userPost.
  ///
  /// In ja, this message translates to:
  /// **'{user} の投稿'**
  String userPost(String user);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'en',
    'es',
    'fr',
    'ja',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
