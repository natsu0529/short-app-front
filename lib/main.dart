import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';

void main() {
  runApp(const ShortTextApp());
}

class ShortTextApp extends StatefulWidget {
  const ShortTextApp({super.key});

  static void setLocale(BuildContext context, Locale locale) {
    final state = context.findAncestorStateOfType<_ShortTextAppState>();
    state?.setLocale(locale);
  }

  @override
  State<ShortTextApp> createState() => _ShortTextAppState();
}

class _ShortTextAppState extends State<ShortTextApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Text SNS',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: _locale,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          onPrimary: Colors.white,
          secondary: Colors.black,
          onSecondary: Colors.white,
          error: Colors.black,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        dividerColor: Colors.black,
        tabBarTheme: const TabBarThemeData(
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black,
          indicatorColor: Colors.black,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
        ),
      ),
      home: const HomeShell(),
    );
  }
}

class _MonoText {
  static const subtitle = TextStyle(
    fontSize: 13,
    color: Colors.black,
  );
  static const body = TextStyle(
    fontSize: 14,
    height: 1.5,
    color: Colors.black,
  );
  static const label = TextStyle(
    fontSize: 12,
    color: Colors.black,
  );
}

String _localizedSource(BuildContext context, String source) {
  final l10n = AppLocalizations.of(context)!;
  switch (source) {
    case 'Latest':
      return l10n.sourceLatest;
    case 'Following':
      return l10n.sourceFollowing;
    case 'Trending':
      return l10n.sourceTrending;
    case 'Liked':
      return l10n.sourceLiked;
    default:
      return source;
  }
}

String _localizedTime(BuildContext context, String time) {
  final l10n = AppLocalizations.of(context)!;
  final match = RegExp(r'^(\d+)([mhd])$').firstMatch(time);
  if (match != null) {
    final count = int.parse(match.group(1)!);
    final unit = match.group(2)!;
    switch (unit) {
      case 'm':
        return l10n.minutesAgo(count);
      case 'h':
        return l10n.hoursAgo(count);
      case 'd':
        return l10n.daysAgo(count);
    }
  }
  if (time == 'yesterday') {
    return l10n.yesterday;
  }
  return time;
}

String _localizedMetric(BuildContext context, String metric) {
  final l10n = AppLocalizations.of(context)!;
  final likesMatch = RegExp(r'^([\d.]+k?) likes$').firstMatch(metric);
  if (likesMatch != null) {
    return l10n.likesCount(likesMatch.group(1)!);
  }
  final followersMatch = RegExp(r'^([\d.]+k?) followers$').firstMatch(metric);
  if (followersMatch != null) {
    return l10n.followersCount(followersMatch.group(1)!);
  }
  final levelMatch = RegExp(r'^Lv\.(\d+)$').firstMatch(metric);
  if (levelMatch != null) {
    return l10n.levelDisplay(int.parse(levelMatch.group(1)!));
  }
  return metric;
}

String _localizedTitle(BuildContext context, RankingEntry entry) {
  final l10n = AppLocalizations.of(context)!;
  if (entry.title.endsWith(' post') && entry.userName != null) {
    return l10n.userPost(entry.userName!);
  }
  return entry.title;
}

class MonoCard extends StatelessWidget {
  const MonoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderWidth = 1.4,
    this.radius = 16,
  });

  final Widget child;
  final EdgeInsets padding;
  final double borderWidth;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.black, width: borderWidth),
      ),
      child: child,
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final _pages = const [
    TimelinePage(),
    RankingPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: const IconThemeData(size: 28, color: Colors.black),
        unselectedIconTheme:
            const IconThemeData(size: 24, color: Colors.black),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.view_agenda_outlined),
            activeIcon: const Icon(Icons.view_agenda),
            label: AppLocalizations.of(context)!.navTimeline,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.leaderboard_outlined),
            activeIcon: const Icon(Icons.leaderboard),
            label: AppLocalizations.of(context)!.navRanking,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: AppLocalizations.of(context)!.navProfile,
          ),
        ],
      ),
    );
  }
}

class TimelinePage extends StatefulWidget {
  const TimelinePage({super.key});

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  final TextEditingController _composerController = TextEditingController();

  @override
  void dispose() {
    _composerController.dispose();
    super.dispose();
  }

