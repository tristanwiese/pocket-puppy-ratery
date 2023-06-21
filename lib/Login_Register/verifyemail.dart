import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';
import 'package:pocket_puppy_rattery/Views/home_page.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  late bool emailVerified;
  Timer? timer;

  @override
  void initState() {
    emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!emailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: myBody(),
    );
  }

  myBody() {
    return !emailVerified
        ? Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "asstes/images/logo.png",
                height: 200,
              ),
              const Text(
                "Verifying Email...",
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 10),
              const Text(
                "Check inox for link",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                    onPressed: () {
                      sendVerificationEmail();
                    },
                    style: MyElevatedButtonStyle.buttonStyle,
                    child: const Text("Resend Email")),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                height: 40,
                child: ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                    style: MyElevatedButtonStyle.buttonStyle,
                    child: const Text("Cancel")),
              )
            ],
          ))
        : const MyHomePage();
  }

  void sendVerificationEmail() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      scaffoldKey.currentState!
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (emailVerified) {
      timer?.cancel();
    }
  }
}
