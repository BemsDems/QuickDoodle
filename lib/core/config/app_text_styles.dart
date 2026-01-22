import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTextStyles {
  static const String _pressStart = 'Press Start 2P';
  static const String _roboto = 'Roboto';

  static final TextStyle _pressStartRegular20 = GoogleFonts.getFont(
    _pressStart,
    fontWeight: FontWeight.w400,
    fontSize: 20,
  );

  static final TextStyle _robotoMedium17 = GoogleFonts.getFont(
    _roboto,
    fontWeight: FontWeight.w500,
    fontSize: 17,
  );

  static final TextStyle _robotoRegular14 = GoogleFonts.getFont(
    _roboto,
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  static final TextStyle _robotoRegular12 = GoogleFonts.getFont(
    _roboto,
    fontWeight: FontWeight.w400,
    fontSize: 12,
  );
}
