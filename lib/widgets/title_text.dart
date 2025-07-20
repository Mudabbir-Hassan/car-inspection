import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  const TitleText(this.text, {super.key, this.fontSize = 22, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color ?? Theme.of(context).colorScheme.primary,
      ),
      textAlign: TextAlign.center,
    );
  }
}
