import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';

class ProfileDetailScreen extends ConsumerStatefulWidget {
  const ProfileDetailScreen({super.key, required this.userId});

  final int userId;

  @override
  ConsumerState<ProfileDetailScreen> createState() =>
      _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends ConsumerState<ProfileDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = ref.read(currentUserProvider);
      ref.read(profileProvider.notifier).loadProfile(
            widget.userId,
            currentUserId: currentUser?.userId,
          );
    });
  }

  void _handleFollow() {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.loginRequired),
          backgroundColor: Colors.black,
        ),
      );
      return;
    }

    final state = ref.read(profileProvider);
    if (state.isFollowing == true && state.followId != null) {
      ref
          .read(profileProvider.notifier)
          .unfollow(state.followId!, widget.userId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.unfollowed),
          backgroundColor: Colors.black,
        ),
      );
    } else {
      ref
          .read(profileProvider.notifier)
          .follow(currentUser.userId, widget.userId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.followed),
          backgroundColor: Colors.black,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);
    final currentUser = ref.watch(currentUserProvider);
    final l10n = AppLocalizations.of(context)!;
    final isOwnProfile = currentUser?.userId == widget.userId;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          state.user?.userName ?? l10n.loading,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.black),
            )
          : state.user == null
              ? Center(
                  child: Text(l10n.error),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProfileHeader(
                        user: state.user!,
                        showFollowButton: !isOwnProfile,
                        isFollowing: state.isFollowing ?? false,
                        onFollowTap: _handleFollow,
                      ),
                      const SizedBox(height: 16),
                      _ProfileStats(user: state.user!),
                      const SizedBox(height: 24),
                      Text(
                        l10n.likedPosts,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (state.isLoadingLikedPosts)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child:
                                CircularProgressIndicator(color: Colors.black),
                          ),
                        )
                      else if (state.likedPosts.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(l10n.noPosts),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.likedPosts.length,
                          itemBuilder: (context, index) {
                            final post = state.likedPosts[index];
                            return PostCard(
                              post: post,
                              source: 'Liked',
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                        ),
                    ],
                  ),
                ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.user,
    this.showFollowButton = false,
    this.isFollowing = false,
    this.onFollowTap,
  });

  final User user;
  final bool showFollowButton;
  final bool isFollowing;
  final VoidCallback? onFollowTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MonoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  user.userName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ),
              if (showFollowButton)
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isFollowing ? Colors.white : Colors.black,
                    backgroundColor:
                        isFollowing ? Colors.black : Colors.transparent,
                    side: const BorderSide(color: Colors.black, width: 1.2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                  ),
                  onPressed: onFollowTap,
                  child: Text(
                    isFollowing ? l10n.unfollow : l10n.follow,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              else
                LevelIndicator(
                  level: user.userLevel,
                  exp: user.stats?.experiencePoints ?? 0,
                  maxExp: _calculateMaxExp(user.userLevel),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            user.userBio,
            style: MonoText.body,
          ),
          if (user.userUrl.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              user.userUrl,
              style: const TextStyle(
                fontSize: 13,
                decoration: TextDecoration.underline,
                color: Colors.black,
              ),
            ),
          ],
        ],
      ),
    );
  }

  int _calculateMaxExp(int level) {
    if (level <= 1) return 10;
    if (level <= 2) return 30;
    if (level <= 3) return 60;
    if (level <= 4) return 100;
    if (level <= 10) return 100 + (level - 5) * 50;
    if (level <= 20) return 350 + (level - 10) * 100;
    if (level <= 50) return 1350 + (level - 20) * 200;
    if (level <= 100) return 7350 + (level - 50) * 300;
    return 22350 + (level - 100) * 500;
  }
}

class _ProfileStats extends StatelessWidget {
  const _ProfileStats({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MonoCard(
      child: Row(
        children: [
          _StatBlock(
            label: l10n.totalLikes,
            value: '${user.stats?.totalLikesReceived ?? 0}',
          ),
          _StatBlock(
            label: l10n.level,
            value: l10n.levelDisplay(user.userLevel),
          ),
          _StatBlock(
            label: l10n.followers,
            value: '${user.stats?.followerCount ?? 0}',
          ),
        ],
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
