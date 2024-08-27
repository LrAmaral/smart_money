import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_money/enums/input_type.dart';
import 'package:flutter/services.dart';

class ModalInput extends StatefulWidget {
  final String label;
  final String initialValue;
  final ModalInputType type;
  final TextEditingController? controller;
  final int? n;

  const ModalInput({
    super.key,
    required this.label,
    required this.initialValue,
    required this.type,
    this.controller,
    this.n,
  });

  @override
  _ModalInputState createState() => _ModalInputState();
}

class _ModalInputState extends State<ModalInput> {
  late TextEditingController _controller;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: _controller,
      obscureText: widget.type == ModalInputType.password,
      keyboardType: widget.type == ModalInputType.number
          ? TextInputType.number
          : TextInputType.text,
      onTap: widget.type == ModalInputType.date
          ? () {
              FocusScope.of(context).requestFocus(FocusNode());
              _selectDate(context);
            }
          : null,
      inputFormatters: widget.n != null
          ? [LengthLimitingTextInputFormatter(widget.n)]
          : null,
      decoration: InputDecoration(
        labelText: widget.label,
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
      ),
      style: TextStyle(color: colorScheme.surfaceTint),
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }
}
