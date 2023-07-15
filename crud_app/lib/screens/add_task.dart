// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/screens/todo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddToDo extends StatefulWidget {
  const AddToDo({super.key});

  @override
  State<AddToDo> createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  TextEditingController titleControl = TextEditingController();
  TextEditingController descriptionControl = TextEditingController();

  addtasktofirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    String uid = user.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('mytasks')
        .doc(time.toString())
        .set({
      'title': titleControl.text,
      'description': descriptionControl.text,
      'time': time.toString(),
    });
    Fluttertoast.showToast(msg: 'Code 201! Cheers ;)');
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ToDoList(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add A Task"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleControl,
            decoration: InputDecoration(
              hintText: "Add the title to your task",
            ),
          ),
          SizedBox(height: 50),
          TextField(
            controller: descriptionControl,
            decoration: InputDecoration(
              hintText: "Description",
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 10,
          ),
          SizedBox(height: 50),
          ElevatedButton(
            style: ButtonStyle(backgroundColor:
                MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.green;
              }
              return Colors.blue;
            })),
            onPressed: addtasktofirebase,
            child: Text("Submit"),
          ),
        ],
      ),
    );
  }
}
