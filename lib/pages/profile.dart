import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internal_tool/pages/onboarding.dart';
import 'package:internal_tool/widgets/buttons.dart';
import 'package:internal_tool/widgets/colors.dart';
import 'package:internal_tool/widgets/transitions.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlack,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: CustomizeButton(
            title: "Logout",
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.popUntil(context, (route) => false);
                slideDownTransition(context, const onBoardingPage());
              });
            },
            bgColor: const Color(0xffFCEEEE),
            fontColor: const Color(0xffAC0806),
          ),
        ),
      ),
    );
  }
}
