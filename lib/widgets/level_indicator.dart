import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class LevelIndicator extends StatelessWidget {
  const LevelIndicator({
    super.key,
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
