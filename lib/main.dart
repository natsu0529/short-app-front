import 'package:flutter/material.dart';

void main() {
  runApp(const ShortTextApp());
}

class ShortTextApp extends StatelessWidget {
  const ShortTextApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Text SNS',
      debugShowCheckedModeBanner: false,
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.view_agenda_outlined),
            activeIcon: Icon(Icons.view_agenda),
            label: 'タイムライン',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard_outlined),
            activeIcon: Icon(Icons.leaderboard),
            label: 'ランキング',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'プロフィール',
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
      bio: '${post.user} の投稿を表示中',
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
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.black, width: 1.4),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '新規投稿',
                  style: TextStyle(
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
                  decoration: const InputDecoration(
                    hintText: 'テキストを入力',
                    hintStyle: TextStyle(color: Colors.black54),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.2),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    focusedBorder: OutlineInputBorder(
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
                      child: const Text(
                        'キャンセル',
                        style: TextStyle(fontWeight: FontWeight.w700),
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
                              content: Text('投稿しました: $text'),
                              backgroundColor: Colors.black,
                            ),
                          );
                          _composerController.clear();
                        }
                      },
                      child: const Text(
                        '投稿',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ],
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
              const _MonochromeTabBar(
                tabs: [
                  Tab(text: '最新'),
                  Tab(text: 'フォロー中'),
                  Tab(text: 'トレンド'),
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
            _ProfileStats(profile: profile),
          ],
        ),
      ),
    );
  }
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
          const _MonochromeTabBar(
            tabs: [
              Tab(text: '人気投稿'),
              Tab(text: 'いいね'),
              Tab(text: 'レベル'),
              Tab(text: 'フォロワー'),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _ProfileHeader(profile: sampleProfile),
          const SizedBox(height: 16),
          const _ProfileStats(profile: sampleProfile),
          const SizedBox(height: 16),
          Expanded(
            child: _LikedPostsSection(
              posts: likedPosts,
              controller: _likedScrollController,
              onHeaderTap: _scrollLikedToTop,
            ),
          ),
        ],
      ),
    );
  }
}

class _MonochromeTabBar extends StatelessWidget {
  const _MonochromeTabBar({required this.tabs});

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return TabBar(
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
              '${post.user} ・ ${post.time}',
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
                Row(
                  children: [
                    const Icon(Icons.favorite_border, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      '${post.likes} いいね',
                      style: _MonoText.subtitle,
                    ),
                  ],
                ),
                Text(
                  post.source,
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
                        entry.title,
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
                  entry.metric,
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
                          const SnackBar(
                            content: Text('フォローしました'),
                            backgroundColor: Colors.black,
                          ),
                        );
                      },
                      child: const Text(
                        'フォローする',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
            right: 12,
            bottom: -15,
            child: GestureDetector(
              onTap: () => _openEditDialog(context),
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
      const SnackBar(
        content: Text('プロフィールを保存しました'),
        backgroundColor: Colors.black,
      ),
    );
  }

