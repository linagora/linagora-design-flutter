import 'package:flutter/material.dart';

class DialogButtonProperties {
  const DialogButtonProperties({
    required this.label,
    required this.labelColor,
    required this.backgroundColor,
    required this.onPressed,
  });

  final String label;
  final Color? labelColor;
  final Color? backgroundColor;
  final VoidCallback? onPressed;
}
