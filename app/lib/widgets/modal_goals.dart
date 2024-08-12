import 'package:flutter/material.dart';
import 'package:smart_money/widgets/custom_button.dart';
import 'package:smart_money/widgets/custom_input.dart';

class CustomModal extends StatelessWidget {
  final String title;
  final List<Map<String, String>> fields;
  final VoidCallback onConfirm;

  const CustomModal({
    Key? key,
    required this.title,
    required this.fields,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
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
            ...fields.map((field) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CustomInput(
                    labelText: field['label'] ?? '',
                    controller: TextEditingController(),
                  ),
                )),
            const SizedBox(height: 48),
            CustomButton(
              text: "Adicionar",
              onPressed: () {
                onConfirm();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
