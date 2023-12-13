import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle customGoogleFont({double? fontSize, Color? color}) {
  return GoogleFonts.nunito(
    fontSize: fontSize ?? 12,
    color: color ?? Colors.white,
  );
}

TextStyle customTitleFont({double? fontSize, Color? color}) {
  return GoogleFonts.nunito(
    fontSize: 24,
    color: color ?? Colors.white,
  );
}

TextStyle customContentFont({double? fontSize, Color? color}) {
  return GoogleFonts.nunito(
    fontWeight: FontWeight.w400,
    fontSize: 20,
    color: color ?? Colors.white,
  );
}

TextStyle customAuthorFont({double? fontSize, Color? color}) {
  return GoogleFonts.nunito(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    fontSize: 18,
    color: color ?? Colors.white,
  );
}
