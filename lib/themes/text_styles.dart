import 'package:flutter/material.dart';
import 'colors.dart';

// --- Headings ---

/// For large page titles.
/// Style: semi-bold, size 24, primary color
const TextStyle headingDisplay = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w600,
  color: textPrimaryColor,
);

/// For section titles.
/// Style: bold, size 16, primary color
const TextStyle headingSection = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 16,
  color: textPrimaryColor,
);

// --- Body & Paragraphs ---

/// For standard body text.
/// Style: regular, size 14, body text color
const TextStyle bodyRegular = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.normal,
  color: textBodyColor,
);

// --- Buttons ---

/// For text inside ElevatedButtons.
/// Style: semi-bold, size 16, white color
const TextStyle buttonPrimary = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: whiteColor,
);

/// For text inside TextButtons.
/// Style: semi-bold, size 14, primary color
const TextStyle buttonText = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w600,
  color: primaryColor,
);

// --- Inputs & Labels ---

/// For text field input labels.
/// Style: medium, size 14, label text color
const TextStyle inputLabel = TextStyle(
  color: textLabelColor,
  fontWeight: FontWeight.w500,
  fontSize: 14,
);

/// For text entered into a text field.
/// Style: regular, size 14, body text color
const TextStyle inputText = TextStyle(
  color: textBodyColor,
  fontWeight: FontWeight.normal,
  fontSize: 14,
);

// --- Card Specific Styles ---

/// For the main title in a card.
/// Style: bold, size 16, black color
const TextStyle cardTitle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: blackColor,
);

/// For subtitle text in a card (e.g., code, question count).
/// Style: regular, size 12, muted gray color
const TextStyle cardSubtitle = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.normal,
  color: textMutedColor,
);

// --- Forms & Inputs ---

/// For labels above TextFields.
/// Style: bold, size 14, black color
const TextStyle formLabel = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.bold,
  color: blackColor,
);
