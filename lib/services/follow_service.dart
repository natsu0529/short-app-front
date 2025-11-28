import '../models/models.dart';
import 'api_client.dart';

class FollowService {
  final ApiClient _client;

  FollowService(this._client);

  Future<List<Follow>> getFollows({
    int? userId,
    int? aimUserId,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _client.get<dynamic>(
      '/api/follows/',
      queryParameters: {
        if (userId != null) 'user_id': userId,
        if (aimUserId != null) 'aim_user_id': aimUserId,
        'page': page,
        'page_size': pageSize,
      },
    );
    print('FollowService.getFollows response: ${response.data}');

    // Handle both list and paginated response formats
    if (response.data is List) {
      return (response.data as List)
          .map((item) => Follow.fromJson(item as Map<String, dynamic>))
          .toList();
    } else if (response.data is Map<String, dynamic>) {
      final paginatedResponse =
          PaginatedResponse.fromJson(response.data!, Follow.fromJson);
      return paginatedResponse.results;
    }
    return [];
  }

  Future<Follow> createFollow(int aimUserId) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/api/follows/',
      data: {
        'aim_user_id': aimUserId,
      },
    );
    return Follow.fromJson(response.data!);
  }

  Future<void> deleteFollow(int followId) async {
    await _client.delete('/api/follows/$followId/');
  }

  Future<List<User>> getFollowing(int userId, {int page = 1, int pageSize = 100}) async {
    final follows = await getFollows(userId: userId, page: page, pageSize: pageSize);
    return follows.map((f) => f.aimUser).toList();
  }

  Future<List<User>> getFollowers(int userId, {int page = 1, int pageSize = 100}) async {
    final follows = await getFollows(aimUserId: userId, page: page, pageSize: pageSize);
    return follows.map((f) => f.user).toList();
  }

  Future<bool> isFollowing(int userId, int targetUserId) async {
    final follows = await getFollows(userId: userId, aimUserId: targetUserId, pageSize: 1);
    return follows.isNotEmpty;
  }

  Future<Follow?> getFollowRelation(int userId, int targetUserId) async {
    final follows = await getFollows(userId: userId, aimUserId: targetUserId, pageSize: 1);
    return follows.isNotEmpty ? follows.first : null;
  }
}
