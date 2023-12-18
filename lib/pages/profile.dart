import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_tool/pages/onboarding.dart';
import 'package:internal_tool/widgets/appbar.dart';
import 'package:internal_tool/widgets/buttons.dart';
import 'package:internal_tool/widgets/colors.dart';
import 'package:internal_tool/widgets/snackbars.dart';
import 'package:internal_tool/widgets/textfields.dart';
import 'package:internal_tool/widgets/transitions.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //controller
  TextEditingController name = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController friendUid = TextEditingController();

  fetchInfo() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference user =
        FirebaseFirestore.instance.collection('users').doc(uid);
    DocumentSnapshot snapshot = await user.get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      name.text = data['name'];
      username.text = data['username'];
    }
  }

  addFriend(context) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference user =
        FirebaseFirestore.instance.collection('users').doc(uid);
    DocumentSnapshot userRef = await user.get();

    DocumentSnapshot friend = await FirebaseFirestore.instance
        .collection('users')
        .doc(friendUid.text)
        .get();

    if (friend.exists) {
      Map<String, dynamic> data = userRef.data() as Map<String, dynamic>;
      List friendList = data['friends'];
      for (int i = 0; i < friendList.length; i++) {
        if (friendUid.text == friendList[i]) {
          FocusManager.instance.primaryFocus!.unfocus();
          Navigator.pop(context);
          errorSnackbar(context, 'He is already your friend dumbass');
          return;
        }
      }
      FocusManager.instance.primaryFocus!.unfocus();
      Navigator.pop(context);
      friendList.add(friendUid.text);
      user
          .update({'friends': friendList})
          .then(
              (value) => successSnackbar(context, 'Friend Added Successfully'))
          .onError((error, stackTrace) =>
              errorSnackbar(context, 'Failed to add friend'));
    } else {
      FocusManager.instance.primaryFocus!.unfocus();
      Navigator.pop(context);
      errorSnackbar(context, "Invalid Uid");
    }
  }

  @override
  void initState() {
    fetchInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void friendBottomSheet(BuildContext context) {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.fromLTRB(
              15,
              20,
              15,
              max(MediaQuery.of(context).viewInsets.bottom + 20, 20),
            ),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: yellow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  customTextField(
                    context,
                    "Friend's Uid",
                    friendUid,
                    black,
                  ),
                  const SizedBox(height: 12),
                  CustomizeButton(
                    onPressed: () {
                      if (friendUid.text.isNotEmpty) {
                        if (friendUid.text == uid) {
                          errorSnackbar(
                              context, 'This is your own id dumb fuck');
                        } else {
                          addFriend(context);
                        }
                      }
                    },
                    bgColor: yellow,
                    borderColor: black,
                    child: Text(
                      "Add a Friend",
                      style: GoogleFonts.inter(
                        color: black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    void confirmLogout(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.fromLTRB(
              15,
              20,
              15,
              max(MediaQuery.of(context).viewInsets.bottom + 20, 20),
            ),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xffFCEEEE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Confirm Logout?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: const Color(0xffAC0806),
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: CustomizeButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          bgColor: const Color(0xffFCEEEE),
                          borderColor: red,
                          child: Text(
                            "No",
                            style: GoogleFonts.inter(
                              color: red,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomizeButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut().then((value) {
                              Navigator.popUntil(context, (route) => false);
                              slideDownTransition(
                                  context, const OnBoardingPage());
                            });
                          },
                          bgColor: red,
                          borderColor: black,
                          child: Text(
                            "Yes",
                            style: GoogleFonts.inter(
                              color: white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: bgBlack,
      appBar: customAppBar('Profile'),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 25),
                  customTextField(context, 'Name', name, white),
                  const SizedBox(height: 15),
                  customTextField(context, 'Username', username, white),
                  const Expanded(child: SizedBox(height: 40)),
                  Row(
                    children: [
                      Expanded(
                        flex: 10,
                        child: CustomizeButton(
                          onPressed: () => friendBottomSheet(context),
                          bgColor: const Color(0xffE9EDEC),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.person_add_outlined,
                                color: Color(0xff1C504B),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Add Friend",
                                style: GoogleFonts.inter(
                                  color: const Color(0xff1C504B),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        flex: 8,
                        child: CustomizeButton(
                          onPressed: () {
                            String uid = FirebaseAuth.instance.currentUser!.uid;

                            Clipboard.setData(ClipboardData(text: uid));
                          },
                          bgColor: const Color(0xffE9EDEC),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.copy_all_outlined,
                                color: Color(0xff1C504B),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "My id",
                                style: GoogleFonts.inter(
                                  color: const Color(0xff1C504B),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomizeButton(
                    onPressed: () => confirmLogout(context),
                    bgColor: const Color(0xffFCEEEE),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.logout,
                          color: Color(0xffAC0806),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Logout",
                          style: GoogleFonts.inter(
                            color: const Color(0xffAC0806),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
