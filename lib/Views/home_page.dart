import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Functions/nav.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';
import 'package:pocket_puppy_rattery/Views/add_rat.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double getSize() {
    if (MediaQuery.of(context).size.width < 435) {
      return MediaQuery.of(context).size.width / 2;
    } else {
      return MediaQuery.of(context).size.width / 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    log(MediaQuery.of(context).size.width.toString());
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("asstes/images/Paws.jpg"))),
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('rats').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              final rats = snapshot.data!.docs;
              return Center(child: myBody(rats));
            }
            return const LoadScreen();
          }),
    );
  }

  myBody(rats) => Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      appBar: myAppBar(context),
      floatingActionButton: myFloatingActionButton(),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.line_style_outlined), label: 'Details'),
            BottomNavigationBarItem(
                icon: Icon(Icons.logout_outlined), label: 'Logout')
          ]),
      body: rats.isEmpty
          ? const NoRatScreen()
          : Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: getSize()),
                child: ListView.builder(
                    itemCount: rats.length,
                    itemBuilder: (BuildContext context, i) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          trailing: myIconButton(rats[i]['name']),
                          title: Text(rats[i]['name']),
                          shape: BeveledRectangleBorder(
                              side: BorderSide(
                                  width: 1, color: secondaryThemeColor),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15))),
                          contentPadding: const EdgeInsets.all(10),
                        ),
                      );
                    }),
              ),
            ));

  IconButton myIconButton(name) => IconButton(
      onPressed: () =>
          FirebaseFirestore.instance.collection('rats').doc(name).delete(),
      icon: Icon(Icons.delete, color: Colors.red[200]));

  FloatingActionButton myFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => navPush(context, const AddRat()),
      tooltip: "Add Rat",
      backgroundColor: secondaryThemeColor,
      child: const Icon(Icons.add),
    );
  }

  myAppBar(BuildContext context) {
    return AppBar(
      title: const Center(child: Text('Your Rats')),
    );
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
              child: Image.asset('asstes/images/image.png', height: 500)),
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
          '', //TODO: Add Image Asset Here,
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
