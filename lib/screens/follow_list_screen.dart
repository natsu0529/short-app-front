import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';
import 'profile_detail_screen.dart';

class FollowListScreen extends ConsumerStatefulWidget {
  const FollowListScreen({
    super.key,
    required this.userId,
    this.initialTab = 0,
  });

  final int userId;
  final int initialTab;

  @override
  ConsumerState<FollowListScreen> createState() => _FollowListScreenState();
}

class _FollowListScreenState extends ConsumerState<FollowListScreen> {
  List<User> _following = [];
  List<User> _followers = [];
  bool _isLoading = true;
  bool _hasMoreFollowing = true;
  bool _hasMoreFollowers = true;
  bool _isLoadingMoreFollowing = false;
  bool _isLoadingMoreFollowers = false;
  String? _followingCursor;
  String? _followersCursor;
  final ScrollController _followingController = ScrollController();
  final ScrollController _followersController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _followingController.dispose();
    _followersController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final followService = ref.read(followServiceProvider);
      print('Loading follow data for userId: ${widget.userId}');
      final results = await Future.wait([
        followService.getFollowing(widget.userId, pageSize: 20),
        followService.getFollowers(widget.userId, pageSize: 20),
      ]);
      print('Following count: ${results[0].results.length}');
      print('Followers count: ${results[1].results.length}');
      setState(() {
        _following = results[0].results;
        _followers = results[1].results;
        _followingCursor = results[0].nextCursor;
        _followersCursor = results[1].nextCursor;
        _hasMoreFollowing = results[0].hasNext;
        _hasMoreFollowers = results[1].hasNext;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading follow data: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMoreFollowing() async {
    if (_isLoadingMoreFollowing || !_hasMoreFollowing || _followingCursor == null) {
      return;
    }
    setState(() => _isLoadingMoreFollowing = true);
    try {
      final followService = ref.read(followServiceProvider);
      final response = await followService.getFollowing(
        widget.userId,
        cursor: _followingCursor,
        pageSize: 20,
      );
      setState(() {
        _following = [..._following, ...response.results];
        _followingCursor = response.nextCursor;
        _hasMoreFollowing = response.hasNext;
        _isLoadingMoreFollowing = false;
      });
    } catch (e) {
      print('Error loading more following: $e');
      setState(() => _isLoadingMoreFollowing = false);
    }
  }

  Future<void> _loadMoreFollowers() async {
    if (_isLoadingMoreFollowers || !_hasMoreFollowers || _followersCursor == null) {
      return;
    }
    setState(() => _isLoadingMoreFollowers = true);
    try {
      final followService = ref.read(followServiceProvider);
      final response = await followService.getFollowers(
        widget.userId,
        cursor: _followersCursor,
        pageSize: 20,
      );
      setState(() {
        _followers = [..._followers, ...response.results];
        _followersCursor = response.nextCursor;
        _hasMoreFollowers = response.hasNext;
        _isLoadingMoreFollowers = false;
      });
    } catch (e) {
      print('Error loading more followers: $e');
      setState(() => _isLoadingMoreFollowers = false);
    }
  }

  void _openProfile(User user) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProfileDetailScreen(userId: user.userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialTab,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.navProfile,
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          bottom: MonochromeTabBar(
            tabs: [
              Tab(text: l10n.following),
              Tab(text: l10n.followers),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.black),
              )
            : TabBarView(
                children: [
                  _FollowList(
                    users: _following,
                    onTap: _openProfile,
                    emptyMessage: l10n.noFollowing,
                    controller: _followingController,
                    onLoadMore: _loadMoreFollowing,
                    isLoadingMore: _isLoadingMoreFollowing,
                    hasMore: _hasMoreFollowing,
                  ),
                  _FollowList(
                    users: _followers,
                    onTap: _openProfile,
                    emptyMessage: l10n.noFollowers,
                    controller: _followersController,
                    onLoadMore: _loadMoreFollowers,
                    isLoadingMore: _isLoadingMoreFollowers,
                    hasMore: _hasMoreFollowers,
                  ),
                ],
              ),
      ),
    );
  }
}

class _FollowList extends StatelessWidget {
  const _FollowList({
    required this.users,
    required this.emptyMessage,
    required this.controller,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.onTap,
    this.onLoadMore,
  });

  final List<User> users;
  final String emptyMessage;
  final ScrollController controller;
  final bool isLoadingMore;
  final bool hasMore;
  final ValueChanged<User>? onTap;
  final VoidCallback? onLoadMore;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (users.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >=
                notification.metrics.maxScrollExtent - 240 &&
            hasMore &&
            !isLoadingMore) {
          onLoadMore?.call();
        }
        return false;
      },
      child: ListView.separated(
        controller: controller,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        itemBuilder: (context, index) {
          if (index == users.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(color: Colors.black),
                ),
              ),
            );
          }

          final user = users[index];
          return GestureDetector(
            onTap: onTap != null ? () => onTap!(user) : null,
            child: MonoCard(
              child: Row(
                children: [
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
                    l10n.levelDisplay(user.userLevel),
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
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: users.length + (isLoadingMore ? 1 : 0),
      ),
    );
  }
}
