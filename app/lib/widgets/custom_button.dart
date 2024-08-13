import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Size? size;
  final bool showArrowIcon;
  final double textSize;
  final Color? buttonColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.size = const Size(120, 40),
    this.showArrowIcon = false,
    this.textSize = 16,
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final bool isDeleteButton = buttonColor == Colors.red;
    final Color backgroundColor = isDeleteButton
        ? Colors.transparent
        : (buttonColor ?? colorScheme.primary);
    final Color borderColor =
        isDeleteButton ? Colors.red : (buttonColor ?? colorScheme.primary);
    final Color textColor = isDeleteButton ? Colors.red : colorScheme.onPrimary;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: borderColor,
        minimumSize: size,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: borderColor, width: 2),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: textSize,
            ),
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
