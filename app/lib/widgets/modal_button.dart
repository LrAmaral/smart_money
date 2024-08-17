import 'package:flutter/material.dart';

class ModalButton extends StatelessWidget {
  final String text;
  final Icon icon;
  final Color buttonColor;
  final Color textColor;
  final VoidCallback onPressed;
  final bool isSelected;

  const ModalButton({
    super.key,
    required this.text,
    required this.icon,
    required this.buttonColor,
    required this.textColor,
    required this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: buttonColor,
        side: BorderSide(color: buttonColor),
        textStyle: TextStyle(
          color: buttonColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12),
        elevation: isSelected ? 4 : 2,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon.icon,
            color: buttonColor,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: buttonColor,
            ),
          ),
        ],
      ),
    );
  }
}
