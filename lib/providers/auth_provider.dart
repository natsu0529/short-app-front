import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/services.dart';
import 'service_providers.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isInitialized;
  final int? levelUpEvent; // レベルアップ時に新しいレベルを保持

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isInitialized = false,
    this.levelUpEvent,
  });

  bool get isLoggedIn => user != null;

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isInitialized,
    int? levelUpEvent,
    bool clearUser = false,
    bool clearError = false,
    bool clearLevelUpEvent = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      isInitialized: isInitialized ?? this.isInitialized,
      levelUpEvent: clearLevelUpEvent ? null : (levelUpEvent ?? this.levelUpEvent),
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState());

  Future<void> initialize() async {
    if (state.isInitialized) return;

    state = state.copyWith(isLoading: true);
    try {
      final user = await _authService.refreshCurrentUser();
      state = AuthState(
        user: user,
        isInitialized: true,
      );
    } catch (e) {
      state = AuthState(
        isInitialized: true,
        error: e.toString(),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    print('AuthNotifier: signInWithGoogle called');
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _authService.signInWithGoogle();
      print('AuthNotifier: signInWithGoogle success, user: $user');
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      print('AuthNotifier: signInWithGoogle error: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signInWithEmailPassword(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _authService.signInWithEmailPassword(email, password);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> register({
    required String username,
    required String displayName,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _authService.register(
        username: username,
        displayName: displayName,
        email: email,
        password: password,
      );
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      await _authService.signOut();
      state = state.copyWith(isLoading: false, clearUser: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refreshUser() async {
    try {
      final previousLevel = state.user?.userLevel;
      final user = await _authService.refreshCurrentUser();
      if (user != null) {
        // レベルアップを検知
        if (previousLevel != null && user.userLevel > previousLevel) {
          state = state.copyWith(user: user, levelUpEvent: user.userLevel);
        } else {
          state = state.copyWith(user: user);
        }
      }
    } catch (e) {
      // Silently fail on refresh
    }
  }

  void clearLevelUpEvent() {
    state = state.copyWith(clearLevelUpEvent: true);
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoggedIn;
});
