import '../models/models.dart';
import 'api_client.dart';

class LikeService {
  final ApiClient _client;

  LikeService(this._client);

  Future<PaginatedResponse<Like>> getLikes({
    int? userId,
    int? postId,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/api/likes/',
      queryParameters: {
        if (userId != null) 'user_id': userId,
        if (postId != null) 'post_id': postId,
        'page': page,
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
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/api/users/$userId/liked-posts/',
      queryParameters: {
        'page': page,
        'page_size': pageSize,
      },
    );
    return PaginatedResponse.fromJson(response.data!, Post.fromJson);
  }
}
