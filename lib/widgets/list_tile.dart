import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_tool/widgets/checkbox.dart';
import 'package:internal_tool/widgets/colors.dart';

class TodoListTile extends StatefulWidget {
  const TodoListTile({
    super.key,
    required this.title,
    required this.primaryColor,
    required this.primaryFontColor,
    required this.status,
    this.focusNode,
    required this.onCheck,
    required this.onDelete,
  });
  final String title;
  final Color primaryColor;
  final Color primaryFontColor;
  final bool status;
  final FocusNode? focusNode;
  final Function()? onCheck;
  final Function()? onDelete;

  @override
  State<TodoListTile> createState() => _TodoListTileState();
}

class _TodoListTileState extends State<TodoListTile> {
  @override
  Widget build(BuildContext context) {
    //inherited var
    Color primaryColor = widget.primaryColor;
    Color primaryFontColor = widget.primaryFontColor;
    bool status = widget.status;
    TextEditingController contentController = TextEditingController();
    contentController.text = widget.title;
    Function()? onCheck = widget.onCheck;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: const EdgeInsets.symmetric(vertical: 3.5),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                CustomCheckBox(
                  check: status,
                  onTap: onCheck,
                  color: primaryFontColor,
                  tickcolor: primaryColor,
                ),
                Expanded(
                  child: TextField(
                    controller: contentController,
                    focusNode: widget.focusNode,
                    keyboardType: TextInputType.text,
                    cursorColor: primaryFontColor,
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
                      decoration: status
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: primaryFontColor,
                      decorationThickness: 2,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: widget.onDelete,
            icon: Icon(
              Icons.close,
              size: 15,
              color: primaryFontColor,
            ),
          ),
        ],
      ),
    );
  }
}
