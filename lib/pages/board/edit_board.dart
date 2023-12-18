import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_tool/widgets/colors.dart';
import 'package:internal_tool/widgets/list_tile.dart';
import 'package:internal_tool/widgets/snackbars.dart';

class EditBoard extends StatefulWidget {
  const EditBoard({
    super.key,
    required this.noteColor,
    required this.docId,
  });
  final String noteColor;
  final String docId;

  @override
  State<EditBoard> createState() => _EditBoardState();
}

class _EditBoardState extends State<EditBoard> {
  TextEditingController titleController = TextEditingController();

  //List
  List colorList = [];
  List contentController = [];
  List taskList = [];

  //Colors
  Color primaryColor = lightGrey;
  Color primaryFontColor = darkGrey;

  //others
  bool bookmark = false;
  bool noteChanges = true;
  bool _loading = true;

  Future fetchColors() async {
    CollectionReference colors =
        FirebaseFirestore.instance.collection("colors");
    QuerySnapshot allColors = await colors.get();

    if (allColors.docs.isNotEmpty) {
      colorList = allColors.docs;
    } else {
      colorList = [];
    }
    DocumentSnapshot colorDoc = await colors.doc(widget.noteColor).get();
    if (colorDoc.exists) {
      Map<String, dynamic> data = colorDoc.data() as Map<String, dynamic>;
      primaryColor = Color(int.parse(data['code'], radix: 16)).withAlpha(0xFF);
      primaryFontColor =
          Color(int.parse(data['fontColor'], radix: 16)).withAlpha(0xFF);
    }
    setState(() {
      _loading = false;
    });
  }

  deleteBoard() {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    Navigator.pop(context);
    sleep(const Duration(milliseconds: 1000));
    FirebaseFirestore.instance
        .collection('boards')
        .doc(uid)
        .collection('tasks')
        .doc(widget.docId)
        .delete();
  }

  updateList(List taskList) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('boards')
        .doc(uid)
        .collection('tasks')
        .doc(widget.docId)
        .update({
      'tasks': taskList,
    });
  }

  updateTitle() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('boards')
        .doc(uid)
        .collection('tasks')
        .doc(widget.docId)
        .update({
      'mainTitle': titleController.text,
    });
  }

  toggleBookmark(bool value) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('boards')
        .doc(uid)
        .collection('tasks')
        .doc(widget.docId)
        .update({'bookmark': value});
  }

  @override
  void initState() {
    fetchColors();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    List<Map> temp = [];
    for (int i = 0; i < contentController.length; i++) {
      temp.add({'taskTitle': contentController[i].text, 'status': false});
    }
    updateList(temp);
    _loading = true;
  }

  @override
  Widget build(BuildContext context) {
    //other var
    String uid = FirebaseAuth.instance.currentUser!.uid;
    ScrollController scrollController = ScrollController();
    FocusNode focusNode = FocusNode();

    //Popups
    void deletePopup() {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            alignment: Alignment.center,
            backgroundColor: black,
            title: Text(
              'Delete Board?',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: red,
              ),
            ),
            actions: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          backgroundColor: red,
                        ),
                        child: Text(
                          'Yes',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);

                          deleteBoard();
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: ElevatedButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          backgroundColor: white,
                        ),
                        child: Text(
                          'No',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: red,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        },
      );
    }

    return PopScope(
      canPop: noteChanges,
      onPopInvoked: (bool didPop) {
        updateTitle();
        updateList(taskList);
        if (didPop) {
          return;
        }
      },
      child: _loading
          ? Center(
              child: CircularProgressIndicator(
                color: yellow,
              ),
            )
          : Scaffold(
              backgroundColor: bgBlack,
              appBar: AppBar(
                automaticallyImplyLeading: true,
                backgroundColor: primaryColor,
                actions: [
                  IconButton(
                    onPressed: () => deletePopup(),
                    icon: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: SvgPicture.asset(
                        "assets/delete.svg",
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      bookmark = !bookmark;
                      toggleBookmark(bookmark);
                      setState(() {});
                    },
                    icon: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child: bookmark
                          ? SvgPicture.asset(
                              "assets/pin.svg",
                            )
                          : SvgPicture.asset(
                              "assets/pin_outlined.svg",
                            ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              body: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("boards")
                    .doc(uid)
                    .collection("tasks")
                    .doc(widget.docId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  taskList = data['tasks'];
                  titleController.text = data['mainTitle'];
                  bookmark = data['bookmark'];
                  contentController = List.generate(
                      taskList.length, (index) => TextEditingController());
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      child: Column(
                        children: [
                          //Title
                          TextField(
                            controller: titleController,
                            decoration: InputDecoration(
                              hintStyle: GoogleFonts.inter(
                                color: white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                              hintText: 'Untitled',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: primaryColor, width: 3),
                              ),
                            ),
                            cursorColor: primaryColor,
                            textCapitalization: TextCapitalization.words,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                            onChanged: (value) {
                              noteChanges = false;
                            },
                            onTapOutside: (title) {
                              updateTitle();
                            },
                          ),
                          const SizedBox(height: 20),

                          //Colors
                          SizedBox(
                            height: 50.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:
                                  List.generate(colorList.length, (index) {
                                String color = colorList[index]['code'];
                                Color bgColor =
                                    Color(int.parse(color, radix: 16))
                                        .withAlpha(0xFF);

                                return GestureDetector(
                                  onTap: () {
                                    FirebaseFirestore.instance
                                        .collection("boards")
                                        .doc(uid)
                                        .collection("tasks")
                                        .doc(widget.docId)
                                        .update({
                                      'noteColor': colorList[index]['name']
                                    }).onError((error, stackTrace) =>
                                            errorSnackbar(
                                                context, error.toString()));
                                    setState(() {
                                      primaryColor = bgColor;
                                    });
                                  },
                                  child: Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      color: bgColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 20),

                          //Tasks title
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Tasks",
                                style: GoogleFonts.inter(
                                  color: white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  List tempList = taskList;

                                  tempList
                                      .add({'taskTitle': '', 'status': false});
                                  updateList(tempList);
                                  scrollController.animateTo(
                                    scrollController.position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeIn,
                                  );
                                  setState(() {
                                    noteChanges = false;
                                  });
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: primaryColor,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 5),
                          taskList.isEmpty
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 50),
                                    child: Text(
                                      'No Tasks',
                                      style: GoogleFonts.inter(color: white),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: data['tasks'].length,
                                  itemBuilder: (context, index) {
                                    contentController[index].text =
                                        data['tasks'][index]['taskTitle'] ?? '';
                                    bool status =
                                        data['tasks'][index]['status'] ?? false;

                                    return TodoListTile(
                                      contentController:
                                          contentController[index],
                                      primaryColor: primaryColor,
                                      primaryFontColor: primaryFontColor,
                                      status: status,
                                      focusNode:
                                          index == data['tasks'].length + 1
                                              ? focusNode
                                              : null,
                                      onCheck: () {
                                        List tempList = taskList;
                                        tempList[index]['status'] = !status;
                                        tempList[index]['taskTitle'] =
                                            contentController[index].text;
                                        updateList(tempList);
                                      },
                                      onDelete: () {
                                        List tempList = taskList;
                                        tempList.removeAt(index);
                                        updateList(tempList);
                                      },
                                      onSubmitted: (task) {
                                        List tempList = taskList;
                                        tempList[index]['taskTitle'] =
                                            contentController[index].text;
                                        updateList(tempList);
                                      },
                                      onTapOutside: (pointer) {
                                        debugPrint(
                                            '${contentController[index].text} ###########################');
                                      },
                                    );
                                  },
                                ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
