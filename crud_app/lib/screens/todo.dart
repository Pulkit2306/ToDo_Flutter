// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, sized_box_for_whitespace, await_only_futures, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/auth/authscreen.dart';
import 'package:crud_app/screens/add_task.dart';
import 'package:crud_app/screens/edit_task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  String uid = '';

  @override
  void initState() {
    getuid();
    super.initState();
  }

  getuid() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;

    setState(() {
      uid = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AuthScreen()),
              );
            },
            icon: Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('tasks')
              .doc(uid)
              .collection('mytasks')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final docus = snapshot.data!.docs;
              return ListView.builder(
                itemCount: docus.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(docus[index]['time']),
                    onDismissed: (direction) async {
                      await FirebaseFirestore.instance
                          .collection('tasks')
                          .doc(uid)
                          .collection('mytasks')
                          .doc(docus[index]['time'])
                          .delete();
                    },
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Description(
                              title: docus[index]['title'],
                              description: docus[index]['description'],
                              timE: docus[index]['time'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 20,
                          bottom: 20,
                        ),
                        height: 80,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 11, 148, 228),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Text(
                                    docus[index]['title'],
                                    style: GoogleFonts.roboto(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              child: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('tasks')
                                      .doc(uid)
                                      .collection('mytasks')
                                      .doc(docus[index]['time'])
                                      .delete();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateTo,
        label: const Text("Add Task"),
        backgroundColor: Colors.black,
      ),
    );
  }

  void navigateTo() {
    final route = MaterialPageRoute(
      builder: (context) => AddToDo(),
    );
    Navigator.push(context, route);
  }
}
