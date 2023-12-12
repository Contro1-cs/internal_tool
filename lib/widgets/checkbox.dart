import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({
    super.key,
    required this.check,
    required this.onTap,
    required this.color,
    required this.tickcolor,
  });
  final bool check;
  final Function()? onTap;
  final Color color;
  final Color tickcolor;

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    bool check = widget.check;
    Function()? onTap = widget.onTap;
    Color color = widget.color;
    Color tickcolor = widget.tickcolor;

    return IconButton(
      onPressed: onTap,
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.linear,
        height: 20,
        width: 20,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: check ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: color,
            width: check ? 0 : 1,
          ),
        ),
        child: SvgPicture.asset(
          "assets/done.svg",
          height: 15,
          fit: BoxFit.scaleDown,
          color: check ? tickcolor : Colors.transparent,
        ),
      ),
    );
  }
}
