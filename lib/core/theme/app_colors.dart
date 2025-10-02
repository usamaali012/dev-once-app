import 'package:flutter/material.dart';

/// Central place for app color definitions.
abstract final class AppColors {
  static const Color primary = Color(0xFF02B3BD);
  static const Color secondary = Color(0xFF0F6679);
  static const Color grey = Color(0xFF808A93);
}

/// Reusable gradients live here to keep styling consistent.
abstract final class AppGradients {
  static const LinearGradient primaryButton = LinearGradient(
    colors: [Color(0xFF8C4CF4), Color(0xFF6637EE)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
