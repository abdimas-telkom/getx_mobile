import 'package:flutter/material.dart';
import 'package:ujian_sd_babakan_ciparay/themes/text_styles.dart';

Widget FormFieldWithLabel({
  required String label,
  required Widget child,
  bool isRequired = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      isRequired
          ? RichText(
              text: TextSpan(
                text: label,
                style: formLabel,
                children: const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : Text(label, style: formLabel),
      const SizedBox(height: 8),
      child,
    ],
  );
}
