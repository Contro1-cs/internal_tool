import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internal_tool/pages/board/board_widget.dart';
import 'package:internal_tool/widgets/appbar.dart';
import 'package:internal_tool/widgets/colors.dart';

class BoardsPage extends StatefulWidget {
  const BoardsPage({super.key});

  @override
  State<BoardsPage> createState() => _BoardsPageState();
}

class _BoardsPageState extends State<BoardsPage> {
  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: bgBlack,
      appBar: customAppBar("All Boards"),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("boards")
            .doc(uid)
            .collection("tasks")
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            List documents = snapshot.data!.docs;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: GridView.builder(
                itemCount: documents.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  //Inputs
                  String title =
                      documents[index]["todo"]["mainTitle"] ?? "Error";
                  bool bookmark = documents[index]["todo"]["status"] ?? false;
                  List tasks = documents[index]["todo"]["tasks"];

                  return MainBoardWidget(
                    title: title,
                    bookmark: bookmark,
                    tasks: tasks,
                    onTap: () {},
                  );
                },
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
