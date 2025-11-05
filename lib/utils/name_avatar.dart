import 'package:flutter/material.dart';
import 'dart:math';
class NameAvatar extends StatelessWidget {
  final String? fullName;
  final double size;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final bool useRandomColor;

  const NameAvatar({
    Key? key,
    required this.fullName,
    this.size = 48.0,
    this.textStyle,
    this.backgroundColor,
    this.useRandomColor = true,
  }) : super(key: key);

  /// Extracts up to 2 initials from the fullName.
  String _getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      // Single word: take first two characters (if exist)
      final w = parts[0];
      return w.length >= 2
          ? (w[0] + w[1]).toUpperCase()
          : w[0].toUpperCase();
    } else {
      // Multiword: take first char of first and last word
      final first = parts.first[0];
      final last = parts.last[0];
      return (first + last).toUpperCase();
    }
  }

  /// Generate a consistent color from the name string.
  Color _colorFromName(String? name) {
    if (backgroundColor != null) return backgroundColor!;
    final seed = (name ?? '').runes.fold<int>(0, (p, c) => p + c);
    final rand = Random(seed);
    // create pastel-ish color
    final hue = rand.nextDouble() * 360;
    final saturation = 0.35 + rand.nextDouble() * 0.25; // 0.35-0.6
    final lightness = 0.45 + rand.nextDouble() * 0.2;  // 0.45-0.65
    return HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(fullName);
    final bgColor = useRandomColor ? _colorFromName(fullName) : (backgroundColor ?? Theme.of(context).primaryColor);
    final style = textStyle ??
        TextStyle(
          color: Colors.white,
          fontSize: size * 0.4,
          fontWeight: FontWeight.w600,
        );

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: bgColor,
      child: Text(
        initials,
        style: style,
      ),
    );
  }
}