// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get navTimeline => 'Cronología';

  @override
  String get navRanking => 'Ranking';

  @override
  String get navProfile => 'Perfil';

  @override
  String get tabLatest => 'Recientes';

  @override
  String get tabFollowing => 'Siguiendo';

  @override
  String get tabTrending => 'Tendencias';

  @override
  String get tabPopularPosts => 'Populares';

  @override
  String get tabLikes => 'Me gusta';

  @override
  String get tabLevel => 'Nivel';

  @override
  String get tabFollowers => 'Seguidores';

  @override
  String get newPost => 'Nueva publicación';

  @override
  String get enterText => 'Ingresa texto';

  @override
  String get cancel => 'Cancelar';

  @override
  String get post => 'Publicar';

  @override
  String posted(String text) {
    return 'Publicado: $text';
  }

  @override
  String get followed => 'Siguiendo';

  @override
  String get follow => 'Seguir';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get name => 'Nombre';

  @override
  String get bio => 'Bio';

  @override
  String get url => 'URL';

  @override
  String get save => 'Guardar';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get profileSaved => 'Perfil guardado';

  @override
  String get loggedOut => 'Sesión cerrada';

  @override
  String get totalLikes => 'Total de me gusta';

  @override
  String get level => 'Nivel';

  @override
  String get myRanking => 'Mi ranking';

  @override
  String get following => 'Siguiendo';

  @override
  String get followers => 'Seguidores';

  @override
  String get status => 'Estado';

  @override
  String get statusActive => 'Activo';

  @override
  String get likedPosts => 'Publicaciones favoritas';

  @override
  String likesCount(String count) {
    return '$count me gusta';
  }

  @override
  String viewingUserPosts(String user) {
    return 'Viendo publicaciones de $user';
  }

  @override
  String get sourceLatest => 'Recientes';

  @override
  String get sourceFollowing => 'Siguiendo';

  @override
  String get sourceTrending => 'Tendencias';

  @override
  String get sourceLiked => 'Favoritos';

  @override
  String minutesAgo(int count) {
    return 'hace ${count}m';
  }

  @override
  String hoursAgo(int count) {
    return 'hace ${count}h';
  }

  @override
  String get yesterday => 'Ayer';

  @override
  String daysAgo(int count) {
    return 'hace ${count}d';
  }

  @override
  String followersCount(String count) {
    return '$count seguidores';
  }

  @override
  String levelDisplay(int level) {
    return 'Nv.$level';
  }

  @override
  String userPost(String user) {
    return 'Publicación de $user';
  }

  @override
  String get liked => '¡Me gusta!';
}
