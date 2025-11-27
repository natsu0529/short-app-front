import '../models/models.dart';
import 'api_client.dart';

class FollowService {
  final ApiClient _client;

  FollowService(this._client);

  Future<PaginatedResponse<Follow>> getFollows({
    int? userId,
    int? aimUserId,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/api/follows/',
      queryParameters: {
        if (userId != null) 'user_id': userId,
        if (aimUserId != null) 'aim_user_id': aimUserId,
        'page': page,
        'page_size': pageSize,
      },
    );
    return PaginatedResponse.fromJson(response.data!, Follow.fromJson);
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
    final response = await getFollows(userId: userId, page: page, pageSize: pageSize);
    return response.results.map((f) => f.aimUser).toList();
  }

  Future<List<User>> getFollowers(int userId, {int page = 1, int pageSize = 100}) async {
    final response = await getFollows(aimUserId: userId, page: page, pageSize: pageSize);
    return response.results.map((f) => f.user).toList();
  }

  Future<bool> isFollowing(int userId, int targetUserId) async {
    final response = await getFollows(userId: userId, aimUserId: targetUserId, pageSize: 1);
    return response.results.isNotEmpty;
  }

  Future<Follow?> getFollowRelation(int userId, int targetUserId) async {
    final response = await getFollows(userId: userId, aimUserId: targetUserId, pageSize: 1);
    return response.results.isNotEmpty ? response.results.first : null;
  }
}
