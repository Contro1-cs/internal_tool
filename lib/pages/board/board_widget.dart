import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_tool/widgets/colors.dart';

class MainBoardWidget extends StatefulWidget {
  const MainBoardWidget({
    super.key,
    required this.title,
    required this.bookmark,
    required this.tasks,
    required this.color,
    required this.onTap,
  });
  final String title;
  final bool bookmark;
  final String color;
  final List tasks;
  final Function()? onTap;

  @override
  State<MainBoardWidget> createState() => _MainBoardWidgetState();
}

class _MainBoardWidgetState extends State<MainBoardWidget> {
  //Var
  List colorList = [];
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
    DocumentSnapshot colorDoc = await colors.doc(widget.color).get();
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
    return InkWell(
      onTap: widget.onTap,
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
            BoxShadow(
              color: yellow.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 8,
            )
          ],
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      softWrap: true,
                      style: GoogleFonts.inter(
                        color: primaryFontColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.bookmark,
                    child: SvgPicture.asset(
                      "assets/pin.svg",
                    ),
                  ),
                ],
              ),

              //checkbox
              Expanded(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.tasks.length,
                  itemBuilder: (context, index) {
                    //bool
                    bool check = widget.tasks[index]['status'];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 15,
                          width: 15,
                          margin: const EdgeInsets.all(5),
                          // padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: check ? maroon : Colors.transparent,
                            border: Border.all(color: maroon, width: 1.5),
                          ),
                          child: Icon(
                            Icons.done,
                            color: check ? white : Colors.transparent,
                            weight: 2,
                            size: 10,
                          ),
                        ),

                        //Task text
                        Text(
                          widget.tasks[index]['taskTitle'].toString().length >
                                  12
                              ? '${widget.tasks[index]['taskTitle'].toString().substring(0, 12)}...'
                              : widget.tasks[index]['taskTitle'],
                          style: GoogleFonts.inter(
                            color: check ? maroon.withOpacity(0.5) : maroon,
                            fontSize: 14,
                            decoration: check
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            decorationColor: maroon,
                            decorationThickness: 2,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
