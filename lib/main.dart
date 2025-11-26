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
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Colors.black,
          onPrimary: Colors.white,
          secondary: Colors.black,
          onSecondary: Colors.white,
          error: Colors.black,
          onError: Colors.white,
          background: Colors.white,
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        dividerColor: Colors.black,
        tabBarTheme: const TabBarTheme(
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
            label: 'タイムライン',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'ランキング',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'プロフィール',
          ),
        ],
      ),
    );
  }
}

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PageHeader(
            title: 'タイムライン',
            subtitle: '最新 / フォロー中 / トレンドをテキストだけで追う',
          ),
          const SizedBox(height: 12),
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
                _PostList(posts: latestPosts),
                _PostList(posts: followingPosts),
                _PostList(posts: trendingPosts),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _PageHeader(
            title: 'ランキング',
            subtitle: '投稿・総合いいね・レベル・フォロワー',
          ),
          const SizedBox(height: 12),
          const _MonochromeTabBar(
            tabs: [
              Tab(text: '人気投稿'),
              Tab(text: '総合いいね'),
              Tab(text: 'レベル'),
              Tab(text: 'フォロワー'),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              children: [
                _RankingList(entries: popularPosts),
                _RankingList(entries: totalLikesRanking),
                _RankingList(entries: levelRanking),
                _RankingList(entries: followerRanking),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileHeader(profile: sampleProfile),
          const SizedBox(height: 16),
          _ProfileStats(profile: sampleProfile),
          const SizedBox(height: 16),
          _LikedPostsSection(posts: likedPosts),
        ],
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
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
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black, width: 1.4),
          top: BorderSide(color: Colors.black, width: 1.4),
        ),
      ),
      child: TabBar(
        tabs: tabs,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: Colors.black,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        splashBorderRadius: BorderRadius.circular(0),
      ),
    );
  }
}

class _PostList extends StatelessWidget {
  const _PostList({required this.posts});

  final List<Post> posts;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemBuilder: (context, index) => _PostCard(post: posts[index]),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemCount: posts.length,
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(initials: post.userInitials),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.user,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${post.handle} ・ ${post.time}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 1.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Lv.${post.level}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      post.body,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.black,
                      ),
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
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
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
            ],
          ),
        ],
      ),
    );
  }
}

class _RankingList extends StatelessWidget {
  const _RankingList({required this.entries});

  final List<RankingEntry> entries;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black, width: 1.4),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 1.2),
                ),
                child: Text(
                  '#${entry.position}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ),
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
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
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
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemCount: entries.length,
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(initials: profile.initials, size: 52),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile.handle,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            side: const BorderSide(color: Colors.black, width: 1.2),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            'Googleでログイン',
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
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.black,
                      ),
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
            ],
          ),
        ],
      ),
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
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black, width: 1.4),
          ),
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
  const _LikedPostsSection({required this.posts});

  final List<Post> posts;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'いいねした投稿',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => _PostCard(post: posts[index]),
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemCount: posts.length,
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials, this.size = 44});

  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 1.4),
      ),
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size * 0.38,
          fontWeight: FontWeight.w800,
          color: Colors.black,
        ),
      ),
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
  });

  final int position;
  final String title;
  final String subtitle;
  final String metric;
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
  ),
  RankingEntry(
    position: 2,
    title: 'Noa の投稿',
    subtitle: '通知に頼らない SNS の実験',
    metric: '144 いいね',
  ),
  RankingEntry(
    position: 3,
    title: 'Ken の投稿',
    subtitle: 'いいね数とレベルの相関メモ',
    metric: '121 いいね',
  ),
];

const totalLikesRanking = [
  RankingEntry(
    position: 1,
    title: 'Mina',
    subtitle: '@mina ・ 日報シリーズ',
    metric: '2.3k いいね',
  ),
  RankingEntry(
    position: 2,
    title: 'Aya Koga',
    subtitle: '@aya ・ ショートノート',
    metric: '1.9k いいね',
  ),
  RankingEntry(
    position: 3,
    title: 'Leo Takada',
    subtitle: '@leo ・ フォーカスログ',
    metric: '1.4k いいね',
  ),
];

const levelRanking = [
  RankingEntry(
    position: 1,
    title: 'Riku',
    subtitle: '@riku ・ 夜間投稿が多い',
    metric: 'Lv.18',
  ),
  RankingEntry(
    position: 2,
    title: 'Sara',
    subtitle: '@sara ・ 朝活メモ',
    metric: 'Lv.16',
  ),
  RankingEntry(
    position: 3,
    title: 'Ken',
    subtitle: '@ken ・ 分析まとめ',
    metric: 'Lv.14',
  ),
];

const followerRanking = [
  RankingEntry(
    position: 1,
    title: 'Noa',
    subtitle: '@noa ・ 静かなタイムライン提案',
    metric: '12.4k フォロワー',
  ),
  RankingEntry(
    position: 2,
    title: 'Aya Koga',
    subtitle: '@aya ・ 日々の一行',
    metric: '9.8k フォロワー',
  ),
  RankingEntry(
    position: 3,
    title: 'Mina',
    subtitle: '@mina ・ まとめ屋',
    metric: '7.1k フォロワー',
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