  void _logout() {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('ログアウトしました'),
        backgroundColor: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.black, width: 1.4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'プロフィール編集',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField('名前', _nameController),
            const SizedBox(height: 12),
            _buildTextField('Bio', _bioController, maxLines: 3),
            const SizedBox(height: 12),
            _buildTextField('URL', _urlController),
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
                    child: const Text(
                      'キャンセル',
                      style: TextStyle(fontWeight: FontWeight.w700),
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
                    child: const Text(
                      '保存',
                      style: TextStyle(fontWeight: FontWeight.w800),
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
                child: const Text(
                  'ログアウト',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
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
  const _ProfileStats({required this.profile});

  final Profile profile;

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
                  _StatBlock(label: '総獲得いいね', value: '${profile.totalLikes}'),
                  _StatBlock(label: 'レベル', value: 'Lv.${profile.level}'),
                  _StatBlock(label: 'My ランキング', value: '#${profile.rank}'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _StatBlock(label: 'フォロー', value: '${profile.following}'),
                  _StatBlock(label: 'フォロワー', value: '${profile.followers}'),
                  _StatBlock(label: '状態', value: profile.statusLabel),
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
  const _StatBlock({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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

class _LikedPostsSection extends StatelessWidget {
  const _LikedPostsSection({
    required this.posts,
    required this.controller,
    required this.onHeaderTap,
  });

  final List<Post> posts;
  final ScrollController controller;
  final VoidCallback onHeaderTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onHeaderTap,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Center(
              child: Text(
                'いいねした投稿',
                textAlign: TextAlign.center,
                style: TextStyle(
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
            itemBuilder: (context, index) => _PostCard(post: posts[index]),
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
    time: '2分前',
    body: 'シンプルな文章だけでつながる日課。今日のアウトプットは「書きやすさ」に全振りしてみた。',
    likes: 42,
    level: 7,
    source: 'Latest',
  ),
  Post(
    user: 'Taku Kato',
    handle: '@taku',
    time: '10分前',
    body: '返信がない分、書いた一文の質が問われる。短いほど意思が鮮明になる感覚がある。',
    likes: 58,
    level: 8,
    source: 'Latest',
  ),
  Post(
    user: 'Mina',
    handle: '@mina',
    time: '18分前',
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
    time: '5分前',
    body: 'タイムラインは読むだけ。いいねが行動変容になるから、書き手の本気度も見える。',
    likes: 21,
    level: 5,
    source: 'Following',
  ),
  Post(
    user: 'Sara',
    handle: '@sara',
    time: '12分前',
    body: '短いテキストしか送れないと、書き出しでどれだけ引き込めるかが勝負。',
    likes: 17,
    level: 4,
    source: 'Following',
  ),
  Post(
    user: 'Aki',
    handle: '@aki',
    time: '29分前',
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
    time: '1時間前',
    body: '「文字と輪郭は黒、その他は白」の縛りで UI を組んでみたら、余白と線が主役になった。',
    likes: 203,
    level: 11,
    source: 'Trending',
  ),
  Post(
    user: 'Noa',
    handle: '@noa',
    time: '2時間前',
    body: '通知に頼らず、好きなタイミングで読みに行く。SNS の時間を取り戻す挑戦。',
    likes: 144,
    level: 10,
    source: 'Trending',
  ),
  Post(
    user: 'Ken',
    handle: '@ken',
    time: '4時間前',
    body: '「いいね」がレベルに直結すると、日々の投稿にも目的ができる。数字が素直。',
    likes: 121,
    level: 9,
    source: 'Trending',
  ),
];

const popularPosts = [
  RankingEntry(
    position: 1,
    title: 'Rio の投稿',
    subtitle: '余白と線が主役の UI 研究ノート',
    metric: '203 いいね',
    userName: 'Rio',
    handle: '@rio',
  ),
  RankingEntry(
    position: 2,
    title: 'Noa の投稿',
    subtitle: '通知に頼らない SNS の実験',
    metric: '144 いいね',
    userName: 'Noa',
    handle: '@noa',
  ),
  RankingEntry(
    position: 3,
    title: 'Ken の投稿',
    subtitle: 'いいね数とレベルの相関メモ',
    metric: '121 いいね',
    userName: 'Ken',
    handle: '@ken',
  ),
];

const totalLikesRanking = [
  RankingEntry(
    position: 1,
    title: 'Mina',
    subtitle: '@mina ・ 日報シリーズ',
    metric: '2.3k いいね',
    userName: 'Mina',
    handle: '@mina',
  ),
  RankingEntry(
    position: 2,
    title: 'Aya Koga',
    subtitle: '@aya ・ ショートノート',
    metric: '1.9k いいね',
    userName: 'Aya Koga',
    handle: '@aya',
  ),
  RankingEntry(
    position: 3,
    title: 'Leo Takada',
    subtitle: '@leo ・ フォーカスログ',
    metric: '1.4k いいね',
    userName: 'Leo Takada',
    handle: '@leo',
  ),
];

const levelRanking = [
  RankingEntry(
    position: 1,
    title: 'Riku',
    subtitle: '@riku ・ 夜間投稿が多い',
    metric: 'Lv.18',
    userName: 'Riku',
    handle: '@riku',
  ),
  RankingEntry(
    position: 2,
    title: 'Sara',
    subtitle: '@sara ・ 朝活メモ',
    metric: 'Lv.16',
    userName: 'Sara',
    handle: '@sara',
  ),
  RankingEntry(
    position: 3,
    title: 'Ken',
    subtitle: '@ken ・ 分析まとめ',
    metric: 'Lv.14',
    userName: 'Ken',
    handle: '@ken',
  ),
];

const followerRanking = [
  RankingEntry(
    position: 1,
    title: 'Noa',
    subtitle: '@noa ・ 静かなタイムライン提案',
    metric: '12.4k フォロワー',
    userName: 'Noa',
    handle: '@noa',
  ),
  RankingEntry(
    position: 2,
    title: 'Aya Koga',
    subtitle: '@aya ・ 日々の一行',
    metric: '9.8k フォロワー',
    userName: 'Aya Koga',
    handle: '@aya',
  ),
  RankingEntry(
    position: 3,
    title: 'Mina',
    subtitle: '@mina ・ まとめ屋',
    metric: '7.1k フォロワー',
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
);

const likedPosts = [
  Post(
    user: 'Riku',
    handle: '@riku',
    time: '昨日',
    body: '夜の静けさに合わせて 120 文字だけ書くと、頭が整理される。不思議な儀式。',
    likes: 320,
    level: 12,
    source: 'Liked',
  ),
  Post(
    user: 'Sara',
    handle: '@sara',
    time: '2日前',
    body: '朝活の始まりは 3 行の日報。短くても積み重ねると習慣になるのが目に見える。',
    likes: 268,
    level: 11,
    source: 'Liked',
  ),
  Post(
    user: 'Noa',
    handle: '@noa',
    time: '3日前',
    body: '音のない SNS で、文章の熱量だけを感じたい。だからこそレベルとランキングが効く。',
    likes: 410,
    level: 13,
    source: 'Liked',
  ),
];
