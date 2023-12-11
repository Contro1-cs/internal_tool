import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_tool/pages/friendsNotice.dart';
import 'package:internal_tool/widgets/colors.dart';
import 'package:internal_tool/widgets/transitions.dart';

customAppBar(String title) {
  return AppBar(
    backgroundColor: bgBlack,
    automaticallyImplyLeading: true,
    iconTheme: IconThemeData(color: white),
    title: Text(
      title,
      style: GoogleFonts.inter(
        color: white,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
    ),
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
  String _name = '';

  //bool
  getpfp() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final ref = FirebaseStorage.instance.ref().child(uid).child('pfp.png');
    final url = await ref.getDownloadURL();

    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (snapshot.exists) {
      _name = snapshot.data()!['username'].toString().split(".").first;
    } else {
      print("Document does not exist");
    }

    setState(() {
      _pfp = url;
    });
  }

  userProfile(String imgUrl, String friendUid) {
    String name = '';
    if (friendUid.startsWith("qZPUmET6haaobfRC6IiiZi8tjQr1")) {
      name = "Pxp";
    } else if (friendUid.startsWith("fw32D23IdahGIKFqb4aVk5tZfeN2")) {
      name = "Pxd";
    }
    return GestureDetector(
      onTap: () {
        slideUpTransition(context, FriendsNoticePage(friendUid: friendUid));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            margin: const EdgeInsets.symmetric(horizontal: 10),
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
          Text(
            name,
            style: GoogleFonts.inter(color: white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Your pfp
          Column(
            children: [
              Container(
                height: 60,
                width: 60,
                margin: const EdgeInsets.symmetric(horizontal: 10),
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
              Text(
                _name,
                style: GoogleFonts.inter(color: white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          //Friends
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              height: 80,
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
