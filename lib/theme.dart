import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodChainTheme {
  // Brand Colors
  static const Color primaryOrange = Color(0xFFF28F1D);
  static const Color secondaryBrown = Color(0xFF8B5E3C);
  static const Color darkCharcoal = Color(0xFF232323);
  static const Color accentBrownText = Color(0xFF7A4B00);
  
  // Backgrounds
  static const Color bgCreamStart = Color(0xFFFFF9F3);
  static const Color bgCreamEnd = Color(0xFFFAF5EF);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color inputBg = Color(0xFFF6F2ED);
  static const Color greyText = Color(0xFF757575);
  
  // Status Colors
  static const Color successGreen = Color(0xFF00C897);
  static const Color successBg = Color(0xFFE8F9F5);
  static const Color dangerRed = Color(0xFFD32F2F);
  static const Color dangerBg = Color(0xFFFFEBEE);

  // Gradients
  static const LinearGradient creamGradient = LinearGradient(
    colors: [bgCreamStart, bgCreamEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryOrange,
      scaffoldBackgroundColor: bgCreamEnd,
      colorScheme: ColorScheme.light(
        primary: primaryOrange,
        secondary: secondaryBrown,
        background: bgCreamEnd,
        surface: cardWhite,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: darkCharcoal,
        onSurface: darkCharcoal,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          color: darkCharcoal,
        ),
        displayMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          color: darkCharcoal,
        ),
        displaySmall: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          color: darkCharcoal,
        ),
        headlineLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          color: darkCharcoal,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          color: darkCharcoal,
        ),
        headlineSmall: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          color: darkCharcoal,
        ),
        titleLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          color: darkCharcoal,
        ),
        titleMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.w500,
          color: darkCharcoal,
        ),
        bodyLarge: GoogleFonts.inter(
          color: darkCharcoal,
        ),
        bodyMedium: GoogleFonts.inter(
          color: greyText,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryOrange,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: darkCharcoal),
        titleTextStyle: GoogleFonts.outfit(
          color: darkCharcoal,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
    );
  }
}