  void _openProfileFromPost(Post post) {
    final profile = Profile(
      name: post.user,
      handle: post.handle,
      bio: AppLocalizations.of(context)!.viewingUserPosts(post.user),
      url: post.handle.replaceFirst('@', ''),
      totalLikes: post.likes,
      level: post.level,
      rank: 0,
      following: 0,
      followers: 0,
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProfileDetailPage(profile: profile),
      ),
    );
  }

  void _openComposer() {
    showDialog<void>(
      context: context,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final double dialogWidth = (screenWidth - 32).clamp(320.0, 600.0);
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
                  Row(
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: Colors.black, width: 1.2),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                        ),
                        onPressed: () {
                          _composerController.clear();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          style: const TextStyle(fontWeight: FontWeight.w700),
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
                        onPressed: () {
                          final text = _composerController.text.trim();
                          Navigator.of(context).pop();
                          if (text.isNotEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(AppLocalizations.of(context)!.posted(text)),
                                backgroundColor: Colors.black,
                              ),
                            );
                            _composerController.clear();
                          }
                        },
                        child: Text(
                          AppLocalizations.of(context)!.post,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _MonochromeTabBar(
                tabs: [
                  Tab(text: AppLocalizations.of(context)!.tabLatest),
                  Tab(text: AppLocalizations.of(context)!.tabFollowing),
                  Tab(text: AppLocalizations.of(context)!.tabTrending),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TabBarView(
                  children: [
                    _PostList(
                      posts: latestPosts,
                      onPostTap: _openProfileFromPost,
                    ),
                    _PostList(
                      posts: followingPosts,
                      onPostTap: _openProfileFromPost,
                    ),
                    _PostList(
                      posts: trendingPosts,
                      onPostTap: _openProfileFromPost,
                    ),
                  ],
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
      ),
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

class ProfileDetailPage extends StatelessWidget {
  const ProfileDetailPage({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          profile.name,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProfileHeader(
              profile: profile,
              showFollowButton: true,
              showEdit: false,
            ),
            const SizedBox(height: 16),
            _ProfileStats(profile: profile, isOwnProfile: false),
          ],
        ),
      ),
    );
  }
}

class FollowListPage extends StatelessWidget {
  const FollowListPage({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: initialTab,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.navProfile,
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          bottom: _MonochromeTabBar(
            tabs: [
              Tab(text: AppLocalizations.of(context)!.following),
              Tab(text: AppLocalizations.of(context)!.followers),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _FollowList(users: followingUsers),
            _FollowList(users: followerUsers),
          ],
        ),
      ),
    );
  }
}

class _FollowList extends StatelessWidget {
  const _FollowList({required this.users});

  final List<FollowUser> users;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemBuilder: (context, index) {
        final user = users[index];
        return GestureDetector(
          onTap: () {
            final profile = Profile(
              name: user.name,
              handle: user.handle,
              bio: user.bio,
              url: user.handle.replaceFirst('@', ''),
              totalLikes: user.likes,
              level: user.level,
              rank: 0,
              following: 0,
              followers: 0,
            );
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ProfileDetailPage(profile: profile),
              ),
            );
          },
          child: MonoCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.handle,
                        style: _MonoText.label,
                      ),
                    ],
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.levelDisplay(user.level),
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

class FollowUser {
  const FollowUser({
    required this.name,
    required this.handle,
    required this.bio,
    required this.level,
    required this.likes,
  });

