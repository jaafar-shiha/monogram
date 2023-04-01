import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monogram/Constants/app_colors.dart';

class AppStyles {
  static InputDecoration textFormFieldDecoration(
          {required String label, required Widget prefixIcon, Widget? suffixIcon}) =>
      InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(
          color: Colors.black,
        ),
        filled: true,
        fillColor: AppColors.monogramGrey.withOpacity(0.3),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 1.0,
          ),
        ),
      );

  static TextStyle h1 = GoogleFonts.poppins(
    fontSize: 24,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  );

  static TextStyle h2GreyBold = GoogleFonts.poppins(
    color: AppColors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );


  static TextStyle h2 = GoogleFonts.poppins(
    color: Colors.black,
    fontSize: 18,
  );

  static TextStyle h3 = GoogleFonts.poppins(
    fontSize: 14,
    color: Colors.black,
    letterSpacing: 1,
  );

  static TextStyle h4 = GoogleFonts.poppins(
    fontSize: 12,
    color: Colors.black,
    letterSpacing: 1,
  );
}
