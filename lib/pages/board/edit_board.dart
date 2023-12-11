import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_tool/widgets/colors.dart';
import 'package:internal_tool/widgets/list_tile.dart';

class EditBoard extends StatefulWidget {
  const EditBoard({super.key});

  @override
  State<EditBoard> createState() => _EditBoardState();
}

class _EditBoardState extends State<EditBoard> {
  //Color
  Color color = yellow;
  Color primaryColor = boardCyan;
  Color primaryFontColor = boardCyanFont;

  //controller
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
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
    return Scaffold(
      backgroundColor: bgBlack,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: primaryColor,
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
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
                  const SizedBox(height: 25),
                  //Content
                  TodoListTile(
                    color: primaryColor,
                    tickColor: primaryFontColor,
                    controller: contentController,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