  final String name;
  final String handle;
  final String bio;
  final int level;
  final int likes;
}

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  void _openProfile(RankingEntry entry) {
    final profile = Profile(
      name: entry.userName ?? entry.title,
      handle: entry.handle ?? '@unknown',
      bio: entry.subtitle,
      url: (entry.handle ?? '').replaceFirst('@', ''),
      totalLikes: 0,
      level: 0,
      rank: entry.position,
      following: 0,
      followers: 0,
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProfileDetailPage(profile: profile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MonochromeTabBar(
            tabs: [
              Tab(text: AppLocalizations.of(context)!.tabPopularPosts),
              Tab(text: AppLocalizations.of(context)!.tabLikes),
              Tab(text: AppLocalizations.of(context)!.tabLevel),
              Tab(text: AppLocalizations.of(context)!.tabFollowers),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              children: [
                _RankingList(
                  entries: popularPosts,
                  onTap: _openProfile,
                ),
                _RankingList(
                  entries: totalLikesRanking,
                  onTap: _openProfile,
                ),
                _RankingList(
                  entries: levelRanking,
                  onTap: _openProfile,
                ),
                _RankingList(
                  entries: followerRanking,
                  onTap: _openProfile,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RankingPageWithScroll extends StatefulWidget {
  const RankingPageWithScroll({
    super.key,
    required this.initialTab,
    required this.scrollToRank,
  });

  final int initialTab;
  final int scrollToRank;

  @override
  State<RankingPageWithScroll> createState() => _RankingPageWithScrollState();
}

class _RankingPageWithScrollState extends State<RankingPageWithScroll>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  static const double _itemHeight = 90.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTab,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToMyRank();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToMyRank() {
    final targetOffset = (widget.scrollToRank - 1) * _itemHeight;
    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  void _openProfile(RankingEntry entry) {
    final profile = Profile(
      name: entry.userName ?? entry.title,
      handle: entry.handle ?? '@unknown',
      bio: entry.subtitle,
      url: (entry.handle ?? '').replaceFirst('@', ''),
      totalLikes: 0,
      level: 0,
      rank: entry.position,
      following: 0,
      followers: 0,
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProfileDetailPage(profile: profile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.navRanking,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: _MonochromeTabBar(
          controller: _tabController,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.tabPopularPosts),
            Tab(text: AppLocalizations.of(context)!.tabLikes),
            Tab(text: AppLocalizations.of(context)!.tabLevel),
            Tab(text: AppLocalizations.of(context)!.tabFollowers),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _RankingListWithController(
            entries: popularPosts,
            onTap: _openProfile,
            controller: widget.initialTab == 0 ? _scrollController : null,
          ),
          _RankingListWithController(
            entries: totalLikesRanking,
            onTap: _openProfile,
            controller: widget.initialTab == 1 ? _scrollController : null,
          ),
          _RankingListWithController(
            entries: levelRanking,
            onTap: _openProfile,
            controller: widget.initialTab == 2 ? _scrollController : null,
          ),
          _RankingListWithController(
            entries: followerRanking,
            onTap: _openProfile,
            controller: widget.initialTab == 3 ? _scrollController : null,
          ),
        ],
      ),
    );
  }
}

class _RankingListWithController extends StatelessWidget {
  const _RankingListWithController({
    required this.entries,
    this.onTap,
    this.controller,
  });

  final List<RankingEntry> entries;
  final ValueChanged<RankingEntry>? onTap;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return GestureDetector(
          onTap: onTap != null ? () => onTap!(entry) : null,
          child: MonoCard(
            radius: 14,
            child: Row(
              children: [
                _RankBadge(position: entry.position),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _localizedTitle(context, entry),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entry.subtitle,
                        style: _MonoText.label,
                      ),
                    ],
                  ),
                ),
                Text(
                  _localizedMetric(context, entry.metric),
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
      itemCount: entries.length,
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProfileScreenBody();
  }
}

class _ProfileScreenBody extends StatefulWidget {
  const _ProfileScreenBody();

  @override
  State<_ProfileScreenBody> createState() => _ProfileScreenBodyState();
}

class _ProfileScreenBodyState extends State<_ProfileScreenBody> {
  final ScrollController _likedScrollController = ScrollController();

  @override
  void dispose() {
    _likedScrollController.dispose();
    super.dispose();
  }

  void _scrollLikedToTop() {
    _likedScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _openProfileFromPost(Post post) {
    final profile = Profile(
      name: post.user,
      handle: post.handle,
      bio: AppLocalizations.of(context)!.viewingUserPosts(post.user),
      url: post.handle.replaceFirst('@', ''),
      totalLikes: post.likes,
      level: post.level,
      rank: 0,
      following: 0,
      followers: 0,
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProfileDetailPage(profile: profile),
      ),
    );
  }

  void _openFollowingList() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const FollowListPage(initialTab: 0),
      ),
    );
  }

  void _openFollowersList() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const FollowListPage(initialTab: 1),
      ),
    );
  }

  void _openMyRanking() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RankingPageWithScroll(
          initialTab: 1,
          scrollToRank: sampleProfile.rank,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ProfileHeader(profile: sampleProfile),
          const SizedBox(height: 16),
          _ProfileStats(
            profile: sampleProfile,
            onFollowingTap: _openFollowingList,
            onFollowersTap: _openFollowersList,
            onRankingTap: _openMyRanking,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _LikedPostsSection(
              posts: likedPosts,
              controller: _likedScrollController,
              onHeaderTap: _scrollLikedToTop,
              onPostTap: _openProfileFromPost,
            ),
          ),
        ],
      ),
    );
  }
}

