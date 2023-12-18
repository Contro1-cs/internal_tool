import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_tool/widgets/colors.dart';

emailTextField(context, String title, TextEditingController controller) {
  return Container(
    width: double.infinity,
    alignment: Alignment.center,
    child: TextFormField(
      cursorColor: white,
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      style: GoogleFonts.inter(
        color: white,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        labelStyle: GoogleFonts.inter(
          color: lightGrey,
          fontWeight: FontWeight.w500,
        ),
        label: Text(title),
        contentPadding: const EdgeInsets.all(15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: white, width: 2),
        ),
      ),
    ),
  );
}

customTextField(
    context, String title, TextEditingController controller, Color fontColor) {
  return Container(
    width: double.infinity,
    alignment: Alignment.center,
    child: TextFormField(
      keyboardType: TextInputType.text,
      controller: controller,
      cursorColor: fontColor,
      style: GoogleFonts.inter(
        color: fontColor,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        labelStyle: GoogleFonts.inter(
          color: fontColor.withOpacity(0.5),
          fontWeight: FontWeight.w500,
        ),
        label: Text(title),
        contentPadding: const EdgeInsets.all(15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: fontColor, width: 2),
        ),
      ),
    ),
  );
}

passwordTextField(
  context,
  TextEditingController controller,
  Function()? onTap,
) {
  return Container(
    width: double.infinity,
    alignment: Alignment.center,
    child: TextFormField(
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      cursorColor: white,
      controller: controller,
      style: GoogleFonts.inter(
        color: white,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        labelStyle: GoogleFonts.inter(
          color: white,
          fontWeight: FontWeight.w500,
        ),
        label: const Text('Password'),
        contentPadding: const EdgeInsets.all(15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: white, width: 2),
        ),
      ),
    ),
  );
}
