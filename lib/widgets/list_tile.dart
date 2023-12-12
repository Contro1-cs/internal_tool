import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_tool/widgets/checkbox.dart';
import 'package:internal_tool/widgets/colors.dart';
import 'package:internal_tool/widgets/snackbars.dart';

class TodoListTile extends StatefulWidget {
  const TodoListTile({
    super.key,
    required this.color,
    required this.tickColor,
    required this.check,
    required this.controller,
    required this.onChange,
    this.focusNode,
  });
  final Color color;
  final Color tickColor;
  final bool check;
  final TextEditingController controller;
  final Function()? onChange;
  final FocusNode? focusNode;

  @override
  State<TodoListTile> createState() => _TodoListTileState();
}

class _TodoListTileState extends State<TodoListTile> {
  //bool
  @override
  Widget build(BuildContext context) {
    Color color = widget.color;
    bool check = widget.check;
    Color tickColor = widget.tickColor;
    Function()? onChange = widget.onChange;

    TextEditingController controller = widget.controller;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 5),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomCheckBox(
            check: widget.check,
            onTap: onChange,
            color: color,
            tickcolor: tickColor,
          ),
          // Checkbox(
          //   value: check,
          //   onChanged: (value) {
          //     setState(() {
          //       check = value!;
          //     });
          //   },
          // ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: widget.focusNode,
              keyboardType: TextInputType.text,
              cursorColor: color,
              scrollPhysics: const NeverScrollableScrollPhysics(),
              maxLength: 100,
              decoration: InputDecoration(
                counterText: '',
                border: InputBorder.none,
                hintText: 'New Task',
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
          ),
          IconButton(
            onPressed: () {
              successSnackbar(context, "clicked");
            },
            icon: Icon(
              Icons.close_rounded,
              size: 15,
              color: color,
            ),
          )
        ],
      ),
    );
  }
}
