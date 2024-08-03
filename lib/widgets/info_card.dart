import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;

  const InfoCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    double? valueParsed;
    if (title == 'Saldo Geral') {
      valueParsed =
          double.tryParse(value.replaceAll('R\$', '').replaceAll(',', '')) ??
              0.0;
    }

    IconData getIconData() {
      if (valueParsed != null) {
        if (valueParsed > 0) {
          return Icons.arrow_circle_up;
        } else if (valueParsed < 0) {
          return Icons.arrow_circle_down;
        } else {
          return Icons.horizontal_rule;
        }
      }
      return Icons.horizontal_rule;
    }

    Color getIconColor() {
      if (valueParsed != null) {
        if (valueParsed > 0) {
          return colorScheme.primary;
        } else if (valueParsed < 0) {
          return colorScheme.error;
        }
      }
      return colorScheme.onSurface;
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(color: colorScheme.onPrimary),
              ),
              if (title == 'Saldo Geral')
                Icon(
                  getIconData(),
                  color: getIconColor(),
                  size: 28,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: title == 'Saldo Geral'
                  ? getIconColor()
                  : colorScheme.onSurface,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }
}
