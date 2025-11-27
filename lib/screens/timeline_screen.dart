import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';
import 'profile_detail_screen.dart';

class TimelineScreen extends ConsumerStatefulWidget {
  const TimelineScreen({super.key});

  @override
  ConsumerState<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends ConsumerState<TimelineScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _composerController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(timelineProvider.notifier).loadTimeline();
    });
  }

  @override
  void dispose() {
    _composerController.dispose();
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final tab = TimelineTab.values[_tabController.index];
    ref.read(timelineProvider.notifier).loadTimeline(tab: tab);
  }

  void _openProfileFromPost(Post post) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProfileDetailScreen(userId: post.user.userId),
      ),
    );
  }

  void _handleLike(Post post) {
    final isLoggedIn = ref.read(isLoggedInProvider);
    if (!isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.loginRequired),
          backgroundColor: Colors.black,
        ),
      );
      return;
    }

    if (post.isLiked && post.likeId != null) {
      ref.read(timelineProvider.notifier).unlikePost(post.postId, post.likeId!);
    } else {
      ref.read(timelineProvider.notifier).likePost(post.postId);
    }
  }

  void _openComposer() {
    final isLoggedIn = ref.read(isLoggedInProvider);
    if (!isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.loginRequired),
          backgroundColor: Colors.black,
        ),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final double dialogWidth = (screenWidth - 32).clamp(320.0, 600.0);
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.black, width: 1.4),
          ),
          child: SizedBox(
            width: dialogWidth,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.newPost,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _composerController,
                    maxLines: 5,
                    minLines: 3,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.enterText,
                      hintStyle: const TextStyle(color: Colors.black54),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.2),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.4),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 12),
                  Consumer(
                    builder: (context, ref, _) {
                      final isCreating = ref.watch(
                        postProvider.select((s) => s.isCreating),
                      );
                      return Row(
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                              side: const BorderSide(
                                  color: Colors.black, width: 1.2),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                            onPressed: isCreating
                                ? null
                                : () {
                                    _composerController.clear();
                                    Navigator.of(context).pop();
                                  },
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                            ),
                            onPressed: isCreating
                                ? null
                                : () async {
                                    final text =
                                        _composerController.text.trim();
                                    if (text.isEmpty) return;

                                    final post = await ref
                                        .read(postProvider.notifier)
                                        .createPost(text);
                                    if (post != null && context.mounted) {
                                      Navigator.of(context).pop();
                                      _composerController.clear();
                                      ref
                                          .read(timelineProvider.notifier)
                                          .addNewPost(post);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              AppLocalizations.of(context)!
                                                  .posted(text)),
                                          backgroundColor: Colors.black,
                                        ),
                                      );
                                    }
                                  },
                            child: isCreating
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    AppLocalizations.of(context)!.post,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800),
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getSourceLabel(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return 'Latest';
      case 1:
        return 'Following';
      case 2:
        return 'Trending';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(timelineProvider);
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MonochromeTabBar(
              controller: _tabController,
              tabs: [
                Tab(text: l10n.tabLatest),
                Tab(text: l10n.tabFollowing),
                Tab(text: l10n.tabTrending),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: state.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    )
                  : RefreshIndicator(
                      onRefresh: () => ref
                          .read(timelineProvider.notifier)
                          .loadTimeline(refresh: true),
                      color: Colors.black,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        itemCount:
                            state.posts.length + (state.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == state.posts.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(
                                    color: Colors.black),
                              ),
                            );
                          }

                          final post = state.posts[index];
                          return PostCard(
                            post: post,
                            onTap: () => _openProfileFromPost(post),
                            onLikeTap: () => _handleLike(post),
                            source: _getSourceLabel(_tabController.index),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                      ),
                    ),
            ),
          ],
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: _ComposeFab(onTap: _openComposer),
        ),
      ],
    );
  }
}

class _ComposeFab extends StatelessWidget {
  const _ComposeFab({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black, width: 1.4),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: Colors.black, size: 20),
          ],
        ),
      ),
    );
  }
}
