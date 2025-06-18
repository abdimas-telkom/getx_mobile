import 'package:flutter/material.dart';
import 'package:ujian_sd_babakan_ciparay/themes/text_styles.dart';

Widget FormFieldWithLabel({required String label, required Widget child}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: formLabel),
      const SizedBox(height: 8),
      child,
    ],
  );
}
