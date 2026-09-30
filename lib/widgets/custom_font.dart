import 'package:flutter/material.dart';

class CustomFont extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  const CustomFont(this.text, {super.key, this.style, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: const TextStyle(fontFamily: 'Frutiger').merge(style),
    );
  }
}
