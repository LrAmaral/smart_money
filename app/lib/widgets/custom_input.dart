import 'package:flutter/material.dart';

class CustomInput extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final bool obscureText;
  final bool enable;

  const CustomInput({
    super.key,
    required this.labelText,
    required this.controller,
    this.obscureText = false,
    this.enable = true,
  });

  @override
  CustomInputState createState() => CustomInputState();
}

class CustomInputState extends State<CustomInput> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: widget.controller,
      obscureText: _obscureText,
      enabled: widget.enable,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: TextStyle(color: colorScheme.surfaceTint),
        filled: true,
        isDense: true,
        fillColor: Colors.transparent,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.surfaceTint),
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: _obscureText
                    ? Icon(
                        Icons.visibility_off,
                        color: colorScheme.surfaceTint,
                      )
                    : Icon(
                        Icons.visibility,
                        color: colorScheme.surfaceTint,
                      ),
              )
            : null,
      ),
      style: TextStyle(color: colorScheme.surfaceTint),
    );
  }
}
