import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/services.dart';
import 'service_providers.dart';
import 'auth_provider.dart';

class ProfileState {
  final User? user;
  final List<Post> likedPosts;
  final List<User> following;
  final List<User> followers;
  final bool isLoading;
  final bool isLoadingLikedPosts;
  final bool isLoadingMoreLikedPosts;
  final String? error;
  final bool? isFollowing;
  final int? followId;
  final String? likedNextCursor;
  final bool hasMoreLikedPosts;

  const ProfileState({
    this.user,
    this.likedPosts = const [],
    this.following = const [],
    this.followers = const [],
    this.isLoading = false,
    this.isLoadingLikedPosts = false,
    this.isLoadingMoreLikedPosts = false,
    this.error,
    this.isFollowing,
    this.followId,
    this.likedNextCursor,
    this.hasMoreLikedPosts = true,
  });

  ProfileState copyWith({
    User? user,
    List<Post>? likedPosts,
    List<User>? following,
    List<User>? followers,
    bool? isLoading,
    bool? isLoadingLikedPosts,
    bool? isLoadingMoreLikedPosts,
    String? error,
    bool? isFollowing,
    int? followId,
    String? likedNextCursor,
    bool? hasMoreLikedPosts,
    bool clearError = false,
    bool clearUser = false,
    bool clearFollowId = false,
    bool clearLikedPagination = false,
  }) {
    return ProfileState(
      user: clearUser ? null : (user ?? this.user),
      likedPosts: likedPosts ?? this.likedPosts,
      following: following ?? this.following,
      followers: followers ?? this.followers,
      isLoading: isLoading ?? this.isLoading,
      isLoadingLikedPosts: isLoadingLikedPosts ?? this.isLoadingLikedPosts,
      isLoadingMoreLikedPosts:
          isLoadingMoreLikedPosts ?? this.isLoadingMoreLikedPosts,
      error: clearError ? null : (error ?? this.error),
      isFollowing: isFollowing ?? this.isFollowing,
      followId: clearFollowId ? null : (followId ?? this.followId),
      likedNextCursor:
          clearLikedPagination ? null : (likedNextCursor ?? this.likedNextCursor),
      hasMoreLikedPosts:
          clearLikedPagination ? true : (hasMoreLikedPosts ?? this.hasMoreLikedPosts),
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final UserService _userService;
  final LikeService _likeService;
  final FollowService _followService;

  ProfileNotifier(this._userService, this._likeService, this._followService)
      : super(const ProfileState());

  Future<void> loadProfile(int userId, {int? currentUserId}) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final user = await _userService.getUser(userId);
      state = state.copyWith(user: user, isLoading: false);

      // Check if current user is following this user
      if (currentUserId != null && currentUserId != userId) {
        final follow = await _followService.getFollowRelation(currentUserId, userId);
        state = state.copyWith(
          isFollowing: follow != null,
          followId: follow?.id,
        );
      }

      // Load liked posts
      await loadLikedPosts(userId, refresh: true);

      // Load following/followers
      await loadFollowData(userId);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadLikedPosts(int userId,
      {bool loadMore = false, bool refresh = false}) async {
    if (loadMore) {
      if (state.isLoadingMoreLikedPosts || !state.hasMoreLikedPosts) return;
      state = state.copyWith(isLoadingMoreLikedPosts: true);
    } else {
      state = state.copyWith(
        isLoadingLikedPosts: true,
        clearError: true,
        clearLikedPagination: refresh,
        likedPosts: refresh ? [] : null,
      );
    }
    try {
      final response = await _likeService.getUserLikedPosts(
        userId,
        cursor: loadMore ? state.likedNextCursor : null,
      );
      state = state.copyWith(
        likedPosts: loadMore
            ? [...state.likedPosts, ...response.results]
            : response.results,
        likedNextCursor: response.nextCursor,
        hasMoreLikedPosts: response.hasNext,
        isLoadingLikedPosts: loadMore ? state.isLoadingLikedPosts : false,
        isLoadingMoreLikedPosts: loadMore ? false : state.isLoadingMoreLikedPosts,
      );
    } catch (e) {
      state = state.copyWith(
        isLoadingLikedPosts: false,
        isLoadingMoreLikedPosts: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadFollowData(int userId) async {
    try {
      final results = await Future.wait([
        _followService.getFollowing(userId),
        _followService.getFollowers(userId),
      ]);
      state = state.copyWith(
        following: results[0].results,
        followers: results[1].results,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> follow(int userId, int targetUserId) async {
    try {
      final follow = await _followService.createFollow(targetUserId);
      state = state.copyWith(
        isFollowing: true,
        followId: follow.id,
      );
      // Reload follow data to update counts
      await loadFollowData(targetUserId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> unfollow(int followId, int targetUserId) async {
    try {
      await _followService.deleteFollow(followId);
      state = state.copyWith(
        isFollowing: false,
        clearFollowId: true,
      );
      // Reload follow data to update counts
      await loadFollowData(targetUserId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateProfile({
    required int userId,
    String? userName,
    String? userUrl,
    String? userBio,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _userService.updateUser(
        userId,
        userName: userName,
        userUrl: userUrl,
        userBio: userBio,
      );
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearProfile() {
    state = const ProfileState();
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final profileProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final userService = ref.watch(userServiceProvider);
  final likeService = ref.watch(likeServiceProvider);
  final followService = ref.watch(followServiceProvider);
  return ProfileNotifier(userService, likeService, followService);
});

// Provider to get a specific user's profile
final userProfileProvider =
    FutureProvider.family<User, int>((ref, userId) async {
  final userService = ref.watch(userServiceProvider);
  return userService.getUser(userId);
});

// Provider to get current user's liked posts
final currentUserLikedPostsProvider = FutureProvider<List<Post>>((ref) async {
  final currentUser = ref.watch(currentUserProvider);
  if (currentUser == null) return [];

  final likeService = ref.watch(likeServiceProvider);
  final response = await likeService.getUserLikedPosts(currentUser.userId);
  return response.results;
});
