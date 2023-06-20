library firebase_authentication;

import 'package:flutter/material.dart';



class Login extends StatefulWidget {
  const Login(
      {super.key,
      this.imagePath,
      this.imageHeight,
      this.buttonStyle,
      required this.onPressedRegister,
      required this.formKey,
      required this.onPressedLogin,
      required this.emailController,
      required this.passwordController,
      });

  final String? imagePath;
  final double? imageHeight;
  final ButtonStyle? buttonStyle;
  final VoidCallback onPressedRegister;
  final GlobalKey<FormState> formKey;
  final VoidCallback onPressedLogin;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          key: widget.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              widget.imagePath != null
                  ? Image(
                      image: AssetImage(widget.imagePath!),
                      height: widget.imageHeight)
                  : Container(),
              Column(
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: screenWidth * 0.6,
                    child: MyInputField(
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty){
                          return "Required";
                        }
                        return null;
                      },
                      controller: widget.emailController,
                      hintText: "Email",
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: screenWidth * 0.6,
                    child: MyInputField(
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty){
                          return "Required";
                        }
                        return null;
                      },
                      controller: widget.passwordController,
                      hintText: "Password",
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: widget.onPressedLogin,
                    style: widget.buttonStyle,
                    child: const Text("Login"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: widget.onPressedRegister,
                    style: widget.buttonStyle,
                    child: const Text("Register"),
                  ),
                ],
              ),
              Container()
            ],
          ),
        ),
      ),
    );
  }
  
}
class Register extends StatefulWidget {
  const Register(
      {super.key,
      this.imagePath,
      this.imageHeight,
      this.buttonStyle,
      required this.onPressedLogin,
      required this.formKey,
      required this.onPressedSubmit,
      required this.emailController,
      required this.passwordController,
      });

  final String? imagePath;
  final double? imageHeight;
  final ButtonStyle? buttonStyle;
  final VoidCallback onPressedLogin;
  final GlobalKey<FormState> formKey;
  final VoidCallback onPressedSubmit;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          key: widget.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              widget.imagePath != null
                  ? Image(
                      image: AssetImage(widget.imagePath!),
                      height: widget.imageHeight)
                  : Container(),
              Column(
                children: [
                  const Text(
                    "Register",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: screenWidth * 0.6,
                    child: MyInputField(
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty){
                          return "Required";
                        }
                        return null;
                      },
                      controller: widget.emailController,
                      hintText: "Email",
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: screenWidth * 0.6,
                    child: MyInputField(
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty){
                          return "Required";
                        }
                        return null;
                      },
                      controller: widget.passwordController,
                      hintText: "Password",
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: widget.onPressedSubmit,
                    style: widget.buttonStyle,
                    child: const Text("Submit"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: widget.onPressedLogin,
                    style: widget.buttonStyle,
                    child: const Text("Login"),
                  ),
                ],
              ),
              Container()
            ],
          ),
        ),
      ),
    );
  }

  

 
}
class MyInputField extends StatelessWidget {
   MyInputField(
      {super.key, required this.controller, required this.hintText, required this.validator});

  final TextEditingController controller;
  final String hintText;
  String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(), hintText: hintText),
    );
  }
}