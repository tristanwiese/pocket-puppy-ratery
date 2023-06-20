import 'dart:js_interop';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Views/home_page.dart';

import 'authenticate.dart';

class AuthState extends StatelessWidget {
  const AuthState({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.data.isNull){
          return const Authenticate();
        } else {
          print("Logged In");
          return const MyHomePage();
        }
      },);
  }
}