import 'package:flutter/material.dart';
import 'package:ujian_sd_babakan_ciparay/themes/text_styles.dart';

Widget SwitchRow({
  required String title,
  required String subtitle,
  required bool value,
  required ValueChanged<bool> onChanged,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: formLabel),
            const SizedBox(height: 4),
            Text(subtitle, style: cardSubtitle.copyWith(fontSize: 13)),
          ],
        ),
      ),
      Switch(value: value, onChanged: onChanged),
    ],
  );
}
