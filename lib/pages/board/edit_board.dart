import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_tool/widgets/colors.dart';
import 'package:internal_tool/widgets/list_tile.dart';

class EditBoard extends StatefulWidget {
  const EditBoard({
    super.key,
    required this.mainTitle,
    required this.tasks,
  });
  final String mainTitle;
  final List tasks;

  @override
  State<EditBoard> createState() => _EditBoardState();
}

class _EditBoardState extends State<EditBoard> {
  //others

  //Color
  Color color = yellow;
  Color primaryColor = boardCyan;
  Color primaryFontColor = boardCyanFont;

  //controller
  TextEditingController titleController = TextEditingController();
  ScrollController scrollController = ScrollController();

  List<QueryDocumentSnapshot<Object?>> colorList = [];

  Future fetchColors() async {
    QuerySnapshot colors =
        await FirebaseFirestore.instance.collection("colors").get();
    if (colors.docs.isNotEmpty) {
      colorList = colors.docs;
    } else {
      colorList = [];
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
    //others
    final FocusNode focusNode2 = FocusNode();

    //Lists
    List<TextEditingController> contentController =
        List.generate(widget.tasks.length, (index) => TextEditingController());
    TextEditingController newTaskController = TextEditingController();

    //inherited var
    titleController.text = widget.mainTitle;
    List tasks = widget.tasks;

    return Scaffold(
      backgroundColor: bgBlack,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

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
              // Tasks
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: contentController.length,
                itemBuilder: (context, index) {
                  TextEditingController controller = contentController[index];
                  bool check = tasks[index]['status'];
                  controller.text = tasks[index]['taskTitle'];
                  return TodoListTile(
                    color: primaryColor,
                    tickColor: primaryFontColor,
                    check: check,
                    controller: controller,
                  );
                },
              ),
              TodoListTile(
                color: primaryColor,
                tickColor: primaryFontColor,
                check: false,
                controller: newTaskController,
                focusNode: focusNode2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
