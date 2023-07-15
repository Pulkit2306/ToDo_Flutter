// ignore_for_file: prefer_const_constructors

import "package:crud_app/auth/authscreen.dart";
import "package:crud_app/screens/theme.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:crud_app/screens/todo.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: MyThemes.lightTheme,
      darkTheme: MyThemes.darkTheme,
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, usersnapshot) {
            if (usersnapshot.hasData) {
              return ToDoList();
            } else {
              return AuthScreen();
            }
          }),
    );
  }
}
