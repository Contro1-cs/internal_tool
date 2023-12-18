import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internal_tool/widgets/checkbox.dart';
import 'package:internal_tool/widgets/colors.dart';

class TodoListTile extends StatefulWidget {
  const TodoListTile({
    super.key,
    required this.primaryColor,
    required this.primaryFontColor,
    required this.status,
    required this.contentController,
    this.focusNode,
    required this.onCheck,
    required this.onDelete,
    required this.onSubmitted,
    required this.onTapOutside,
  });
  final Color primaryColor;
  final Color primaryFontColor;
  final bool status;
  final TextEditingController contentController;
  final FocusNode? focusNode;
  final Function()? onCheck;
  final Function()? onDelete;
  final Function(String)? onSubmitted;
  final Function(PointerDownEvent)? onTapOutside;

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
    Function()? onCheck = widget.onCheck;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: const EdgeInsets.symmetric(vertical: 3.5),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: yellow.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 8,
          ),
        ],
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
                    controller: widget.contentController,
                    focusNode: widget.focusNode,
                    keyboardType: TextInputType.text,
                    cursorColor: primaryFontColor,
                    maxLines: null,
                    scrollPhysics: const NeverScrollableScrollPhysics(),
                    maxLength: 69,
                    decoration: InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      hintText: 'New Task',
                      hintStyle: GoogleFonts.inter(
                        color: primaryFontColor.withOpacity(0.3),
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
                      color: primaryFontColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    onSubmitted: widget.onSubmitted,
                    onTapOutside: widget.onTapOutside,
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
