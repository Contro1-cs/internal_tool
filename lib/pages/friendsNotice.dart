import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_tool/widgets/appbar.dart';
import 'package:internal_tool/widgets/colors.dart';
import 'package:intl/intl.dart';

class FriendsNoticePage extends StatefulWidget {
  const FriendsNoticePage({super.key, required this.friendUid});
  final String friendUid;

  @override
  State<FriendsNoticePage> createState() => _FriendsNoticePageState();
}

class _FriendsNoticePageState extends State<FriendsNoticePage> {
  //String
  String friendsNotice = '';
  String friendUserName = '';
  String friendName = '';

  fetchFriendNotice() async {
    DocumentSnapshot<Map<String, dynamic>> notice = await FirebaseFirestore
        .instance
        .collection('notice')
        .doc(widget.friendUid)
        .get();
    if (notice.exists) {
      friendsNotice = notice.data()?['notice'] ?? "No active notice";
    }
  }

  fetchUsername() async {
    DocumentSnapshot<Map<String, dynamic>> users = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(widget.friendUid)
        .get();
    if (users.exists) {
      setState(() {
        friendUserName = users.data()?['username'] ?? "not found";
        friendName = users.data()?['name'] ?? "not found";
      });
    }
  }

  String formatDate(String inputDate) {
    DateTime dateTime = DateFormat('dd-MM-yyyy').parse(inputDate);
    String outputDate = DateFormat('dd MMM yy').format(dateTime);
    return outputDate;
  }

  friendsNoticeBoard() {
    DateTime now = DateTime.now();
    String today = formatDate("${now.day}-${now.month}-${now.year}");

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: yellow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            today,
            style: GoogleFonts.inter(
              color: const Color(0xff8F7000),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            friendsNotice,
            style: GoogleFonts.inter(
              color: const Color(0xff8F7000),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/default_cat.svg",
                height: 20,
              ),
              const SizedBox(width: 5),
              Text(
                friendUserName,
                style: GoogleFonts.inter(
                  color: const Color(0xff8F7000),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    fetchFriendNotice();
    fetchUsername();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      appBar: customAppBar(friendName),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            friendsNoticeBoard(),
          ],
        ),
      ),
    );
  }
}
