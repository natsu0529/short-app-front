import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';
import 'profile_detail_screen.dart';

class RankingScreen extends ConsumerStatefulWidget {
  const RankingScreen({super.key});

  @override
  ConsumerState<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends ConsumerState<RankingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _likesScrollController = ScrollController();
  final ScrollController _levelScrollController = ScrollController();
  final ScrollController _followersScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(rankingProvider.notifier).loadAllRankings();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _likesScrollController.dispose();
    _levelScrollController.dispose();
    _followersScrollController.dispose();
    super.dispose();
  }

  void _scrollToMyRanking() {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    final state = ref.read(rankingProvider);

    // Likesタブ（インデックス1）に切り替え
    _tabController.animateTo(1);

    // ユーザーの位置を見つける
    final userIndex = state.totalLikesUsers.indexWhere(
      (user) => user.userId == currentUser.userId,
    );

    if (userIndex != -1) {
      // 少し遅延してからスクロール（タブ切り替えのアニメーション後）
      Future.delayed(const Duration(milliseconds: 350), () {
        const itemHeight = 80.0; // おおよそのアイテムの高さ
        final offset = userIndex * itemHeight;
        _likesScrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
        );
      });
    }

    // フラグをクリア
    ref.read(navigationProvider.notifier).clearScrollToMyRanking();
  }

  void _openUserProfile(User user) {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser != null && currentUser.userId == user.userId) {
      // 自分の場合はプロフィールタブに遷移
      ref.read(navigationProvider.notifier).setIndex(2);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProfileDetailScreen(userId: user.userId),
        ),
      );
    }
  }

  void _openPostAuthorProfile(Post post) {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser != null && currentUser.userId == post.user.userId) {
      // 自分の場合はプロフィールタブに遷移
      ref.read(navigationProvider.notifier).setIndex(2);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProfileDetailScreen(userId: post.user.userId),
        ),
      );
    }
  }

  String _formatMetric(BuildContext context, String type, dynamic value) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case 'likes':
        final count = value as int;
        if (count >= 1000) {
          return l10n.likesCount('${(count / 1000).toStringAsFixed(1)}k');
        }
        return l10n.likesCount(count.toString());
      case 'level':
        return l10n.levelDisplay(value as int);
      case 'followers':
        final count = value as int;
        if (count >= 1000) {
          return l10n.followersCount('${(count / 1000).toStringAsFixed(1)}k');
        }
        return l10n.followersCount(count.toString());
      default:
        return value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rankingProvider);
    final l10n = AppLocalizations.of(context)!;

    // スクロールフラグをリッスン
    ref.listen<NavigationState>(navigationProvider, (previous, next) {
      if (next.scrollToMyRanking && !(previous?.scrollToMyRanking ?? false)) {
        // ランキングデータがロード済みの場合はスクロール
        if (!state.isLoading) {
          _scrollToMyRanking();
        }
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MonochromeTabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.tabPopularPosts),
            Tab(text: l10n.tabLikes),
            Tab(text: l10n.tabLevel),
            Tab(text: l10n.tabFollowers),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: state.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                )
              : state.error != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 48, color: Colors.black54),
                            const SizedBox(height: 16),
                            const Text(
                              'Error loading rankings',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.error!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => ref.read(rankingProvider.notifier).loadAllRankings(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        // Popular Posts
                        _PostRankingList(
                          posts: state.popularPosts,
                          onTap: _openPostAuthorProfile,
                        ),
                        // Total Likes
                        _UserRankingList(
                          users: state.totalLikesUsers,
                          metricBuilder: (user) => _formatMetric(
                            context,
                            'likes',
                            user.stats?.totalLikesReceived ?? 0,
                          ),
                          onTap: _openUserProfile,
                          scrollController: _likesScrollController,
                        ),
                        // Level
                        _UserRankingList(
                          users: state.levelUsers,
                          metricBuilder: (user) => _formatMetric(
                            context,
                            'level',
                            user.userLevel,
                          ),
                          onTap: _openUserProfile,
                          scrollController: _levelScrollController,
                        ),
                        // Followers
                        _UserRankingList(
                          users: state.followersUsers,
                          metricBuilder: (user) => _formatMetric(
                            context,
                            'followers',
                            user.stats?.followerCount ?? 0,
                          ),
                          onTap: _openUserProfile,
                          scrollController: _followersScrollController,
                        ),
                      ],
                    ),
        ),
      ],
    );
  }
}

class _PostRankingList extends StatelessWidget {
  const _PostRankingList({
    required this.posts,
    this.onTap,
  });

  final List<Post> posts;
  final ValueChanged<Post>? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (posts.isEmpty) {
      return Center(child: Text(l10n.noPosts));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return GestureDetector(
          onTap: onTap != null ? () => onTap!(post) : null,
          child: MonoCard(
            radius: 14,
            child: Row(
              children: [
                RankBadge(position: index + 1),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.userPost(post.user.userName),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        post.context,
                        style: MonoText.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text(
                  l10n.likesCount(post.likeCount.toString()),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }
}

class _UserRankingList extends StatelessWidget {
  const _UserRankingList({
    required this.users,
    required this.metricBuilder,
    this.onTap,
    this.scrollController,
  });

  final List<User> users;
  final String Function(User) metricBuilder;
  final ValueChanged<User>? onTap;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (users.isEmpty) {
      return Container(
        color: Colors.white,
        child: Center(child: Text(l10n.noPosts)),
      );
    }

    return Container(
      color: Colors.white,
      child: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return GestureDetector(
          onTap: onTap != null ? () => onTap!(user) : null,
          child: MonoCard(
            radius: 14,
            child: Row(
              children: [
                RankBadge(position: index + 1),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    user.userName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  metricBuilder(user),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 12),
      ),
    );
  }
}
