// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_authentication/firebase_authentication.dart';
import 'package:pocket_puppy_rattery/Functions/nav.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';
import 'dart:developer' as dev;

import 'package:pocket_puppy_rattery/Models/user.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _emailController =
      TextEditingController(text: "tristanwiese7472@gmail.com");
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  //Controlles page view
  //0 = Login, 1 = Register
  int pageState = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return pageState == 0
        ? Login(
            onPressedRegister: () {
              setState(() {
                pageState = 1;
              });
            },
            onPressedLogin: () async {
              if (_formKey.currentState!.validate()) {
                showDialog(
                    context: context,
                    builder: (context) =>
                        const Center(child: CircularProgressIndicator()));
                await login();
                navPop(context);
              }
            },
            formKey: _formKey,
            emailController: _emailController,
            passwordController: _passwordController,
            imagePath: "asstes/images/logo.png",
            imageHeight: 200,
            buttonStyle: ElevatedButton.styleFrom(
                fixedSize: Size(screenWidth * 0.6, 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
          )
        : Register(
            onPressedLogin: () {
              setState(() {
                pageState = 0;
              });
            },
            onPressedSubmit: () async {
              if (_formKey.currentState!.validate()) {
                showDialog(
                    context: context,
                    builder: (context) =>
                        const Center(child: CircularProgressIndicator()));
                await register();
              }
            },
            formKey: _formKey,
            emailController: _emailController,
            passwordController: _passwordController,
            nameController: _nameController,
            buttonStyle: ElevatedButton.styleFrom(
                fixedSize: Size(screenWidth * 0.6, 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            imagePath: "asstes/images/logo.png",
            imageHeight: 200,
          );
  }

  register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      navPop(context);
    } on FirebaseAuthException catch (e) {

      String eMessage = "";

      if (e.toString().contains("Password should be at least 6 characters")) {
        eMessage = "Password should be at least 6 characters long";
      } else if (e
          .toString()
          .contains("The email address is already in use by another account")) {
        eMessage = "Email already in use";
      }

      scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: Text(eMessage),
        duration: const Duration(seconds: 3),
        backgroundColor: primaryThemeColor,
      ));
      return;
    }
    addToDB();
  }

  login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      String eMessage = '';

      print(e.code + e.toString());

      if (e.toString().contains("many failed login attempts")) {
        eMessage = "Too many attempts, try again later!";
      } else {
        eMessage = "Email or password incorrect!";
      }

      scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: Text(eMessage),
        duration: const Duration(seconds: 3),
        backgroundColor: primaryThemeColor,
      ));
    }
  }
  
  addToDB() {
    final users = FirebaseFirestore.instance.collection("users");
    users.doc(FirebaseAuth.instance.currentUser!.uid).set(UserModel(
            email: _emailController.text, userName: _nameController.text)
        .toDB());
  }
}
