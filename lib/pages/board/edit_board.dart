import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_tool/models/todo_model.dart';
import 'package:internal_tool/widgets/colors.dart';
import 'package:internal_tool/widgets/list_tile.dart';

class EditBoard extends StatefulWidget {
  const EditBoard({
    super.key,
    required this.mainTitle,
    required this.docId,
    required this.noteColor,
    required this.tasks,
  });
  final String mainTitle;
  final String docId;
  final String noteColor;
  final List tasks;

  @override
  State<EditBoard> createState() => _EditBoardState();
}

class _EditBoardState extends State<EditBoard> {
  //others
  TextEditingController newTaskController = TextEditingController();
  List<TodoModel> todoModelList = [];
  List<TextEditingController> contentController = [];

  //Color
  Color primaryColor = lightGrey;
  Color primaryFontColor = darkGrey;

  //controller
  TextEditingController titleController = TextEditingController();
  ScrollController scrollController = ScrollController();

  List<QueryDocumentSnapshot<Object?>> colorList = [];

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

  taskInit() async {
    contentController = List.generate(
      widget.tasks.length,
      (index) => TextEditingController(
        text: widget.tasks[index]['taskTitle'],
      ),
    );

    todoModelList = List.generate(
      widget.tasks.length,
      (index) => TodoModel(
        widget.tasks[index]['taskTitle'],
        widget.tasks[index]['status'],
        boardCyan,
      ),
    );
  }

  @override
  void initState() {
    fetchColors();
    taskInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //others
    final FocusNode focusNode2 = FocusNode();
    String uid = FirebaseAuth.instance.currentUser!.uid;

    //inherited var
    titleController.text = widget.mainTitle;

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
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          List tasks = data['todo']['tasks'];

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
                        String fcolor = colorList[index]['fontColor'];
                        Color bgColor =
                            Color(int.parse(color, radix: 16)).withAlpha(0xFF);
                        Color fontColor =
                            Color(int.parse(fcolor, radix: 16)).withAlpha(0xFF);

                        return GestureDetector(
                          onTap: () => setState(() {
                            primaryColor = bgColor;
                            primaryFontColor = fontColor;
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
                            FocusScope.of(context).requestFocus(focusNode2);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeIn,
                              );
                            });
                            setState(() {});
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
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return TodoListTile(
                        bgColor: primaryColor,
                        tickColor: primaryFontColor,
                        check: todoModelList[index].status,
                        controller: contentController[index],
                        noteColor: todoModelList[index].noteColor,
                        onChange: () {
                          setState(() {
                            todoModelList[index].status =
                                !todoModelList[index].status;
                          });
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
