import '../models/models.dart';
import 'api_client.dart';

enum TimelineTab {
  latest,
  popular,
  following,
}

class TimelineService {
  final ApiClient _client;

  TimelineService(this._client);

  Future<PaginatedResponse<Post>> getTimeline({
    TimelineTab tab = TimelineTab.latest,
    String? cursor,
    int pageSize = 20,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/api/timeline/',
      queryParameters: {
        'tab': tab.name,
        if (cursor != null) 'cursor': cursor,
        'page_size': pageSize,
      },
    );
    return PaginatedResponse.fromJson(response.data!, Post.fromJson);
  }
}