class _MonochromeTabBar extends StatelessWidget implements PreferredSizeWidget {
  const _MonochromeTabBar({required this.tabs, this.controller});

  final List<Widget> tabs;
  final TabController? controller;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      tabs: tabs,
      dividerColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(color: Colors.black, width: 2),
        insets: EdgeInsets.symmetric(horizontal: 16),
      ),
      labelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      splashBorderRadius: BorderRadius.circular(0),
    );
  }
}

class _PostList extends StatelessWidget {
  const _PostList({required this.posts, this.onPostTap});

  final List<Post> posts;
  final ValueChanged<Post>? onPostTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemBuilder: (context, index) => _PostCard(
        post: posts[index],
        onTap: onPostTap,
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemCount: posts.length,
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post, this.onTap});

  final Post post;
  final ValueChanged<Post>? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap != null ? () => onTap!(post) : null,
      child: MonoCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${post.user} ・ ${_localizedTime(context, post.time)}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              post.body,
              style: _MonoText.body,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!.liked),
                        backgroundColor: Colors.black,
                        duration: const Duration(milliseconds: 500),
                      ),
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      const Icon(Icons.favorite_border, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        AppLocalizations.of(context)!.likesCount(post.likes.toString()),
                        style: _MonoText.subtitle,
                      ),
                    ],
                  ),
                ),
                Text(
                  _localizedSource(context, post.source),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RankingList extends StatelessWidget {
  const _RankingList({required this.entries, this.onTap});

  final List<RankingEntry> entries;
  final ValueChanged<RankingEntry>? onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return GestureDetector(
          onTap: onTap != null ? () => onTap!(entry) : null,
          child: MonoCard(
            radius: 14,
            child: Row(
              children: [
                _RankBadge(position: entry.position),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _localizedTitle(context, entry),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entry.subtitle,
                        style: _MonoText.label,
                      ),
                    ],
                  ),
                ),
                Text(
                  _localizedMetric(context, entry.metric),
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
      itemCount: entries.length,
    );
  }
}

class _RankBadge extends StatelessWidget {
  const _RankBadge({required this.position});

  final int position;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: 1.2),
      ),
      child: Text(
        '#$position',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: Colors.black,
        ),
      ),
    );
  }
}

class _LevelIndicator extends StatelessWidget {
  const _LevelIndicator({
    required this.level,
    required this.exp,
    required this.maxExp,
  });

  final int level;
  final int exp;
  final int maxExp;

  @override
  Widget build(BuildContext context) {
    final progress = maxExp > 0 ? exp / maxExp : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          AppLocalizations.of(context)!.levelDisplay(level),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 80,
          height: 6,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.profile,
    this.showFollowButton = false,
    this.showEdit = true,
  });

  final Profile profile;
  final bool showFollowButton;
  final bool showEdit;

  void _openEditDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => _ProfileEditDialog(profile: profile),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        MonoCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      profile.name,
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
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black, width: 1.2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!.followed),
                            backgroundColor: Colors.black,
                          ),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.follow,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  else
                    _LevelIndicator(
                      level: profile.level,
                      exp: profile.exp,
                      maxExp: profile.maxExp,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                profile.bio,
                style: _MonoText.body,
              ),
              const SizedBox(height: 8),
              Text(
                profile.url,
                style: const TextStyle(
                  fontSize: 13,
                  decoration: TextDecoration.underline,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        if (showEdit)
          Positioned(
            right: 0,
            bottom: -24,
            child: GestureDetector(
              onTap: () => _openEditDialog(context),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black, width: 1.4),
                  ),
                  child: const Icon(Icons.edit, size: 18, color: Colors.black),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ProfileEditDialog extends StatefulWidget {
  const _ProfileEditDialog({required this.profile});

  final Profile profile;

  @override
  State<_ProfileEditDialog> createState() => _ProfileEditDialogState();
}

class _ProfileEditDialogState extends State<_ProfileEditDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name);
    _bioController = TextEditingController(text: widget.profile.bio);
    _urlController = TextEditingController(text: widget.profile.url);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _save() {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.profileSaved),
        backgroundColor: Colors.black,
      ),
    );
  }

  void _logout() {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.loggedOut),
        backgroundColor: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.black.withValues(alpha: 0.5),
        body: GestureDetector(
          onTap: () {}, // 内側タップは何もしない
          child: Center(
            child: Container(
              width: screenWidth - 32,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black, width: 1.4),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
              AppLocalizations.of(context)!.editProfile,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(AppLocalizations.of(context)!.name, _nameController),
            const SizedBox(height: 12),
            _buildTextField(AppLocalizations.of(context)!.bio, _bioController, maxLines: 3),
            const SizedBox(height: 12),
            _buildTextField(AppLocalizations.of(context)!.url, _urlController),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black, width: 1.2),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _save,
                    child: Text(
                      AppLocalizations.of(context)!.save,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: _logout,
                child: Text(
                  AppLocalizations.of(context)!.logout,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1.4),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          style: const TextStyle(color: Colors.black, fontSize: 14),
        ),
      ],
    );
  }
}

