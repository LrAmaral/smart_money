import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_money/controller/form_controller.dart';
import 'package:smart_money/services/logger_service.dart';
import 'package:smart_money/widgets/custom_button.dart';
import 'package:smart_money/widgets/modal_input.dart';
import 'package:smart_money/enums/input_type.dart';
import 'package:smart_money/widgets/modal_button.dart';

class Modal extends StatefulWidget {
  final String title;
  final String textButton;
  final VoidCallback? onDelete;
  final bool showTransactionTypeButtons;
  final String transactionTypeButtons;
  final List<Map<String, dynamic>> fields;
  final void Function(Map<String, dynamic> formData) onConfirm;

  const Modal({
    super.key,
    required this.title,
    required this.fields,
    required this.textButton,
    required this.onConfirm,
    this.onDelete,
    this.showTransactionTypeButtons = false,
    this.transactionTypeButtons = "entrada",
  });

  @override
  ModalState createState() => ModalState();
}

class ModalState extends State<Modal> {
  final logger = LoggerService();
  final FormController formController = Get.put(FormController());

  String _transactionType = 'entrada';
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    formController.clearErrorMessage();
    _controllers.addAll({
      for (var field in widget.fields)
        field['label']: TextEditingController(text: field['value'] ?? ''),
    });
    setState(() {
      _transactionType = widget.transactionTypeButtons;
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleConfirm() {
    final Map<String, dynamic> formData = {
      for (var field in widget.fields)
        field['label'] as String: _controllers[field['label']]?.text ?? '',
    };

    formData['Tipo'] = _transactionType;

    widget.onConfirm(formData);

    if (formController.getErrorMessage().isEmpty) {
      Navigator.pop(context);
      formController.clearErrorMessage();
    }
  }

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
                      widget.title,
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
                  children: widget.fields
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
                              controller: _controllers[field['label']],
                            ),
                          ))
                      .toList(),
                ),
                if (widget.showTransactionTypeButtons) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ModalButton(
                          text: 'Entrada',
                          icon: Icon(Icons.arrow_upward,
                              color: colorScheme.onPrimary),
                          buttonColor: _transactionType == 'entrada'
                              ? colorScheme.primary
                              : colorScheme.surface,
                          textColor: _transactionType == 'entrada'
                              ? colorScheme.onPrimary
                              : colorScheme.onSurface,
                          onPressed: () {
                            setState(() {
                              _transactionType = 'entrada';
                            });
                          },
                          isSelected: _transactionType == 'entrada',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ModalButton(
                          text: 'Saída',
                          icon: Icon(Icons.arrow_downward,
                              color: colorScheme.onError),
                          buttonColor: _transactionType == 'saida'
                              ? colorScheme.error
                              : colorScheme.surface,
                          textColor: _transactionType == 'saida'
                              ? colorScheme.onError
                              : colorScheme.onSurface,
                          onPressed: () {
                            setState(() {
                              _transactionType = 'saida';
                            });
                          },
                          isSelected: _transactionType == 'saida',
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                Obx(() {
                  return Text(
                    formController.getErrorMessage(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.error,
                    ),
                  );
                }),
                const SizedBox(height: 24),
                CustomButton(
                  text: widget.textButton,
                  onPressed: _handleConfirm,
                ),
                if (widget.onDelete != null)
                  CustomButton(
                    text: "Deletar",
                    onPressed: () {
                      widget.onDelete?.call();
                      Navigator.pop(context);
                    },
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
