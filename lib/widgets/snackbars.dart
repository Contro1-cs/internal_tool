import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

errorSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 2000),
      content: Text(
        message,
        style: GoogleFonts.inter(color: Colors.white),
      ),
      backgroundColor: const Color(0xffFF7F7F),
    ),
  );
}

successSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(milliseconds: 2000),
      content: Text(
        message,
        style: GoogleFonts.inter(color: Colors.black),
      ),
      backgroundColor: const Color(0xff7FFF84),
    ),
  );
}
