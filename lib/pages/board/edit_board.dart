import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_tool/widgets/colors.dart';
import 'package:internal_tool/widgets/list_tile.dart';

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
  //List
  List colorList = [];

  //Colors
  Color primaryColor = lightGrey;
  Color primaryFontColor = darkGrey;

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
    setState(() {});
  }

  @override
  void initState() {
    fetchColors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //other var
    String uid = FirebaseAuth.instance.currentUser!.uid;
    TextEditingController titleController = TextEditingController();
    ScrollController scrollController = ScrollController();
    FocusNode focusNode = FocusNode();

    //inherited var

    updateList(List taskList) {
      FirebaseFirestore.instance
          .collection('boards')
          .doc(uid)
          .collection('tasks')
          .doc(widget.docId)
          .update({'tasks': taskList});
    }

    return Scaffold(
      backgroundColor: bgBlack,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: primaryColor,
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
          List taskList = data['tasks'];
          titleController.text = data['mainTitle'];
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                        borderSide: BorderSide(color: primaryColor, width: 3),
                      ),
                    ),
                    cursorColor: primaryColor,
                    textCapitalization: TextCapitalization.words,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 20),

                  //Colors
                  SizedBox(
                    height: 50.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(colorList.length, (index) {
                        String color = colorList[index]['code'];
                        Color bgColor =
                            Color(int.parse(color, radix: 16)).withAlpha(0xFF);

                        return GestureDetector(
                          onTap: () => setState(() {
                            primaryColor = bgColor;
                          }),
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
                            FocusScope.of(context).requestFocus(focusNode);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeIn,
                              );
                            });
                            setState(() {
                              List tempList = taskList;
                              int randomNumber = Random().nextInt(10) + 1;

                              tempList.add({
                                'taskTitle': 'Task $randomNumber',
                                'status': false
                              });
                              updateList(tempList);
                            });
                          },
                          icon: Icon(
                            Icons.add,
                            color: primaryColor,
                          ))
                    ],
                  ),
                  const SizedBox(height: 5),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data['tasks'].length,
                    itemBuilder: (context, index) {
                      String taskTitle = data['tasks'][index]['taskTitle'];
                      bool status = data['tasks'][index]['status'];
                      return TodoListTile(
                        title: taskTitle,
                        primaryColor: primaryColor,
                        primaryFontColor: primaryFontColor,
                        status: status,
                        focusNode: index == data['tasks'].length - 1
                            ? focusNode
                            : null,
                        onCheck: () {
                          List tempList = taskList;
                          tempList[index]['status'] = !status;
                          updateList(tempList);
                        },
                        onDelete: () {
                          List tempList = taskList;
                          tempList.removeAt(index);
                          updateList(tempList);
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
    );
  }
}
