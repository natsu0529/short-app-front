import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavigationState {
  final int currentIndex;
  final bool scrollToMyRanking;

  const NavigationState({
    this.currentIndex = 0,
    this.scrollToMyRanking = false,
  });

  NavigationState copyWith({
    int? currentIndex,
    bool? scrollToMyRanking,
  }) {
    return NavigationState(
      currentIndex: currentIndex ?? this.currentIndex,
      scrollToMyRanking: scrollToMyRanking ?? this.scrollToMyRanking,
    );
  }
}

class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier() : super(const NavigationState());

  void setIndex(int index) {
    state = state.copyWith(currentIndex: index, scrollToMyRanking: false);
  }

  void goToRankingWithScroll() {
    state = const NavigationState(currentIndex: 1, scrollToMyRanking: true);
  }

  void clearScrollToMyRanking() {
    state = state.copyWith(scrollToMyRanking: false);
  }
}

final navigationProvider =
    StateNotifierProvider<NavigationNotifier, NavigationState>((ref) {
  return NavigationNotifier();
});
