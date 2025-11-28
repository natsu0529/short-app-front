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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final followService = ref.read(followServiceProvider);
      print('Loading follow data for userId: ${widget.userId}');
      final results = await Future.wait([
        followService.getFollowing(widget.userId),
        followService.getFollowers(widget.userId),
      ]);
      print('Following count: ${results[0].length}');
      print('Followers count: ${results[1].length}');
      setState(() {
        _following = results[0];
        _followers = results[1];
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading follow data: $e');
      setState(() => _isLoading = false);
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
                  ),
                  _FollowList(
                    users: _followers,
                    onTap: _openProfile,
                    emptyMessage: l10n.noFollowers,
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
    this.onTap,
  });

  final List<User> users;
  final String emptyMessage;
  final ValueChanged<User>? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (users.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemBuilder: (context, index) {
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
      itemCount: users.length,
    );
  }
}
