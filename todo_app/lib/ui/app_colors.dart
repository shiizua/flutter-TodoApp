import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4E7D96); // #4e7d96
  static const Color accent = Color(0xFFFF844B); // #ff844b
  static const Color pale = Color(0xFFE3EDF2); // #e3edf2
  static const Color dark = Color(0xFF0A0D25); // #0a0d25

  static const Gradient headerGradient = LinearGradient(
    colors: [primary, Color(0xFF6BA0B6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
