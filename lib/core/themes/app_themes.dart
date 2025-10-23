import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Warna utama & warna pendukung
  static const Color primaryColor = Color(0xFF4B72FF);
  static const Color secondaryColor = Color(0xFFF5F7FF);
  static const Color backgroundColor = Color(0xFFFDFDFD);

  // Light theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(
      const TextTheme(
        bodyMedium: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 1.2,
        ),
      ),
    ),
    shadowColor: Colors.black.withOpacity(0.25),
    // Hover effect nanti bisa dipakai untuk Button / Card custom
    hoverColor: Colors.grey.withOpacity(0.05),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
  );
}
