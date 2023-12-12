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
    required this.onTap,
  });
  final String title;
  final bool bookmark;
  final List tasks;
  final Function()? onTap;

  @override
  State<MainBoardWidget> createState() => _MainBoardWidgetState();
}

class _MainBoardWidgetState extends State<MainBoardWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: pink,
                borderRadius: BorderRadius.circular(12),
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
                            color: maroon,
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
                            InkWell(
                              onTap: () {
                                setState(() {});
                              },
                              child: Container(
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
                            ),

                            //Task text
                            Text(
                              widget.tasks[index]['taskTitle'],
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
        ],
      ),
    );
  }
}
