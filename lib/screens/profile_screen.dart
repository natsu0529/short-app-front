import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';
import 'profile_detail_screen.dart';
import 'follow_list_screen.dart';
import 'auth/login_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final ScrollController _likedScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  @override
  void dispose() {
    _likedScrollController.dispose();
    super.dispose();
  }

  void _loadProfile() {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser != null) {
      ref.read(profileProvider.notifier).loadProfile(currentUser.userId);
    }
  }

  void _scrollLikedToTop() {
    _likedScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _openProfileFromPost(Post post) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProfileDetailScreen(userId: post.user.userId),
      ),
    );
  }

  void _openFollowingList() {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FollowListScreen(
          userId: currentUser.userId,
          initialTab: 0,
        ),
      ),
    );
  }

  void _openFollowersList() {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FollowListScreen(
          userId: currentUser.userId,
          initialTab: 1,
        ),
      ),
    );
  }

  void _goToMyRanking() {
    ref.read(navigationProvider.notifier).goToRankingWithScroll();
  }

  void _openEditDialog() {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    final nameController = TextEditingController(text: currentUser.userName);
    final bioController = TextEditingController(text: currentUser.userBio);
    final urlController = TextEditingController(text: currentUser.userUrl);

    showDialog<void>(
      context: context,
      builder: (context) => _ProfileEditDialog(
        nameController: nameController,
        bioController: bioController,
        urlController: urlController,
        onSave: () async {
          await ref.read(profileProvider.notifier).updateProfile(
                userId: currentUser.userId,
                userName: nameController.text,
                userBio: bioController.text,
                userUrl: urlController.text,
              );
          await ref.read(authProvider.notifier).refreshUser();
          if (context.mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.profileSaved),
                backgroundColor: Colors.black,
              ),
            );
          }
        },
        onLogout: () async {
          await ref.read(authProvider.notifier).signOut();
          if (context.mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.loggedOut),
                backgroundColor: Colors.black,
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final profileState = ref.watch(profileProvider);

    // Show login screen if not logged in
    if (!authState.isLoggedIn) {
      return const LoginScreen(embedded: true);
    }

    final currentUser = authState.user!;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProfileHeader(
            user: currentUser,
            onEditTap: _openEditDialog,
          ),
          const SizedBox(height: 16),
          _ProfileStats(
            user: currentUser,
            onFollowingTap: _openFollowingList,
            onFollowersTap: _openFollowersList,
            onRankingTap: _goToMyRanking,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _LikedPostsSection(
              posts: profileState.likedPosts,
              isLoading: profileState.isLoadingLikedPosts,
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

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.user,
    this.onEditTap,
  });

  final User user;
  final VoidCallback? onEditTap;

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
                      user.userName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
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
        ),
        Positioned(
          right: 0,
          bottom: -24,
          child: GestureDetector(
            onTap: onEditTap,
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

class _ProfileStats extends StatelessWidget {
  const _ProfileStats({
    required this.user,
    this.onFollowingTap,
    this.onFollowersTap,
    this.onRankingTap,
  });

  final User user;
  final VoidCallback? onFollowingTap;
  final VoidCallback? onFollowersTap;
  final VoidCallback? onRankingTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MonoCard(
      child: Column(
        children: [
          Row(
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
                label: l10n.myRanking,
                value: user.rank != null ? '#${user.rank}' : '-',
                onTap: onRankingTap,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _StatBlock(
                label: l10n.following,
                value: '${user.stats?.followingCount ?? 0}',
                onTap: onFollowingTap,
              ),
              _StatBlock(
                label: l10n.followers,
                value: '${user.stats?.followerCount ?? 0}',
                onTap: onFollowersTap,
              ),
              const _LanguageStatBlock(),
            ],
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
                // Import and call ShortTextApp.setLocale
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
    required this.isLoading,
    required this.controller,
    required this.onHeaderTap,
    this.onPostTap,
  });

  final List<Post> posts;
  final bool isLoading;
  final ScrollController controller;
  final VoidCallback onHeaderTap;
  final ValueChanged<Post>? onPostTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onHeaderTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Center(
              child: Text(
                l10n.likedPosts,
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
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                )
              : posts.isEmpty
                  ? Center(child: Text(l10n.noPosts))
                  : ListView.separated(
                      controller: controller,
                      itemBuilder: (context, index) => PostCard(
                        post: posts[index],
                        onTap: onPostTap != null
                            ? () => onPostTap!(posts[index])
                            : null,
                        source: 'Liked',
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemCount: posts.length,
                    ),
        ),
      ],
    );
  }
}

class _ProfileEditDialog extends StatelessWidget {
  const _ProfileEditDialog({
    required this.nameController,
    required this.bioController,
    required this.urlController,
    required this.onSave,
    required this.onLogout,
  });

  final TextEditingController nameController;
  final TextEditingController bioController;
  final TextEditingController urlController;
  final VoidCallback onSave;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.black.withValues(alpha: 0.5),
        body: GestureDetector(
          onTap: () {},
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
                      l10n.editProfile,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(l10n.name, nameController),
                    const SizedBox(height: 12),
                    _buildTextField(l10n.bio, bioController, maxLines: 3),
                    const SizedBox(height: 12),
                    _buildTextField(l10n.url, urlController),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black,
                              side: const BorderSide(
                                  color: Colors.black, width: 1.2),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              l10n.cancel,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
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
                            onPressed: onSave,
                            child: Text(
                              l10n.save,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w800),
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
                        onPressed: onLogout,
                        child: Text(
                          l10n.logout,
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
