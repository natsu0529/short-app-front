// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get navTimeline => 'Fil d\'actualité';

  @override
  String get navRanking => 'Classement';

  @override
  String get navProfile => 'Profil';

  @override
  String get tabLatest => 'Récents';

  @override
  String get tabFollowing => 'Abonnements';

  @override
  String get tabTrending => 'Tendances';

  @override
  String get tabPopularPosts => 'Populaires';

  @override
  String get tabLikes => 'J\'aime';

  @override
  String get tabLevel => 'Niveau';

  @override
  String get tabFollowers => 'Abonnés';

  @override
  String get newPost => 'Nouvelle publication';

  @override
  String get enterText => 'Saisissez du texte';

  @override
  String get cancel => 'Annuler';

  @override
  String get post => 'Publier';

  @override
  String posted(String text) {
    return 'Publié: $text';
  }

  @override
  String get followed => 'Abonné';

  @override
  String get follow => 'S\'abonner';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get name => 'Nom';

  @override
  String get bio => 'Bio';

  @override
  String get url => 'URL';

  @override
  String get save => 'Enregistrer';

  @override
  String get logout => 'Déconnexion';

  @override
  String get profileSaved => 'Profil enregistré';

  @override
  String get loggedOut => 'Déconnecté';

  @override
  String get totalLikes => 'Total des j\'aime';

  @override
  String get level => 'Niveau';

  @override
  String get myRanking => 'Mon classement';

  @override
  String get following => 'Abonnements';

  @override
  String get followers => 'Abonnés';

  @override
  String get status => 'Statut';

  @override
  String get statusActive => 'Actif';

  @override
  String get likedPosts => 'Publications aimées';

  @override
  String likesCount(String count) {
    return '$count j\'aime';
  }

  @override
  String viewingUserPosts(String user) {
    return 'Publications de $user';
  }

  @override
  String get sourceLatest => 'Récents';

  @override
  String get sourceFollowing => 'Abonnements';

  @override
  String get sourceTrending => 'Tendances';

  @override
  String get sourceLiked => 'Aimées';

  @override
  String minutesAgo(int count) {
    return 'il y a ${count}m';
  }

  @override
  String hoursAgo(int count) {
    return 'il y a ${count}h';
  }

  @override
  String get yesterday => 'Hier';

  @override
  String daysAgo(int count) {
    return 'il y a ${count}j';
  }

  @override
  String followersCount(String count) {
    return '$count abonnés';
  }

  @override
  String levelDisplay(int level) {
    return 'Nv.$level';
  }

  @override
  String userPost(String user) {
    return 'Publication de $user';
  }

  @override
  String get liked => 'Aimé !';

  @override
  String get loginRequired => 'Veuillez vous connecter';

  @override
  String get login => 'Connexion';

  @override
  String get register => 'S\'inscrire';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get displayName => 'Nom affiché';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get alreadyHaveAccount => 'Déjà un compte ?';

  @override
  String get dontHaveAccount => 'Pas de compte ?';

  @override
  String get orContinueWith => 'Ou continuer avec';

  @override
  String get signInWithGoogle => 'Se connecter avec Google';

  @override
  String get unfollow => 'Se désabonner';

  @override
  String get unfollowed => 'Désabonné';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Une erreur est survenue';

  @override
  String get retry => 'Réessayer';

  @override
  String get noPostsYet => 'Aucune publication';

  @override
  String get noPosts => 'Pas de publications';
}
