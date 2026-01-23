import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTextStyles {
  static const String _pressStart = 'Press Start 2P';
  static const String _roboto = 'Roboto';

  static final TextStyle pressStartRegular20 = GoogleFonts.getFont(
    _pressStart,
    fontWeight: FontWeight.w400,
    fontSize: 20,
  );

  static final TextStyle robotoMedium18 = GoogleFonts.getFont(
    _roboto,
    fontWeight: FontWeight.w500,
    fontSize: 18,
  );

  static final TextStyle robotoRegular15 = GoogleFonts.getFont(
    _roboto,
    fontWeight: FontWeight.w400,
    fontSize: 15,
  );

  static final TextStyle robotoRegular13 = GoogleFonts.getFont(
    _roboto,
    fontWeight: FontWeight.w400,
    fontSize: 13,
  );
}
