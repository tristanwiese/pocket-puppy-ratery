library firebase_authentication;

import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({
    super.key,
    this.imagePath,
    this.imageHeight,
    this.buttonStyle,
    this.onFieldSubmitted,
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
  final void Function(String)? onFieldSubmitted;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool passwordObscure = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Form(
          key: widget.formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                widget.imagePath != null
                    ? Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: const Text(
                              "Pocket Puppy Rattery",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Image(
                              image: AssetImage(widget.imagePath!),
                              height: widget.imageHeight),
                        ],
                      )
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
                        textInputAction: TextInputAction.next,
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
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
                        textInputAction: TextInputAction.go,
                        onFieldSubmitted: widget.onFieldSubmitted,
                        isObscure: passwordObscure,
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () => setState(() {
                            if (passwordObscure) {
                              passwordObscure = false;
                              return;
                            }
                            passwordObscure = true;
                          }),
                        ),
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
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
      this.onFieldSubmitted,
      required this.onPressedLogin,
      required this.formKey,
      required this.onPressedSubmit,
      required this.emailController,
      required this.passwordController,
      required this.nameController});

  final String? imagePath;
  final double? imageHeight;
  final ButtonStyle? buttonStyle;
  final VoidCallback onPressedLogin;
  final GlobalKey<FormState> formKey;
  final VoidCallback onPressedSubmit;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final void Function(String)? onFieldSubmitted;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool passwordObscure = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Form(
          key: widget.formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                widget.imagePath != null
                    ? Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: const Text(
                              "Pocket Puppy Rattery",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Image(
                              image: AssetImage(widget.imagePath!),
                              height: widget.imageHeight),
                        ],
                      )
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
                        textInputAction: TextInputAction.next,
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return "Required";
                          }
                          return null;
                        },
                        controller: widget.nameController,
                        hintText: "Name",
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: screenWidth * 0.6,
                      child: MyInputField(
                        textInputAction: TextInputAction.next,
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
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
                        onFieldSubmitted: widget.onFieldSubmitted,
                        textInputAction: TextInputAction.go,
                        isObscure: passwordObscure,
                        suffixIcon: IconButton(
                          icon: Icon(passwordObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () => setState(() {
                            if (passwordObscure) {
                              passwordObscure = false;
                              return;
                            }
                            passwordObscure = true;
                          }),
                        ),
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
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
      ),
    );
  }
}

// ignore: must_be_immutable
class MyInputField extends StatelessWidget {
  MyInputField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.validator,
      required this.textInputAction,
      this.onFieldSubmitted,
      this.isObscure = false,
      this.suffixIcon});

  final TextEditingController controller;
  final String hintText;
  final String? Function(String?) validator;
  final IconButton? suffixIcon;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;
  bool isObscure;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
      textInputAction: textInputAction,
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
          suffixIcon: suffixIcon,
          border: const OutlineInputBorder(),
          hintText: hintText),
    );
  }
}
