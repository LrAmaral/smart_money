import 'package:flutter/material.dart';
import 'package:smart_money/widgets/custom_button.dart';
import 'package:smart_money/widgets/modal_input.dart';
import 'package:smart_money/enums/input_type.dart';

class Modal extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> fields;
  final VoidCallback onConfirm;
  final VoidCallback onDelete;
  final String textButton;

  const Modal({
    super.key,
    required this.title,
    required this.fields,
    required this.onConfirm,
    required this.onDelete,
    required this.textButton,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: keyboardHeight),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.secondary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      child: Icon(
                        Icons.close,
                        color: colorScheme.surfaceTint,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Column(
                  children: fields
                      .map((field) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ModalInput(
                              label: field['label'] ?? '',
                              initialValue: field['value'] ?? '',
                              type: ModalInputType.values.firstWhere(
                                (e) =>
                                    e.toString() ==
                                    'ModalInputType.${field['type'] ?? 'text'}',
                                orElse: () => ModalInputType.text,
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 48),
                CustomButton(
                  text: textButton,
                  onPressed: () {
                    onConfirm();
                    Navigator.pop(context);
                  },
                ),
                if (title == "Editar Meta")
                  CustomButton(
                    text: "Deletar",
                    onPressed: () {},
                    buttonColor: colorScheme.error,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
