import '../models/models.dart';
import 'api_client.dart';

class UserService {
  final ApiClient _client;

  UserService(this._client);

  Future<PaginatedResponse<User>> getUsers({
    String? cursor,
    int pageSize = 20,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/api/users/',
      queryParameters: {
        if (cursor != null) 'cursor': cursor,
        'page_size': pageSize,
      },
    );
    return PaginatedResponse.fromJson(response.data!, User.fromJson);
  }

  Future<User> getUser(int userId) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/api/users/$userId/',
    );
    return User.fromJson(response.data!);
  }

  Future<User> getCurrentUser() async {
    final response = await _client.get<Map<String, dynamic>>(
      '/api/users/me/',
    );
    return User.fromJson(response.data!);
  }

  Future<User> createUser({
    required String username,
    required String userName,
    required String email,
    required String password,
    String? userUrl,
    String? userBio,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/api/users/',
      data: {
        'username': username,
        'user_name': userName,
        'user_mail': email,
        'password': password,
        if (userUrl != null) 'user_URL': userUrl,
        if (userBio != null) 'user_bio': userBio,
      },
    );
    return User.fromJson(response.data!);
  }

  Future<User> updateUser(
    int userId, {
    String? userName,
    String? userUrl,
    String? userBio,
  }) async {
    final response = await _client.patch<Map<String, dynamic>>(
      '/api/users/$userId/',
      data: {
        if (userName != null) 'user_name': userName,
        if (userUrl != null) 'user_URL': userUrl,
        if (userBio != null) 'user_bio': userBio,
      },
    );
    return User.fromJson(response.data!);
  }

  Future<void> deleteUser(int userId) async {
    await _client.delete('/api/users/$userId/');
  }
}
