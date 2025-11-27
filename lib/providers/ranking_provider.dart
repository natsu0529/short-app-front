import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/services.dart';
import 'service_providers.dart';

enum RankingType {
  popularPosts,
  totalLikes,
  level,
  followers,
}

class RankingState {
  final List<Post> popularPosts;
  final List<User> totalLikesUsers;
  final List<User> levelUsers;
  final List<User> followersUsers;
  final bool isLoading;
  final String? error;
  final RankingType currentType;

  const RankingState({
    this.popularPosts = const [],
    this.totalLikesUsers = const [],
    this.levelUsers = const [],
    this.followersUsers = const [],
    this.isLoading = false,
    this.error,
    this.currentType = RankingType.popularPosts,
  });

  RankingState copyWith({
    List<Post>? popularPosts,
    List<User>? totalLikesUsers,
    List<User>? levelUsers,
    List<User>? followersUsers,
    bool? isLoading,
    String? error,
    RankingType? currentType,
    bool clearError = false,
  }) {
    return RankingState(
      popularPosts: popularPosts ?? this.popularPosts,
      totalLikesUsers: totalLikesUsers ?? this.totalLikesUsers,
      levelUsers: levelUsers ?? this.levelUsers,
      followersUsers: followersUsers ?? this.followersUsers,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      currentType: currentType ?? this.currentType,
    );
  }
}

class RankingNotifier extends StateNotifier<RankingState> {
  final RankingService _rankingService;
  final LikeService _likeService;

  RankingNotifier(this._rankingService, this._likeService)
      : super(const RankingState());

  Future<void> loadAllRankings() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final results = await Future.wait([
        _rankingService.getPostLikesRanking(last24Hours: true),
        _rankingService.getUserTotalLikesRanking(),
        _rankingService.getUserLevelRanking(),
        _rankingService.getUserFollowersRanking(),
      ]);

      state = state.copyWith(
        popularPosts: (results[0] as PaginatedResponse<Post>).results,
        totalLikesUsers: (results[1] as PaginatedResponse<User>).results,
        levelUsers: (results[2] as PaginatedResponse<User>).results,
        followersUsers: (results[3] as PaginatedResponse<User>).results,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadPopularPosts({bool last24Hours = true}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await _rankingService.getPostLikesRanking(
        last24Hours: last24Hours,
      );
      state = state.copyWith(
        popularPosts: response.results,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadTotalLikesRanking() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await _rankingService.getUserTotalLikesRanking();
      state = state.copyWith(
        totalLikesUsers: response.results,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadLevelRanking() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await _rankingService.getUserLevelRanking();
      state = state.copyWith(
        levelUsers: response.results,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadFollowersRanking() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await _rankingService.getUserFollowersRanking();
      state = state.copyWith(
        followersUsers: response.results,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> likePost(int postId) async {
    try {
      await _likeService.createLike(postId);
      state = state.copyWith(
        popularPosts: state.popularPosts.map((post) {
          if (post.postId == postId) {
            return post.copyWith(
              isLiked: true,
              likeCount: post.likeCount + 1,
            );
          }
          return post;
        }).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void setCurrentType(RankingType type) {
    state = state.copyWith(currentType: type);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final rankingProvider =
    StateNotifierProvider<RankingNotifier, RankingState>((ref) {
  final rankingService = ref.watch(rankingServiceProvider);
  final likeService = ref.watch(likeServiceProvider);
  return RankingNotifier(rankingService, likeService);
});
