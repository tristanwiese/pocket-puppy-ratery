import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_authentication/firebase_authentication.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';
import 'dart:developer' as dev;

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController(text: "tristanwiese472@gmail.com");
  TextEditingController _passwordController = TextEditingController();

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
            onPressedRegister: () {},
            onPressedLogin: () async{
              if (_formKey.currentState!.validate()) {
                try{
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text,
                );
                }on FirebaseAuthException catch (e){

                  String eMessage = '';

                  dev.log(e.code);
                  dev.log(e.toString());
                  
                  switch (e.code){
                    case "wrong-password" : eMessage = "Email or password was wrong";
                    break;
                    default: eMessage = "Something went wrong";
                    break;
                  }

                  scaffoldKey.currentState!.showSnackBar(
                      SnackBar(
                        content: Text(eMessage),
                        duration: const Duration(seconds: 2),
                        backgroundColor: primaryThemeColor,
                      )
                    );
                }
              }
            },
            formKey: _formKey,
            emailController: _emailController,
            passwordController: _passwordController,
            imagePath: "asstes/images/Image.png",
            imageHeight: 300,
            buttonStyle: ElevatedButton.styleFrom(
                fixedSize: Size(screenWidth * 0.6, 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
          )
        : Register(
            onPressedLogin: () {},
            onPressedSubmit: () {},
            formKey: _formKey,
            emailController: _emailController,
            passwordController: _passwordController,
          );
  }
}
