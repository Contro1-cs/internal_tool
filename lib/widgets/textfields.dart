import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_tool/widgets/colors.dart';

emailTextField(context, String title, TextEditingController controller) {
  return Container(
    width: double.infinity,
    alignment: Alignment.center,
    child: TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      style: GoogleFonts.inter(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        labelStyle:
            GoogleFonts.inter(color: black, fontWeight: FontWeight.w500),
        label: Text(title),
        contentPadding: const EdgeInsets.all(15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: black, width: 2),
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
      controller: controller,
      style: GoogleFonts.inter(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        labelStyle:
            GoogleFonts.inter(color: black, fontWeight: FontWeight.w500),
        label: const Text('Password'),
        contentPadding: const EdgeInsets.all(15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: black, width: 2),
        ),
      ),
    ),
  );
}
