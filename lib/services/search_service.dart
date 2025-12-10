import '../models/models.dart';
import 'api_client.dart';

class SearchService {
  final ApiClient _client;

  SearchService(this._client);

  Future<PaginatedResponse<User>> searchUsers(
    String query, {
    String? cursor,
    int pageSize = 20,
  }) async {
    if (query.isEmpty) {
      return const PaginatedResponse(count: 0, results: []);
    }
    final response = await _client.get<Map<String, dynamic>>(
      '/api/search/users/',
      queryParameters: {
        'q': query,
        if (cursor != null) 'cursor': cursor,
        'page_size': pageSize,
      },
    );
    return PaginatedResponse.fromJson(response.data!, User.fromJson);
  }

  Future<PaginatedResponse<Post>> searchPosts(
    String query, {
    String? cursor,
    int pageSize = 20,
  }) async {
    if (query.isEmpty) {
      return const PaginatedResponse(count: 0, results: []);
    }
    final response = await _client.get<Map<String, dynamic>>(
      '/api/search/posts/',
      queryParameters: {
        'q': query,
        if (cursor != null) 'cursor': cursor,
        'page_size': pageSize,
      },
    );
    return PaginatedResponse.fromJson(response.data!, Post.fromJson);
  }
}
