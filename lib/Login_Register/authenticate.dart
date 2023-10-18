// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_authentication/firebase_authentication.dart';
import 'package:pocket_puppy_rattery/Functions/nav.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';

import 'package:pocket_puppy_rattery/Models/user.dart';

import '../Services/custom_widgets.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

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
            onPressedForgotPassword: () {
              navPush(context, ForgotPasswordPage());
            },
            onFieldSubmitted: (p0) async {
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
            forgotPasswordTextColor: primaryThemeColor,
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
            onFieldSubmitted: (p0) async {
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

      alert(text: eMessage);
      navPop(context);
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
      if (e.toString().contains("many failed login attempts")) {
        eMessage = "Too many attempts, try again later!";
      } else {
        eMessage = "Email or password incorrect!";
      }

      alert(text: eMessage);
    }
  }

  addToDB() {
    log("Messed with user DB");

    final users = FirebaseFirestore.instance.collection("users");
    users.doc(FirebaseAuth.instance.currentUser!.uid).set(
        UserModel(email: _emailController.text, userName: _nameController.text)
            .toDB());
  }
}

class ForgotPasswordPage extends StatelessWidget {
  ForgotPasswordPage({super.key});

  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Forgot Password")),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Enter enter email to send password reset email",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextFormField(
                  decoration: const InputDecoration(
                      hintText: "Email", border: OutlineInputBorder()),
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 150,
                height: 40,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              const Center(child: CircularProgressIndicator()));
                      await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: _emailController.text.trim());
                      navPop(context);
                      alert(text: "Email sent! Please check inbox");
                      return;
                    }
                  },
                  style: MyElevatedButtonStyle.buttonStyle,
                  child: const Text("Reset Password"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
