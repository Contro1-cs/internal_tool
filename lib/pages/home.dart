import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_tool/pages/notice.dart';
import 'package:internal_tool/pages/onboarding.dart';
import 'package:internal_tool/pages/profile.dart';
import 'package:internal_tool/widgets/buttons.dart';
import 'package:internal_tool/widgets/colors.dart';
import 'package:internal_tool/widgets/progress.dart';
import 'package:internal_tool/widgets/transitions.dart';

class BotNavBar extends StatefulWidget {
  const BotNavBar({super.key});

  @override
  State<BotNavBar> createState() => _BotNavBarState();
}

class _BotNavBarState extends State<BotNavBar> {
  //int
  int _currentIndex = 0;

  //list
  List pages = [
    const HomePage(),
    const NoticePage(),
    const ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        height: 70,
        child: Theme(
          data: Theme.of(context).copyWith(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              elevation: 5,
              backgroundColor: Colors.white,
              indicatorColor: primary.withOpacity(0.1),
              labelTextStyle: MaterialStateProperty.all(
                GoogleFonts.inter(
                  color: black,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            child: NavigationBar(
              onDestinationSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              height: 75,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              animationDuration: const Duration(milliseconds: 800),
              selectedIndex: _currentIndex,
              destinations: [
                NavigationDestination(
                  selectedIcon: SvgPicture.asset('assets/home_selected.svg'),
                  icon: SvgPicture.asset('assets/home_icon.svg'),
                  label: 'Home',
                ),
                NavigationDestination(
                  selectedIcon: SvgPicture.asset('assets/hostel_selected.svg'),
                  icon: SvgPicture.asset('assets/hostel_icon.svg'),
                  label: 'Calendar',
                ),
                NavigationDestination(
                  selectedIcon: SvgPicture.asset('assets/profile_selected.svg'),
                  icon: SvgPicture.asset('assets/profile_icon.svg'),
                  label: 'Profile',
                ),
              ],
            ),
          ),
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
  TextEditingController? _noticeController = TextEditingController();
  //bool
  bool _loading = true;
  //String
  String _name = '';

  fetchName() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection("users").doc(uid);
    DocumentSnapshot user = await userDoc.get();
    if (user.exists) {
      Map<String, dynamic> data = user.data() as Map<String, dynamic>;
      setState(() {
        _name = data["name"].toString().split(" ").first;
      });
    }
    fetchNotice();
    setState(() {
      _loading = false;
    });
  }

  fetchNotice() async {
    DateTime now = DateTime.now();
    String today = "${now.day}-${now.month}-${now.year}";
    DocumentReference noticedoc =
        FirebaseFirestore.instance.collection("notice").doc(today);
    DocumentSnapshot notice = await noticedoc.get();
    if (notice.exists) {
      Map<String, dynamic> data = notice.data() as Map<String, dynamic>;
      setState(() {
        _noticeController!.text = data["notice"];
      });
    } else {
      _noticeController = null;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchName();
  }

  @override
  Widget build(BuildContext context) {
    addNotice() {
      DateTime now = DateTime.now();
      String today = "${now.day}-${now.month}-${now.year}";
      // String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference notice =
          FirebaseFirestore.instance.collection("notice").doc(today);
      notice.set({
        "notice": _noticeController!.text,
      });
    }

    return WillPopScope(
      onWillPop: () async {
        final exitApp = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: const Text(
                'Want to exit the app?',
                textAlign: TextAlign.center,
              ),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  child: Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: primary)),
                    alignment: Alignment.center,
                    child: Text(
                      "No",
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  child: Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Yes",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
        return exitApp!;
      },
      child: Scaffold(
        body: _loading
            ? customCircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          SvgPicture.asset("assets/abstract.svg"),
                          Text(
                            "  Hey $_name,",
                            style: GoogleFonts.inter(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: black),
                          ),
                        ],
                      ),
                      const Expanded(child: SizedBox(height: 25)),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _noticeController,
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(15),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      BorderSide(color: black, width: 2),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            onPressed: () {
                              fetchNotice();
                            },
                            icon: Icon(
                              Icons.refresh,
                              color: black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      b1Button("Update Notice", () {
                        FocusManager.instance.primaryFocus!.unfocus();
                        addNotice();
                        fetchNotice();
                      }),
                      const SizedBox(height: 10),
                      b1Button("View friend's progress", () => null),
                      Visibility(
                        visible: false,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: b1Button(
                            "Logout",
                            () {
                              FirebaseAuth.instance.signOut();
                              slideUpTransition(
                                  context, const onBoardingPage());
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
