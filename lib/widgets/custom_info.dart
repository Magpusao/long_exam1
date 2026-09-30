import 'package:flutter/material.dart';

class CustomInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const CustomInfo({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(icon, size: 18), const SizedBox(width: 6), Text(text)],
    );
  }
}
