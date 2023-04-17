import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Functions/nav.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';

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
                return Center(child: myBody(rats));
              }
              return const Center(
                  child: CircularProgressIndicator());
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
                  shape: BeveledRectangleBorder(
                      side: BorderSide(width: 1, color: secondaryThemeColor),
                      borderRadius: const BorderRadius.all(Radius.circular(15))),
                  contentPadding: const EdgeInsets.all(10),
                ),
              );
            }),
      );

  FloatingActionButton myFloatingActionButton() {
    
    return FloatingActionButton(
        onPressed: () =>
            showDialog(context: context, builder: (context) => const AddRat()),
        tooltip: "Add Rat",
        backgroundColor: secondaryThemeColor,
        child: const Icon(Icons.add),
      );
  }
  myAppBar(BuildContext context) {
    return AppBar();
  }
}

class AddRat extends StatefulWidget {
  const AddRat({super.key});

  @override
  State<AddRat> createState() => _AddRatState();
}

class _AddRatState extends State<AddRat> {
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: const Text('Rat Details'),
        actions: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(hintText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Name cannot be empty";
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }
                  FirebaseFirestore.instance
                      .collection('rats')
                      .doc(nameController.text.trim())
                      .set({"name": nameController.text.trim()});
                  navPop(context);
                },
                style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                    minimumSize: const Size(100, 50),
                    backgroundColor: secondaryThemeColor
                    ),
                    
                child: const Text('Save')),
          )
        ],
      ),
    );
  }
}
