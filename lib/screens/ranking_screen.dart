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

class _RankingScreenState extends ConsumerState<RankingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(rankingProvider.notifier).loadAllRankings();
    });
  }

  void _openUserProfile(User user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProfileDetailScreen(userId: user.userId),
      ),
    );
  }

  void _openPostAuthorProfile(Post post) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProfileDetailScreen(userId: post.user.userId),
      ),
    );
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

    return DefaultTabController(
      length: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MonochromeTabBar(
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
                : TabBarView(
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
                      ),
                    ],
                  ),
          ),
        ],
      ),
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
  });

  final List<User> users;
  final String Function(User) metricBuilder;
  final ValueChanged<User>? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (users.isEmpty) {
      return Center(child: Text(l10n.noPosts));
    }

    return ListView.separated(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.userName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.handle,
                        style: MonoText.label,
                      ),
                    ],
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
    );
  }
}
