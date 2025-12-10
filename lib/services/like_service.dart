import '../models/models.dart';
import 'api_client.dart';

class LikeService {
  final ApiClient _client;

  LikeService(this._client);

  Future<PaginatedResponse<Like>> getLikes({
    int? userId,
    int? postId,
    String? cursor,
    int pageSize = 20,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/api/likes/',
      queryParameters: {
        if (userId != null) 'user_id': userId,
        if (postId != null) 'post_id': postId,
        if (cursor != null) 'cursor': cursor,
        'page_size': pageSize,
      },
    );
    return PaginatedResponse.fromJson(response.data!, Like.fromJson);
  }

  Future<Like> createLike(int postId) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/api/likes/',
      data: {
        'post_id': postId,
      },
    );
    return Like.fromJson(response.data!);
  }

  Future<void> deleteLike(int likeId) async {
    await _client.delete('/api/likes/$likeId/');
  }

  Future<PaginatedResponse<Post>> getUserLikedPosts(
    int userId, {
    String? cursor,
    int pageSize = 20,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/api/users/$userId/liked-posts/',
      queryParameters: {
        if (cursor != null) 'cursor': cursor,
        'page_size': pageSize,
      },
    );
    return PaginatedResponse.fromJson(response.data!, Post.fromJson);
  }
}
