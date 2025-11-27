import 'package:flutter/material.dart';
import '../models/models.dart';
import '../l10n/app_localizations.dart';
import 'mono_card.dart';
import 'mono_text.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    this.onTap,
    this.onLikeTap,
    this.source,
  });

  final Post post;
  final VoidCallback? onTap;
  final VoidCallback? onLikeTap;
  final String? source;

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: MonoCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${post.user.userName} ・ ${_localizedTime(context, post.timeAgo)}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              post.context,
              style: MonoText.body,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onLikeTap,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    children: [
                      Icon(
                        post.isLiked ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: post.isLiked ? Colors.red : Colors.black,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.likesCount(post.likeCount.toString()),
                        style: MonoText.subtitle,
                      ),
                    ],
                  ),
                ),
                if (source != null)
                  Text(
                    _localizedSource(context, source!),
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
