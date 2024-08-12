import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Size? size;
  final bool showArrowIcon;
  final double textSize;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.size = const Size(120, 40),
    this.showArrowIcon = false,
    this.textSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        minimumSize: size,
        padding: EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
                fontSize: textSize),
          ),
          if (showArrowIcon) ...[
            const SizedBox(width: 4),
            Icon(Icons.arrow_forward, color: colorScheme.onPrimary),
          ],
        ],
      ),
    );
  }
}
