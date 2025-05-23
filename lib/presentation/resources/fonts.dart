import 'package:fe_core_vips/presentation/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Títulos Grandes (Ej: "Cómo te llamas?")
  static TextStyle get headlineLarge => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // Títulos Medios (Ej: "Prueba de Nivel")
  static TextStyle get headlineMedium => GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: const Color.fromARGB(255, 67, 61, 61),
  );

  // Item hijos - sidebar
  static TextStyle get subtitle => GoogleFonts.gothicA1(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  //title solicitudes
  static TextStyle get titleSolicitudes => GoogleFonts.gothicA1(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: Colors.black,
    letterSpacing: -0.1,
  );

  //subtitel
  static TextStyle get subtitleSolicitudes => GoogleFonts.gothicA1(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
    letterSpacing: -0.1,
  );

  static TextStyle get titleColum => GoogleFonts.gothicA1(
    fontSize: 13,
    fontWeight: FontWeight.w800,
    color: Colors.black,
    letterSpacing: -0.1,
  );

  static TextStyle get titleColumTwo => GoogleFonts.gothicA1(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: Colors.black,
    letterSpacing: -0.1,
  );

  static TextStyle get subtitleColum => GoogleFonts.gothicA1(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: Colors.grey,
    letterSpacing: -0.1,
  );

  static TextStyle get titlekpi => GoogleFonts.gothicA1(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: Colors.grey.shade600,
    letterSpacing: -0.1,
  );

  static TextStyle get itensGender => GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: const Color.fromARGB(255, 53, 49, 49),
  );

  // Text styles for perfil
  static TextStyle get _base => GoogleFonts.nunitoSans();

  static TextStyle headline1 = _base.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static TextStyle headline2 = _base.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle subtitle1 = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyText1 = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodyText2 = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static TextStyle button = _base.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );

  static TextStyle caption = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static TextStyle label = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );
}
