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
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))));

  static final cancelButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          side: BorderSide(color: secondaryThemeColor)));

  static final deleteButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.red[200],
      fixedSize: const Size(100, 40),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ));

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
  const DirectiveText({super.key, required this.text, this.italic = false});

  final String text;
  final bool italic;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: italic ? FontStyle.italic : FontStyle.normal),
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

class DeleteIcon extends StatelessWidget {
  const DeleteIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.delete, color: Colors.red[200]);
  }
}

class LoadScreen extends StatefulWidget {
  const LoadScreen({super.key});

  @override
  State<LoadScreen> createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  dynamic home;

  @override
  void initState() {
    super.initState;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );

    createHome();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  createHome() {
    _controller.forward();
    home = Scaffold(
      body: Center(
          child: Column(
        children: [
          RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
              child: Image.asset('asstes/images/Image.png', height: 500)),
          const SizedBox(height: 10),
          const Text(
            'Getting the Ratties out of their cages!',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return home;
  }
}

class NoRatScreen extends StatelessWidget {
  const NoRatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        // Todo: Add Image Asset
        Image.asset(
          "asstes/images/Rat.png",
          height: 400,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image),
        ),
        const Text(
          'Oh, no! We will have to get you some rats!',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ]),
    );
  }
}
