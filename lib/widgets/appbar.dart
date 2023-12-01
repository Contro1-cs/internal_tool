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
  const HomeAppBar({
    super.key,
    required this.friends,
  });
  final List friends;

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  userProfile(String name) {
    return Container(
      height: 60,
      width: 60,
      margin: const EdgeInsets.only(left: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: yellow,
        shape: BoxShape.circle,
      ),
      child: Text(
        name[0].toUpperCase(),
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(
          fontSize: 35,
          color: const Color(0xff8e7000),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: SizedBox(
        height: 60,
        width: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.friends.length,
          itemBuilder: (context, index) {
            return userProfile(widget.friends[index]);
          },
        ),
      ),
    );
  }
}
