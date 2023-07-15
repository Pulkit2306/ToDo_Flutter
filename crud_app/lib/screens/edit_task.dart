// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/screens/todo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class Description extends StatefulWidget {
  String title, description, timE;
  Description(
      {super.key,
      required this.title,
      required this.description,
      required this.timE});

  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  TextEditingController titlecontrol = TextEditingController();
  TextEditingController descriptioncontrol = TextEditingController();

  @override
  void initState() {
    super.initState();
    final text = widget.title;
    final texT = widget.description;

    titlecontrol.text = text;
    descriptioncontrol.text = texT;
  }

  Future<void> updatetask() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    String uid = user.uid;
    // var time = DateTime.now();
    String time = widget.timE;
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('mytasks')
        .doc(time)
        .update({
      'title': titlecontrol.text,
      'description': descriptioncontrol.text,
    });
    Fluttertoast.showToast(msg: 'Updated Successfully!)');
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ToDoList(),
    ));
  }

  // @override
  // void initState() {
  //   super.initState();
  //   titlecontrol.text;
  //   descriptioncontrol.text;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: TextField(
                controller: titlecontrol,
                style: GoogleFonts.roboto(
                    fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextField(
                controller: descriptioncontrol,
                style: GoogleFonts.roboto(fontSize: 20),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.all(10),
              height: 80,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: updatetask,
                child: Text(
                  "Update",
                  style: GoogleFonts.roboto(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
