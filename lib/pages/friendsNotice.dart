import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_tool/pages/board/board_widget.dart';
import 'package:internal_tool/pages/board/edit_board.dart';
import 'package:internal_tool/widgets/appbar.dart';
import 'package:internal_tool/widgets/colors.dart';
import 'package:internal_tool/widgets/transitions.dart';
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

  fetchData() {
    fetchFriendNotice();
    fetchUsername();
  }

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
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: black,
      appBar: customAppBar(friendName),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            friendsNoticeBoard(),
            SizedBox(
              width: w,
              height: w,
              child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("boards")
                    .doc(widget.friendUid)
                    .collection("tasks")
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    List documents = snapshot.data!.docs;

                    return documents.isEmpty
                        ? Center(
                            child: Text(
                              'No boards found',
                              style: GoogleFonts.inter(color: white),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 2,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              ),
                              itemBuilder: (context, index) {
                                //Inputs
                                String title =
                                    documents[index]["mainTitle"] ?? "Error";
                                bool bookmark =
                                    documents[index]["bookmark"] ?? false;
                                List tasks = documents[index]["tasks"];
                                String noteColor =
                                    documents[index]['noteColor'];
                                String docId = documents[index].id;
                                return MainBoardWidget(
                                  title: title,
                                  bookmark: bookmark,
                                  color: noteColor,
                                  tasks: tasks,
                                  onTap: () => mainSlideTransition(
                                    context,
                                    EditBoard(
                                      docId: docId,
                                      noteColor: noteColor,
                                    ),
                                    (value) => fetchData(),
                                  ),
                                );
                              },
                            ),
                          );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
