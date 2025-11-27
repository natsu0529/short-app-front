import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/services.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient.instance;
});

final authServiceProvider = Provider<AuthService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthService(apiClient: apiClient);
});

final userServiceProvider = Provider<UserService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserService(apiClient);
});

final postServiceProvider = Provider<PostService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PostService(apiClient);
});

final timelineServiceProvider = Provider<TimelineService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TimelineService(apiClient);
});

final likeServiceProvider = Provider<LikeService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return LikeService(apiClient);
});

final followServiceProvider = Provider<FollowService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FollowService(apiClient);
});

final searchServiceProvider = Provider<SearchService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SearchService(apiClient);
});

final rankingServiceProvider = Provider<RankingService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return RankingService(apiClient);
});
