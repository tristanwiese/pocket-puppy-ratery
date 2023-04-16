import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('rats').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                final rats = snapshot.data!.docs;
                print(rats);
                return Center(child: myBody(rats));
              }

              return const Center(
                  child: Text(
                      'Oh no! I guess we will have to get you some rats!'));
            }));
  }

  myBody(rats) => ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 3),
        child: ListView.builder(
            itemCount: rats.length,
            itemBuilder: (BuildContext context, i) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(rats[i]['name']),
                  shape: const BeveledRectangleBorder(
                      side: BorderSide(width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  contentPadding: const EdgeInsets.all(10),
                ),
              );
            }),
      );

  FloatingActionButton myFloatingActionButton() => FloatingActionButton(
        onPressed: () {},
        tooltip: "Add Rat",
        child: const Icon(Icons.add),
      );
  myAppBar(BuildContext context) {
    return AppBar();
  }
}
