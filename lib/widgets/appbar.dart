import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  userProfile(String imgUrl, String friendUid) {
    return Column(
      children: [
        Container(
          width: 60,
          margin: const EdgeInsets.only(left: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: yellow,
            shape: BoxShape.circle,
          ),
          child: imgUrl.isEmpty
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.all(1),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: imgUrl,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 0.5,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Future<String?> _getImageUrl(String folderName) async {
    final storageRef =
        FirebaseStorage.instance.ref().child(folderName).child("pfp.png");

    try {
      String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error fetching image: $e');
      return null;
    }
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
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(1),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: _pfp,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 0.5,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
          ),

          //Friends
          Expanded(
            child: SizedBox(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.friends.length,
                itemBuilder: (context, index) {
                  String friendUid = widget.friends[index];

                  return FutureBuilder(
                    future: _getImageUrl(friendUid),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      String imageUrl = snapshot.data.toString();
                      if (snapshot.connectionState == ConnectionState.done) {
                        return userProfile(imageUrl, friendUid);
                      }
                      return const SizedBox();
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
