import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_tool/widgets/checkbox.dart';
import 'package:internal_tool/widgets/colors.dart';

class TodoListTile extends StatefulWidget {
  const TodoListTile({
    super.key,
    required this.color,
    required this.tickColor,
    required this.controller,
  });
  final Color color;
  final Color tickColor;
  final TextEditingController controller;

  @override
  State<TodoListTile> createState() => _TodoListTileState();
}

class _TodoListTileState extends State<TodoListTile> {
  //bool
  bool check = false;
  @override
  Widget build(BuildContext context) {
    Color color = widget.color;
    Color tickColor = widget.tickColor;
    TextEditingController controller = widget.controller;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: boardCyan.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomCheckBox(
            check: check,
            onTap: () {
              setState(() {
                check = !check;
              });
            },
            color: color,
            tickcolor: tickColor,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.text,
              cursorColor: color,
              scrollPhysics: const NeverScrollableScrollPhysics(),
              maxLength: 100,
              decoration: InputDecoration(
                counterText: '',
                border: InputBorder.none,
                hintText: 'Note',
                hintStyle: GoogleFonts.inter(
                  color: lightGrey,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              style: GoogleFonts.inter(
                decoration:
                    check ? TextDecoration.lineThrough : TextDecoration.none,
                decorationColor: color,
                decorationThickness: 2,
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}
