import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_tool/pages/board/board_widget.dart';
import 'package:internal_tool/pages/board/boards.dart';
import 'package:internal_tool/pages/board/edit_board.dart';
import 'package:internal_tool/pages/notice.dart';
import 'package:internal_tool/pages/profile.dart';
import 'package:internal_tool/widgets/appbar.dart';
import 'package:internal_tool/widgets/buttons.dart';
import 'package:internal_tool/widgets/colors.dart';
import 'package:internal_tool/widgets/progress.dart';
import 'package:internal_tool/widgets/snackbars.dart';
import 'package:intl/intl.dart';

import '../widgets/transitions.dart';

//int
int currentIndex = 0;

class BotNavBar extends StatefulWidget {
  const BotNavBar({super.key});

  @override
  State<BotNavBar> createState() => _BotNavBarState();
}

class _BotNavBarState extends State<BotNavBar> {
  //list
  List pages = [
    const HomePage(),
    const BoardsPage(),
    const Calendar(),
    const ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    navBarItem(Widget icon) {
      return Container(
        height: 45,
        width: 45,
        padding: const EdgeInsets.all(10),
        child: icon,
      );
    }

    return Scaffold(
      backgroundColor: bgBlack,
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.fromLTRB(15, 0, 15, 8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: white.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 5,
            )
          ],
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xff353535),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  currentIndex = 0;
                });
              },
              child: currentIndex == 0
                  ? navBarItem(
                      SvgPicture.asset("assets/home_selected.svg"),
                    )
                  : navBarItem(
                      SvgPicture.asset("assets/home_Icon.svg"),
                    ),
            ),
            const SizedBox(width: 1),
            InkWell(
              onTap: () {
                setState(() {
                  currentIndex = 1;
                });
              },
              child: navBarItem(
                currentIndex == 1
                    ? SvgPicture.asset("assets/boards_selected.svg")
                    : SvgPicture.asset("assets/boards_icon.svg"),
              ),
            ),
            const SizedBox(width: 1),
            InkWell(
              onTap: () {
                setState(() {
                  currentIndex = 2;
                });
              },
              child: navBarItem(
                currentIndex == 2
                    ? SvgPicture.asset("assets/calendar_selected.svg")
                    : SvgPicture.asset("assets/calendar_icon.svg"),
              ),
            ),
            const SizedBox(width: 1),
            InkWell(
              onTap: () {
                setState(() {
                  currentIndex = 3;
                });
              },
              child: navBarItem(
                currentIndex == 3
                    ? SvgPicture.asset(
                        "assets/person_icon.svg",
                        color: Colors.white,
                      )
                    : SvgPicture.asset("assets/person_icon.svg"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //controller
  final TextEditingController _noticeController = TextEditingController();

  //bool
  bool _loading = true;

  //String
  String _username = '';

  //List
  List _friends = [];

  fetchData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection("users").doc(uid);
    DocumentSnapshot user = await userDoc.get();
    if (user.exists) {
      Map<String, dynamic> data = user.data() as Map<String, dynamic>;
      setState(() {
        _username = data["username"].toString().split(" ").first;
        _friends = data["friends"];
      });
    }
    fetchNotice();
    setState(() {
      _loading = false;
    });
  }

  fetchNotice() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference noticedoc =
        FirebaseFirestore.instance.collection("notice").doc(uid);
    DocumentSnapshot notice = await noticedoc.get();
    if (notice.exists) {
      Map<String, dynamic> data = notice.data() as Map<String, dynamic>;
      setState(() {
        _noticeController.text = data["notice"];
      });
    } else {
      _noticeController.text = "Add new notice";
    }
  }

  addNotice() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference notice =
        FirebaseFirestore.instance.collection("notice").doc(uid);
    notice.set({
      "notice": _noticeController.text,
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    addNotice();
    super.dispose();
  }

  Future<void> _refresh() async {
    fetchData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //other
    var w = MediaQuery.of(context).size.width;
    String uid = FirebaseAuth.instance.currentUser!.uid;

    String formatDate(String inputDate) {
      DateTime dateTime = DateFormat('dd-MM-yyyy').parse(inputDate);
      String outputDate = DateFormat('dd MMM yy').format(dateTime);
      return outputDate;
    }

    void showNotice(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          DateTime now = DateTime.now();
          String today = formatDate("${now.day}-${now.month}-${now.year}");

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
                  Text(
                    today,
                    style: GoogleFonts.inter(
                      color: const Color(0xff8F7000),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    maxLines: null,
                    autofocus: true,
                    keyboardType: TextInputType.multiline,
                    controller: _noticeController,
                    maxLength: 100,
                    style: GoogleFonts.inter(
                      color: const Color(0xff8F7000),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.transparent, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomizeButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus!.unfocus();
                      Navigator.pop(context);
                      addNotice();
                      fetchNotice();
                    },
                    title: "Update Note",
                    bgColor: yellow,
                    fontColor: const Color(0xff8e7000),
                    borderColor: black,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    noticeBoard() {
      DateTime now = DateTime.now();
      String today = formatDate("${now.day}-${now.month}-${now.year}");

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: yellow,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: yellow.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 8,
            )
          ],
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
            GestureDetector(
              onTap: () => showNotice(context),
              child: Text(
                _noticeController.text,
                style: GoogleFonts.inter(
                  color: const Color(0xff8F7000),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
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
                  _username,
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

    return Scaffold(
      backgroundColor: bgBlack,
      body: _loading
          ? customCircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeAppBar(
                        friends: _friends,
                      ),
                      const SizedBox(height: 10),
                      noticeBoard(),
                      const SizedBox(height: 40),
                      Center(
                        child: Text(
                          "Pinned Boards",
                          style: GoogleFonts.inter(
                            color: white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: w,
                        height: w,
                        child: FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection("boards")
                              .doc(uid)
                              .collection("tasks")
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              List documents = snapshot.data!.docs;

                              return Padding(
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
                                    String title = documents[index]
                                            ["mainTitle"] ??
                                        "Error";
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
              ),
            ),
    );
  }
}
