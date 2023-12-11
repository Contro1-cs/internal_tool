import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internal_tool/widgets/appbar.dart';
import 'package:internal_tool/widgets/buttons.dart';
import 'package:internal_tool/widgets/colors.dart';
import 'package:internal_tool/widgets/snackbars.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  Map<String, dynamic> todoData = {
    'mainTitle': 'Job',
    'tasks': [
      {'taskTitle': 'Task 11', 'status': true},
      {'taskTitle': 'Task 12', 'status': true},
      {'taskTitle': 'Task 13', 'status': false},
    ],
  };
  uploadData() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection("boards").doc(uid).update(
        {"todo": todoData}).then((value) {
      successSnackbar(context, "Data upload sucessfully");
    }).onError(
        (error, stackTrace) => errorSnackbar(context, "Failed to upload data"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlack,
      appBar: customAppBar("Calendar"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: CustomizeButton(
            title: "Upload data",
            onPressed: () {
              uploadData();
            },
            bgColor: const Color(0xffFCEEEE),
            fontColor: const Color(0xffAC0806),
          ),
        ),
      ),
    );
  }
}
