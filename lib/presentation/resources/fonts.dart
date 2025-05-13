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
}
