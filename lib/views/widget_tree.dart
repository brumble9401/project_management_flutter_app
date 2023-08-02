import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pma_dclv/views/authentication/signin.dart';
import 'package:pma_dclv/views/home.dart';

class MyWidgetTree extends StatefulWidget {
  const MyWidgetTree({super.key});

  @override
  State<MyWidgetTree> createState() => _MyWidgetTreeState();
}

class _MyWidgetTreeState extends State<MyWidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // The stream is still loading
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          // The user is authenticated
          return MyHomePage();
        } else {
          // The user is not authenticated
          return SignInScreen();
        }
      },
    );
  }
}
