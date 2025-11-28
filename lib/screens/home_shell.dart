import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/providers.dart';
import 'timeline_screen.dart';
import 'ranking_screen.dart';
import 'profile_screen.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  static const _pages = [
    TimelineScreen(),
    RankingScreen(),
    ProfileScreen(),
  ];

  bool _notificationInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    final notificationService = ref.read(notificationServiceProvider);
    await notificationService.initialize();

    // ログイン済みならトークンを登録
    final authState = ref.read(authProvider);
    if (authState.isLoggedIn) {
      await notificationService.registerDeviceToken();
    }
    _notificationInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final navState = ref.watch(navigationProvider);

    // ログイン状態の変化を監視
    ref.listen<AuthState>(authProvider, (previous, next) {
      // レベルアップイベント
      if (next.levelUpEvent != null && next.levelUpEvent != previous?.levelUpEvent) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.levelUp(next.levelUpEvent!)),
            backgroundColor: Colors.black,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
        ref.read(authProvider.notifier).clearLevelUpEvent();
      }

      // ログイン時にトークン登録
      if (_notificationInitialized &&
          previous?.isLoggedIn == false &&
          next.isLoggedIn == true) {
        ref.read(notificationServiceProvider).registerDeviceToken();
      }

      // ログアウト時にトークン削除
      if (_notificationInitialized &&
          previous?.isLoggedIn == true &&
          next.isLoggedIn == false) {
        ref.read(notificationServiceProvider).unregisterDeviceToken();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: IndexedStack(
          index: navState.currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navState.currentIndex,
        onTap: (index) => ref.read(navigationProvider.notifier).setIndex(index),
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: const IconThemeData(size: 28, color: Colors.black),
        unselectedIconTheme: const IconThemeData(size: 24, color: Colors.black),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.view_agenda_outlined),
            activeIcon: const Icon(Icons.view_agenda),
            label: l10n.navTimeline,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.leaderboard_outlined),
            activeIcon: const Icon(Icons.leaderboard),
            label: l10n.navRanking,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: l10n.navProfile,
          ),
        ],
      ),
    );
  }
}
