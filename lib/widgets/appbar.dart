import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_tool/widgets/colors.dart';

customAppBar(String title) {
  return AppBar(
    backgroundColor: white,
    automaticallyImplyLeading: true,
    title: Text(
      title,
      style: GoogleFonts.inter(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    centerTitle: true,
  );
}

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            // margin: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(color: lightGrey, shape: BoxShape.circle),
          ),
          Container(
            height: 60,
            width: 60,
            margin: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(color: lightGrey, shape: BoxShape.circle),
          ),
          Container(
            height: 60,
            width: 60,
            margin: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(color: lightGrey, shape: BoxShape.circle),
          ),
        ],
      ),
    );
  }
}
