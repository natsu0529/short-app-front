import '../models/models.dart';
import 'api_client.dart';

class FollowService {
  final ApiClient _client;

  FollowService(this._client);

  Future<PaginatedResponse<Follow>> getFollows({
    int? userId,
    int? aimUserId,
    String? cursor,
    int pageSize = 20,
  }) async {
    final response = await _client.get<dynamic>(
      '/api/follows/',
      queryParameters: {
        if (userId != null) 'user_id': userId,
        if (aimUserId != null) 'aim_user_id': aimUserId,
        if (cursor != null) 'cursor': cursor,
        'page_size': pageSize,
      },
    );
    print('FollowService.getFollows response: ${response.data}');

    // Handle both list and paginated response formats
    if (response.data is List) {
      final results = (response.data as List)
          .map((item) => Follow.fromJson(item as Map<String, dynamic>))
          .toList();
      return PaginatedResponse(
        count: results.length,
        results: results,
      );
    } else if (response.data is Map<String, dynamic>) {
      final paginatedResponse =
          PaginatedResponse.fromJson(response.data!, Follow.fromJson);
      return paginatedResponse;
    }
    return const PaginatedResponse(count: 0, results: []);
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

  Future<PaginatedResponse<User>> getFollowing(
    int userId, {
    String? cursor,
    int pageSize = 100,
  }) async {
    final follows = await getFollows(
      userId: userId,
      cursor: cursor,
      pageSize: pageSize,
    );
    return PaginatedResponse(
      count: follows.count,
      next: follows.next,
      previous: follows.previous,
      results: follows.results.map((f) => f.aimUser).toList(),
      currentCursor: follows.currentCursor,
    );
  }

  Future<PaginatedResponse<User>> getFollowers(
    int userId, {
    String? cursor,
    int pageSize = 100,
  }) async {
    final follows = await getFollows(
      aimUserId: userId,
      cursor: cursor,
      pageSize: pageSize,
    );
    return PaginatedResponse(
      count: follows.count,
      next: follows.next,
      previous: follows.previous,
      results: follows.results.map((f) => f.user).toList(),
      currentCursor: follows.currentCursor,
    );
  }

  Future<bool> isFollowing(int userId, int targetUserId) async {
    final follows = await getFollows(
      userId: userId,
      aimUserId: targetUserId,
      pageSize: 1,
    );
    return follows.results.isNotEmpty;
  }

  Future<Follow?> getFollowRelation(int userId, int targetUserId) async {
    final follows = await getFollows(
      userId: userId,
      aimUserId: targetUserId,
      pageSize: 1,
    );
    return follows.results.isNotEmpty ? follows.results.first : null;
  }
}
