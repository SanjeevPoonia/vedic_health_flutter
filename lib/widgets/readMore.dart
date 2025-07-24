import 'package:flutter/material.dart';
import 'package:vedic_health/utils/app_theme.dart';

class ReadMoreText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle? style;

  const ReadMoreText({
    Key? key,
    required this.text,
    this.maxLines = 3,
    this.style,
  }) : super(key: key);

  @override
  _ReadMoreTextState createState() => _ReadMoreTextState();
}

class _ReadMoreTextState extends State<ReadMoreText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: widget.style ?? const TextStyle(fontSize: 14.5, color: Color(0xFF696969)),
          maxLines: isExpanded ? null : widget.maxLines,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Text(
            isExpanded ? 'Show less' : 'Read more',
            style: const TextStyle(color: AppTheme.orangeColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
