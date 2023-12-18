import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internal_tool/pages/board/board_widget.dart';
import 'package:internal_tool/pages/board/edit_board.dart';
import 'package:internal_tool/widgets/appbar.dart';
import 'package:internal_tool/widgets/colors.dart';
import 'package:internal_tool/widgets/transitions.dart';

class BoardsPage extends StatefulWidget {
  const BoardsPage({super.key});

  @override
  State<BoardsPage> createState() => _BoardsPageState();
}

class _BoardsPageState extends State<BoardsPage> {
  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    addBoard() {
      FirebaseFirestore.instance
          .collection('boards')
          .doc(uid)
          .collection('tasks')
          .add(
        {
          'bookmark': false,
          'mainTitle': '',
          'noteColor': 'cyan',
          'tasks': [],
        },
      );
    }

    return Scaffold(
      backgroundColor: bgBlack,
      floatingActionButton: FloatingActionButton(
        backgroundColor: yellow,
        onPressed: () {
          setState(() {
            addBoard();
          });
        },
        child: Center(
            child: Icon(
          Icons.add,
          color: black,
        )),
      ),
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
                  String title = documents[index]["mainTitle"] ?? "Error";
                  bool bookmark = documents[index]["bookmark"] ?? false;
                  List tasks = documents[index]["tasks"];
                  String noteColor = documents[index]["noteColor"];
                  String docId = documents[index].id;

                  return MainBoardWidget(
                    title: title,
                    bookmark: bookmark,
                    color: noteColor,
                    tasks: tasks,
                    onTap: () => mainSlideTransition(
                      context,
                      EditBoard(
                        docId: docId,
                        noteColor: noteColor,
                      ),
                      (value) => setState(() {}),
                    ),
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
