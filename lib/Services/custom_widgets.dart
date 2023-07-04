import 'package:flutter/material.dart';

import '../Functions/utils.dart';

class MyElevatedButtonStyle {
  static final buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: secondaryThemeColor),
    ),
  );

  static final activeButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: secondaryThemeColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: secondaryThemeColor),
    ),
  );
  static final doneButtonStyle = ElevatedButton.styleFrom(
      fixedSize: const Size(100, 40),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))));
  static final cancelButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      fixedSize: const Size(100, 40),
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          side: BorderSide(color: secondaryThemeColor)));

  static const textStyle = TextStyle(color: Colors.black87);
}

class MyInfoCard extends StatelessWidget {
  const MyInfoCard({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
          // side: BorderSide(
          //   color: secondaryThemeColor,
          //   width: 1.4,
          // ),
          borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            child
          ],
        ),
      ),
    );
  }
}

class MyInputText extends StatelessWidget {
  const MyInputText(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.validatorMessage,
      this.onFieldSubmited,
      required this.textInputAction});

  final TextEditingController controller;
  final String hintText;
  final String validatorMessage;
  final void Function(String)? onFieldSubmited;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        onFieldSubmitted: onFieldSubmited,
        textInputAction: textInputAction,
        controller: controller,
        decoration: InputDecoration(
            hintText: hintText, border: const OutlineInputBorder()),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validatorMessage;
          }
          return null;
        },
      ),
    );
  }
}

class DirectiveText extends StatelessWidget {
  const DirectiveText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class DrawerCard extends StatelessWidget {
  const DrawerCard({
    super.key,
    required this.onTap,
    required this.title,
    required this.iconData,
  });

  final VoidCallback onTap;
  final String title;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(width: 1.5, color: secondaryThemeColor)),
      elevation: 10,
      margin: const EdgeInsets.all(10),
      child: ListTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          trailing: Icon(iconData, color: secondaryThemeColor),
          onTap: onTap),
    );
  }
}
