import 'package:flutter/material.dart';

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
