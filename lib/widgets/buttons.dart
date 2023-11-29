import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_tool/widgets/colors.dart';

b1Button(String title, Function()? onPressed) {
  return SizedBox(
    height: 50,
    width: double.infinity,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: primary,
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: GoogleFonts.inter(
          color: white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

class CustomizeButton extends StatelessWidget {
  const CustomizeButton({
    super.key,
    this.onPressed,
    required this.title,
    required this.bgColor,
    required this.fontColor,
  });
  final Function()? onPressed;
  final String title;
  final Color bgColor;
  final Color fontColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: bgColor,
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: GoogleFonts.inter(
            color: fontColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
