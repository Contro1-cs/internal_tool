import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  //String
  String _pfp = '';

  //bool
  bool _pfpLoading = true;
  getpfp() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseStorage.instance.ref().child(uid).child('pfp.png');
    final url = await ref.getDownloadURL();
    setState(() {
      _pfp = url;
    });
  }

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
  void initState() {
    super.initState();
    getpfp();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Row(
        children: [
          //Your pfp
          Container(
            height: 60,
            width: 60,
            margin: const EdgeInsets.only(left: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: yellow,
              shape: BoxShape.circle,
            ),
            child: _pfp.isEmpty
                ? const CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.all(1),
                    child: ClipOval(
                      child: Image(
                        image: NetworkImage(_pfp),
                      ),
                    ),
                  ),
          ),

          //Friends
          Expanded(
            child: SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.friends.length,
                itemBuilder: (context, index) {
                  return userProfile(widget.friends[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