class _ProfileStats extends StatelessWidget {
  const _ProfileStats({
    required this.profile,
    this.isOwnProfile = true,
    this.onFollowingTap,
    this.onFollowersTap,
    this.onRankingTap,
  });

  final Profile profile;
  final bool isOwnProfile;
  final VoidCallback? onFollowingTap;
  final VoidCallback? onFollowersTap;
  final VoidCallback? onRankingTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MonoCard(
          child: Column(
            children: [
              Row(
                children: [
                  _StatBlock(label: AppLocalizations.of(context)!.totalLikes, value: '${profile.totalLikes}'),
                  _StatBlock(label: AppLocalizations.of(context)!.level, value: AppLocalizations.of(context)!.levelDisplay(profile.level)),
                  _StatBlock(
                    label: AppLocalizations.of(context)!.myRanking,
                    value: '#${profile.rank}',
                    onTap: isOwnProfile ? onRankingTap : null,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _StatBlock(
                    label: AppLocalizations.of(context)!.following,
                    value: '${profile.following}',
                    onTap: isOwnProfile ? onFollowingTap : null,
                  ),
                  _StatBlock(
                    label: AppLocalizations.of(context)!.followers,
                    value: '${profile.followers}',
                    onTap: isOwnProfile ? onFollowersTap : null,
                  ),
                  if (isOwnProfile) const _LanguageStatBlock(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatBlock extends StatelessWidget {
  const _StatBlock({
    required this.label,
    required this.value,
    this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Column(
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
    );

    return Expanded(
      child: onTap != null
          ? GestureDetector(
              onTap: onTap,
              behavior: HitTestBehavior.opaque,
              child: content,
            )
          : content,
    );
  }
}

class _LanguageStatBlock extends StatelessWidget {
  const _LanguageStatBlock();

  static const _languages = [
    ('ja', '日本語'),
    ('en', 'English'),
    ('zh', '中文'),
    ('es', 'Español'),
    ('fr', 'Français'),
    ('ru', 'Русский'),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _showLanguageDialog(context),
        behavior: HitTestBehavior.opaque,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Language',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _getCurrentLanguageCode(context),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentLanguageCode(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode.toUpperCase();
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Language',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _languages.map((lang) {
            final isSelected =
                Localizations.localeOf(dialogContext).languageCode == lang.$1;
            return ListTile(
              title: Text(
                lang.$2,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: Colors.black, size: 20)
                  : null,
              onTap: () {
                ShortTextApp.setLocale(context, Locale(lang.$1));
                Navigator.of(dialogContext).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _LikedPostsSection extends StatelessWidget {
  const _LikedPostsSection({
    required this.posts,
    required this.controller,
    required this.onHeaderTap,
    this.onPostTap,
  });

  final List<Post> posts;
  final ScrollController controller;
  final VoidCallback onHeaderTap;
  final ValueChanged<Post>? onPostTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onHeaderTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.likedPosts,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            controller: controller,
            itemBuilder: (context, index) => _PostCard(
              post: posts[index],
              onTap: onPostTap,
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: posts.length,
          ),
        ),
      ],
    );
  }
}

class Post {
  const Post({
    required this.user,
    required this.handle,
    required this.time,
    required this.body,
    required this.likes,
    required this.level,
    this.source = '',
  });

  final String user;
  final String handle;
  final String time;
  final String body;
  final int likes;
  final int level;
  final String source;

  String get userInitials {
    final parts = user.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }
}

class RankingEntry {
  const RankingEntry({
    required this.position,
    required this.title,
    required this.subtitle,
    required this.metric,
    this.userName,
    this.handle,
  });

  final int position;
  final String title;
  final String subtitle;
  final String metric;
  final String? userName;
  final String? handle;
}

class Profile {
  const Profile({
    required this.name,
    required this.handle,
    required this.bio,
    required this.url,
    required this.totalLikes,
    required this.level,
    required this.rank,
    required this.following,
    required this.followers,
    this.exp = 0,
    this.maxExp = 100,
  });

  final String name;
  final String handle;
  final String bio;
  final String url;
  final int totalLikes;
  final int level;
  final int rank;
  final int following;
  final int followers;
  final int exp;
  final int maxExp;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  String get statusLabel => 'Active';
}

const latestPosts = [
  Post(
    user: 'Aya Koga',
    handle: '@aya',
    time: '2m',
    body: 'シンプルな文章だけでつながる日課。今日のアウトプットは「書きやすさ」に全振りしてみた。',
    likes: 42,
    level: 7,
    source: 'Latest',
  ),
  Post(
    user: 'Taku Kato',
    handle: '@taku',
    time: '10m',
    body: '返信がない分、書いた一文の質が問われる。短いほど意思が鮮明になる感覚がある。',
    likes: 58,
    level: 8,
    source: 'Latest',
  ),
  Post(
    user: 'Mina',
    handle: '@mina',
    time: '18m',
    body: '今日の習慣ログ: 500 文字以内で日報を書いたらタスクが整理された。短文は強い。',
    likes: 31,
    level: 6,
    source: 'Latest',
  ),
];

const followingPosts = [
  Post(
    user: 'Leo Takada',
    handle: '@leo',
    time: '5m',
    body: 'タイムラインは読むだけ。いいねが行動変容になるから、書き手の本気度も見える。',
    likes: 21,
    level: 5,
    source: 'Following',
  ),
  Post(
    user: 'Sara',
    handle: '@sara',
    time: '12m',
    body: '短いテキストしか送れないと、書き出しでどれだけ引き込めるかが勝負。',
    likes: 17,
    level: 4,
    source: 'Following',
  ),
  Post(
    user: 'Aki',
    handle: '@aki',
    time: '29m',
    body: 'フォロー中フィードは読み物として成立してきた。返信ゼロの静けさがいい。',
    likes: 9,
    level: 4,
    source: 'Following',
  ),
];

const trendingPosts = [
  Post(
    user: 'Rio',
    handle: '@rio',
    time: '1h',
    body: '「文字と輪郭は黒、その他は白」の縛りで UI を組んでみたら、余白と線が主役になった。',
    likes: 203,
    level: 11,
    source: 'Trending',
  ),
  Post(
    user: 'Noa',
    handle: '@noa',
    time: '2h',
    body: '通知に頼らず、好きなタイミングで読みに行く。SNS の時間を取り戻す挑戦。',
    likes: 144,
    level: 10,
    source: 'Trending',
  ),
  Post(
    user: 'Ken',
    handle: '@ken',
    time: '4h',
    body: '「いいね」がレベルに直結すると、日々の投稿にも目的ができる。数字が素直。',
    likes: 121,
    level: 9,
    source: 'Trending',
  ),
];

const popularPosts = [
  RankingEntry(
    position: 1,
    title: 'Rio post',
    subtitle: 'UI research notes on whitespace and lines',
    metric: '203 likes',
    userName: 'Rio',
    handle: '@rio',
  ),
  RankingEntry(
    position: 2,
    title: 'Noa post',
    subtitle: 'SNS experiment without notifications',
    metric: '144 likes',
    userName: 'Noa',
    handle: '@noa',
  ),
  RankingEntry(
    position: 3,
    title: 'Ken post',
    subtitle: 'Notes on likes and level correlation',
    metric: '121 likes',
    userName: 'Ken',
    handle: '@ken',
  ),
];

const totalLikesRanking = [
  RankingEntry(
    position: 1,
    title: 'Mina',
    subtitle: '@mina ・ Daily reports',
    metric: '2.3k likes',
    userName: 'Mina',
    handle: '@mina',
  ),
  RankingEntry(
    position: 2,
    title: 'Aya Koga',
    subtitle: '@aya ・ Short notes',
    metric: '1.9k likes',
    userName: 'Aya Koga',
    handle: '@aya',
  ),
  RankingEntry(
    position: 3,
    title: 'Leo Takada',
    subtitle: '@leo ・ Focus log',
    metric: '1.4k likes',
    userName: 'Leo Takada',
    handle: '@leo',
  ),
];

const levelRanking = [
  RankingEntry(
    position: 1,
    title: 'Riku',
    subtitle: '@riku ・ Night posts',
    metric: 'Lv.18',
    userName: 'Riku',
    handle: '@riku',
  ),
  RankingEntry(
    position: 2,
    title: 'Sara',
    subtitle: '@sara ・ Morning notes',
    metric: 'Lv.16',
    userName: 'Sara',
    handle: '@sara',
  ),
  RankingEntry(
    position: 3,
    title: 'Ken',
    subtitle: '@ken ・ Analysis',
    metric: 'Lv.14',
    userName: 'Ken',
    handle: '@ken',
  ),
];

const followerRanking = [
  RankingEntry(
    position: 1,
    title: 'Noa',
    subtitle: '@noa ・ Quiet timeline advocate',
    metric: '12.4k followers',
    userName: 'Noa',
    handle: '@noa',
  ),
  RankingEntry(
    position: 2,
    title: 'Aya Koga',
    subtitle: '@aya ・ Daily one-liners',
    metric: '9.8k followers',
    userName: 'Aya Koga',
    handle: '@aya',
  ),
  RankingEntry(
    position: 3,
    title: 'Mina',
    subtitle: '@mina ・ Curator',
    metric: '7.1k followers',
    userName: 'Mina',
    handle: '@mina',
  ),
];

const sampleProfile = Profile(
  name: 'Nao Suzuki',
  handle: '@naoszk',
  bio: '文章だけで繋がる実験中。毎日短いメモをアップ。返信なしでも伝わる言葉を探しています。',
  url: 'suzu.ink',
  totalLikes: 1832,
  level: 12,
  rank: 18,
  following: 142,
  followers: 980,
  exp: 65,
  maxExp: 100,
);

const likedPosts = [
  Post(
    user: 'Riku',
    handle: '@riku',
    time: 'yesterday',
    body: '夜の静けさに合わせて 120 文字だけ書くと、頭が整理される。不思議な儀式。',
    likes: 320,
    level: 12,
    source: 'Liked',
  ),
  Post(
    user: 'Sara',
    handle: '@sara',
    time: '2d',
    body: '朝活の始まりは 3 行の日報。短くても積み重ねると習慣になるのが目に見える。',
    likes: 268,
    level: 11,
    source: 'Liked',
  ),
  Post(
    user: 'Noa',
    handle: '@noa',
    time: '3d',
    body: '音のない SNS で、文章の熱量だけを感じたい。だからこそレベルとランキングが効く。',
    likes: 410,
    level: 13,
    source: 'Liked',
  ),
];

const followingUsers = [
  FollowUser(
    name: 'Aya Koga',
    handle: '@aya',
    bio: 'Writing short notes',
    level: 7,
    likes: 1900,
  ),
  FollowUser(
    name: 'Taku Kato',
    handle: '@taku',
    bio: 'Believer in short text',
    level: 8,
    likes: 580,
  ),
  FollowUser(
    name: 'Rio',
    handle: '@rio',
    bio: 'UI research notes',
    level: 11,
    likes: 2030,
  ),
  FollowUser(
    name: 'Noa',
    handle: '@noa',
    bio: 'Quiet timeline advocate',
    level: 10,
    likes: 1440,
  ),
];

const followerUsers = [
  FollowUser(
    name: 'Leo Takada',
    handle: '@leo',
    bio: 'Focus log',
    level: 5,
    likes: 210,
  ),
  FollowUser(
    name: 'Sara',
    handle: '@sara',
    bio: 'Morning notes',
    level: 4,
    likes: 170,
  ),
  FollowUser(
    name: 'Mina',
    handle: '@mina',
    bio: 'Daily reports',
    level: 6,
    likes: 2300,
  ),
  FollowUser(
    name: 'Ken',
    handle: '@ken',
    bio: 'Analysis',
    level: 9,
    likes: 1210,
  ),
  FollowUser(
    name: 'Riku',
    handle: '@riku',
    bio: 'Night posts',
    level: 18,
    likes: 3200,
  ),
];
