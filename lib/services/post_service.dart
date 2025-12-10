import '../models/models.dart';
import 'api_client.dart';

class PostService {
  final ApiClient _client;

  PostService(this._client);

  Future<PaginatedResponse<Post>> getPosts({
    int? userId,
    String? cursor,
    int pageSize = 20,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/api/posts/',
      queryParameters: {
        if (userId != null) 'user_id': userId,
        if (cursor != null) 'cursor': cursor,
        'page_size': pageSize,
      },
    );
    return PaginatedResponse.fromJson(response.data!, Post.fromJson);
  }

  Future<Post> getPost(int postId) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/api/posts/$postId/',
    );
    return Post.fromJson(response.data!);
  }

  Future<Post> createPost(String content) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/api/posts/',
      data: {
        'context': content,
      },
    );
    return Post.fromJson(response.data!);
  }

  Future<Post> updatePost(int postId, String content) async {
    final response = await _client.patch<Map<String, dynamic>>(
      '/api/posts/$postId/',
      data: {
        'context': content,
      },
    );
    return Post.fromJson(response.data!);
  }

  Future<void> deletePost(int postId) async {
    await _client.delete('/api/posts/$postId/');
  }

  Future<List<int>> getLikedPostIds(List<int> postIds) async {
    if (postIds.isEmpty) return [];
    final response = await _client.get<Map<String, dynamic>>(
      '/api/posts/liked-status/',
      queryParameters: {
        'ids': postIds.join(','),
      },
    );
    return (response.data!['liked_post_ids'] as List<dynamic>)
        .map((e) => e as int)
        .toList();
  }
}
