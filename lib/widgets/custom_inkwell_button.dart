import 'package:flutter/material.dart';

class CustomInkWellButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const CustomInkWellButton({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: child,
    );
  }
}
