import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/services.dart';
import 'service_providers.dart';

class PostState {
  final bool isCreating;
  final Post? lastCreatedPost;
  final String? error;

  const PostState({
    this.isCreating = false,
    this.lastCreatedPost,
    this.error,
  });

  PostState copyWith({
    bool? isCreating,
    Post? lastCreatedPost,
    String? error,
    bool clearError = false,
    bool clearLastPost = false,
  }) {
    return PostState(
      isCreating: isCreating ?? this.isCreating,
      lastCreatedPost: clearLastPost ? null : (lastCreatedPost ?? this.lastCreatedPost),
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class PostNotifier extends StateNotifier<PostState> {
  final PostService _postService;

  PostNotifier(this._postService) : super(const PostState());

  Future<Post?> createPost(String content) async {
    state = state.copyWith(isCreating: true, clearError: true);
    try {
      final post = await _postService.createPost(content);
      state = state.copyWith(
        isCreating: false,
        lastCreatedPost: post,
      );
      return post;
    } catch (e) {
      state = state.copyWith(
        isCreating: false,
        error: e.toString(),
      );
      return null;
    }
  }

  Future<void> deletePost(int postId) async {
    try {
      await _postService.deletePost(postId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearLastPost() {
    state = state.copyWith(clearLastPost: true);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final postProvider = StateNotifierProvider<PostNotifier, PostState>((ref) {
  final postService = ref.watch(postServiceProvider);
  return PostNotifier(postService);
});

// Provider for fetching a user's posts
final userPostsProvider =
    FutureProvider.family<List<Post>, int>((ref, userId) async {
  final postService = ref.watch(postServiceProvider);
  final response = await postService.getPosts(userId: userId);
  return response.results;
});
