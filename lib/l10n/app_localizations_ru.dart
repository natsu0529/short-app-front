// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get navTimeline => 'Лента';

  @override
  String get navRanking => 'Рейтинг';

  @override
  String get navProfile => 'Профиль';

  @override
  String get tabLatest => 'Новые';

  @override
  String get tabFollowing => 'Подписки';

  @override
  String get tabTrending => 'В тренде';

  @override
  String get tabPopularPosts => 'Популярные';

  @override
  String get tabLikes => 'Лайки';

  @override
  String get tabLevel => 'Уровень';

  @override
  String get tabFollowers => 'Подписчики';

  @override
  String get newPost => 'Новая запись';

  @override
  String get enterText => 'Введите текст';

  @override
  String get cancel => 'Отмена';

  @override
  String get post => 'Опубликовать';

  @override
  String posted(String text) {
    return 'Опубликовано: $text';
  }

  @override
  String get followed => 'Подписан';

  @override
  String get follow => 'Подписаться';

  @override
  String get editProfile => 'Редактировать профиль';

  @override
  String get name => 'Имя';

  @override
  String get bio => 'О себе';

  @override
  String get url => 'URL';

  @override
  String get save => 'Сохранить';

  @override
  String get logout => 'Выйти';

  @override
  String get profileSaved => 'Профиль сохранён';

  @override
  String get loggedOut => 'Вы вышли';

  @override
  String get totalLikes => 'Всего лайков';

  @override
  String get level => 'Уровень';

  @override
  String get myRanking => 'Мой рейтинг';

  @override
  String get following => 'Подписки';

  @override
  String get followers => 'Подписчики';

  @override
  String get status => 'Статус';

  @override
  String get statusActive => 'Активен';

  @override
  String get likedPosts => 'Понравившиеся';

  @override
  String likesCount(String count) {
    return '$count лайков';
  }

  @override
  String viewingUserPosts(String user) {
    return 'Записи $user';
  }

  @override
  String get sourceLatest => 'Новые';

  @override
  String get sourceFollowing => 'Подписки';

  @override
  String get sourceTrending => 'В тренде';

  @override
  String get sourceLiked => 'Понравилось';

  @override
  String minutesAgo(int count) {
    return '$countм назад';
  }

  @override
  String hoursAgo(int count) {
    return '$countч назад';
  }

  @override
  String get yesterday => 'Вчера';

  @override
  String daysAgo(int count) {
    return '$countд назад';
  }

  @override
  String followersCount(String count) {
    return '$count подписчиков';
  }

  @override
  String levelDisplay(int level) {
    return 'Ур.$level';
  }

  @override
  String userPost(String user) {
    return 'Запись $user';
  }

  @override
  String get liked => 'Понравилось!';

  @override
  String get loginRequired => 'Войдите в систему';

  @override
  String get login => 'Вход';

  @override
  String get register => 'Регистрация';

  @override
  String get email => 'Эл. почта';

  @override
  String get password => 'Пароль';

  @override
  String get username => 'Имя пользователя';

  @override
  String get displayName => 'Отображаемое имя';

  @override
  String get confirmPassword => 'Подтвердите пароль';

  @override
  String get alreadyHaveAccount => 'Уже есть аккаунт?';

  @override
  String get dontHaveAccount => 'Нет аккаунта?';

  @override
  String get orContinueWith => 'Или продолжить с';

  @override
  String get signInWithGoogle => 'Войти через Google';

  @override
  String get unfollow => 'Отписаться';

  @override
  String get unfollowed => 'Отписались';

  @override
  String get loading => 'Загрузка...';

  @override
  String get error => 'Произошла ошибка';

  @override
  String get retry => 'Повторить';

  @override
  String get noPostsYet => 'Пока нет записей';

  @override
  String get noPosts => 'Нет записей';

  @override
  String get appTitle => 'Short App';

  @override
  String get loginDescription => 'Делитесь моментами со всем миром';

  @override
  String levelUp(int level) {
    return 'Повышение уровня! Вы достигли Lv.$level!';
  }

  @override
  String get noFollowing => 'Нет подписок';

  @override
  String get noFollowers => 'Нет подписчиков';
}
