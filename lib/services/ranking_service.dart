import '../models/models.dart';
import 'api_client.dart';

class RankingService {
  final ApiClient _client;

  RankingService(this._client);

  Future<PaginatedResponse<Post>> getPostLikesRanking({
    bool last24Hours = false,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/api/rankings/posts/likes/',
      queryParameters: {
        if (last24Hours) 'range': '24h',
        'page': page,
        'page_size': pageSize,
      },
    );
    return PaginatedResponse.fromJson(response.data!, Post.fromJson);
  }

  Future<PaginatedResponse<User>> getUserTotalLikesRanking({
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/api/rankings/users/total-likes/',
      queryParameters: {
        'page': page,
        'page_size': pageSize,
      },
    );
    return PaginatedResponse.fromJson(response.data!, User.fromJson);
  }

  Future<PaginatedResponse<User>> getUserLevelRanking({
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/api/rankings/users/level/',
      queryParameters: {
        'page': page,
        'page_size': pageSize,
      },
    );
    return PaginatedResponse.fromJson(response.data!, User.fromJson);
  }

  Future<PaginatedResponse<User>> getUserFollowersRanking({
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/api/rankings/users/followers/',
      queryParameters: {
        'page': page,
        'page_size': pageSize,
      },
    );
    return PaginatedResponse.fromJson(response.data!, User.fromJson);
  }
}
