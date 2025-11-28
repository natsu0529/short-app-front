import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/services.dart';
import 'service_providers.dart';

class TimelineState {
  final List<Post> posts;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int currentPage;
  final bool hasMore;
  final TimelineTab currentTab;

  const TimelineState({
    this.posts = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
    this.currentTab = TimelineTab.latest,
  });

  TimelineState copyWith({
    List<Post>? posts,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? currentPage,
    bool? hasMore,
    TimelineTab? currentTab,
    bool clearError = false,
  }) {
    return TimelineState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : (error ?? this.error),
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      currentTab: currentTab ?? this.currentTab,
    );
  }
}

class TimelineNotifier extends StateNotifier<TimelineState> {
  final TimelineService _timelineService;
  final LikeService _likeService;

  TimelineNotifier(this._timelineService, this._likeService)
      : super(const TimelineState());

  Future<void> loadTimeline({TimelineTab? tab, bool refresh = false}) async {
    final targetTab = tab ?? state.currentTab;

    if (refresh || tab != state.currentTab) {
      state = state.copyWith(
        isLoading: true,
        clearError: true,
        currentTab: targetTab,
        currentPage: 1,
      );
    }

    try {
      final response = await _timelineService.getTimeline(
        tab: targetTab,
        page: 1,
      );
      state = state.copyWith(
        posts: response.results,
        isLoading: false,
        currentPage: 1,
        hasMore: response.hasNext,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;
      final response = await _timelineService.getTimeline(
        tab: state.currentTab,
        page: nextPage,
      );
      state = state.copyWith(
        posts: [...state.posts, ...response.results],
        isLoadingMore: false,
        currentPage: nextPage,
        hasMore: response.hasNext,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  Future<void> likePost(int postId) async {
    try {
      final like = await _likeService.createLike(postId);
      state = state.copyWith(
        posts: state.posts.map((post) {
          if (post.postId == postId) {
            return post.copyWith(
              isLiked: true,
              likeCount: post.likeCount + 1,
              likeId: like.id,
            );
          }
          return post;
        }).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> unlikePost(int postId, int likeId) async {
    try {
      await _likeService.deleteLike(likeId);
      state = state.copyWith(
        posts: state.posts.map((post) {
          if (post.postId == postId) {
            return post.copyWith(
              isLiked: false,
              likeCount: post.likeCount - 1,
              likeId: null,
            );
          }
          return post;
        }).toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void addNewPost(Post post) {
    if (state.currentTab == TimelineTab.latest) {
      // 最新タブ: 一番上に追加
      state = state.copyWith(
        posts: [post, ...state.posts],
      );
    } else if (state.currentTab == TimelineTab.popular) {
      // トレンドタブ: いいね0なので一番下に追加
      state = state.copyWith(
        posts: [...state.posts, post],
      );
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final timelineProvider =
    StateNotifierProvider<TimelineNotifier, TimelineState>((ref) {
  final timelineService = ref.watch(timelineServiceProvider);
  final likeService = ref.watch(likeServiceProvider);
  return TimelineNotifier(timelineService, likeService);
});
