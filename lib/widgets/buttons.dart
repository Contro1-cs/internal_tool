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
        backgroundColor: boardCyan,
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style: GoogleFonts.inter(
          color: black,
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
    this.borderColor,
    required this.child,
    required this.bgColor,
  });
  final Function()? onPressed;
  final Color? borderColor;
  final Widget child;
  final Color bgColor;

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
            side: BorderSide(
                color: borderColor ?? Colors.transparent, width: 0.1),
          ),
          onPressed: onPressed,
          child: child),
    );
  }
}
