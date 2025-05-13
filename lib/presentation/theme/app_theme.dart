import 'package:flutter/material.dart';
import '/presentation/resources/resources.dart';

class AppTheme {
  static const String _fontFamily = 'Roboto';

  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue, // Keeps some defaults blue
      scaffoldBackgroundColor: AppColors.whiteColor,
      fontFamily: _fontFamily,
      colorScheme: const ColorScheme.light(
        onPrimaryContainer: AppColors.backgroundColor,
        primary: AppColors.primaryBlue,
        secondary: AppColors.primaryBlue, // Can be same or different
        surface:
            AppColors.surfaceColor, // Background for cards, text fields etc.
        background: AppColors.whiteColor, // Overall background
        error: Colors.red, // Default error color
        onPrimary: AppColors.whiteColor, // Text/icons on primary color
        onSecondary: AppColors.whiteColor, // Text/icons on secondary color
        onSurface: AppColors.darkTextColor, // Text/icons on surface color
        onBackground: AppColors.darkTextColor, // Text/icons on background color
        onError: AppColors.whiteColor, // Text/icons on error color
        brightness: Brightness.light,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: AppColors.primaryBlue,
            width: 1.5,
          ),
        ),
        labelStyle: const TextStyle(color: AppColors.greyTextColor),
        hintStyle: TextStyle(color: AppColors.greyTextColor.withOpacity(0.8)),
        prefixIconColor: AppColors.greyTextColor,
        filled: true,
        fillColor: AppColors.surfaceColor, // Use surface color for fill
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: AppColors.whiteColor,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: _fontFamily,
          ),
          minimumSize: const Size(0, 50),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryBlue,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: _fontFamily,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkTextColor,
          side: const BorderSide(color: AppColors.borderColor, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: _fontFamily,
          ),
          minimumSize: const Size(0, 50),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: EdgeInsets.zero,
        color: AppColors.surfaceColor, // Explicitly set card color
        shadowColor: Colors.black.withOpacity(0.1), // Subtle shadow
      ),
      iconTheme: const IconThemeData(
        color: AppColors.greyTextColor,
      ), // Default icon color
      appBarTheme: const AppBarTheme(
        // Basic AppBar theme if needed later
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: AppColors.darkTextColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.darkTextColor),
        titleTextStyle: TextStyle(
          color: AppColors.darkTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: _fontFamily,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.darkTextColor, fontSize: 16),
        bodyMedium: TextStyle(color: AppColors.greyTextColor, fontSize: 14),
        titleLarge: TextStyle(
          color: AppColors.darkTextColor,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: AppColors.darkTextColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        labelLarge: TextStyle(
          color: AppColors.whiteColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ).apply(fontFamily: _fontFamily),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,

      primarySwatch: Colors.blue, // Base color swatch
      scaffoldBackgroundColor: AppColors.darkBackground,

      fontFamily: _fontFamily,
      colorScheme: const ColorScheme.dark(
        onPrimaryContainer: Colors.black,
        primary: AppColors.primaryBlue, // Keep primary blue accent
        secondary: AppColors.primaryBlue,
        surface:
            AppColors.darkSurface, // Dark background for cards, text fields
        background: AppColors.darkBackground, // Overall dark background
        error: Colors.redAccent, // Slightly brighter error for dark
        onPrimary: AppColors.whiteColor, // Text on primary blue
        onSecondary: AppColors.whiteColor,
        onSurface: AppColors.lightTextColor, // Light text on dark surface
        onBackground: AppColors.lightTextColor, // Light text on dark background
        onError: AppColors.darkTextColor, // Dark text on error color
        brightness: Brightness.dark,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.darkBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.darkBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: AppColors.primaryBlue,
            width: 1.5,
          ), // Keep focus blue
        ),
        labelStyle: const TextStyle(
          color: AppColors.lightGreyTextColor,
        ), // Lighter grey label
        hintStyle: TextStyle(
          color: AppColors.lightGreyTextColor.withOpacity(0.8),
        ),
        prefixIconColor: AppColors.lightGreyTextColor, // Lighter grey icon
        filled: true,
        fillColor: AppColors.darkSurface, // Use dark surface color for fill
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue, // Keep primary blue button
          foregroundColor: AppColors.whiteColor, // White text on blue button
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: _fontFamily,
          ),
          minimumSize: const Size(0, 50),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryBlue, // Keep link color blue
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: _fontFamily,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor:
              AppColors.lightTextColor, // Light text for outlined button
          side: const BorderSide(
            color: AppColors.darkBorderColor,
            width: 1.5,
          ), // Darker border
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: _fontFamily,
          ),
          minimumSize: const Size(0, 50),
        ),
      ),
      cardTheme: CardTheme(
        elevation:
            3, // Slightly reduce elevation visibility in dark mode if desired
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: EdgeInsets.zero,
        color: AppColors.darkSurface, // Explicitly set dark card color
        shadowColor: Colors.black.withOpacity(0.3), // Darker shadow base
      ),
      iconTheme: const IconThemeData(
        color: AppColors.lightGreyTextColor,
      ), // Default icon color light grey
      appBarTheme: const AppBarTheme(
        // Basic AppBar theme for dark mode
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.lightTextColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.lightTextColor),
        titleTextStyle: TextStyle(
          color: AppColors.lightTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: _fontFamily,
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.lightTextColor, fontSize: 16),
        bodyMedium: TextStyle(
          color: AppColors.lightGreyTextColor,
          fontSize: 14,
        ),
        titleLarge: TextStyle(
          color: AppColors.lightTextColor,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: AppColors.lightTextColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        labelLarge: TextStyle(
          // Button text on primary color (ElevatedButton)
          color: AppColors.whiteColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ).apply(fontFamily: _fontFamily),
    );
  }
}
