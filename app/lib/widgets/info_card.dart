import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_money/model/icon_info.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String value;

  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    IconInfo getIconInfo() {
      if (value.isNotEmpty) {
        String trimmedValue = value.trim();

        if (trimmedValue.startsWith('-')) {
          return IconInfo(
            icon: Icons.arrow_circle_down,
            color: colorScheme.error,
          );
        } else if (trimmedValue.numericOnly() == '000') {
          return IconInfo(
            icon: Icons.horizontal_rule,
            color: colorScheme.onSurface,
          );
        } else {
          return IconInfo(
            icon: Icons.arrow_circle_up,
            color: colorScheme.primary,
          );
        }
      }

      return IconInfo(
        icon: Icons.horizontal_rule,
        color: colorScheme.onSurface,
      );
    }

    IconInfo iconInfo = getIconInfo();

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
                  iconInfo.icon,
                  color: iconInfo.color,
                  size: 28,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: title == 'Saldo Geral'
                  ? iconInfo.color
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
