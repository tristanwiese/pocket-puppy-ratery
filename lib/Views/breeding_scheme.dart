import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Functions/nav.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';
import 'package:pocket_puppy_rattery/Views/add_rat.dart';

class BreedingScheme extends StatefulWidget {
  const BreedingScheme({super.key, required this.rats});

  final rats;

  @override
  State<BreedingScheme> createState() => _BreedingSchemeState();
}

class _BreedingSchemeState extends State<BreedingScheme> {
  final TextEditingController _maleController = TextEditingController();
  final TextEditingController _femaleController = TextEditingController();

  final GlobalKey<FormState> _fomrKey = GlobalKey<FormState>();

  List chosenratsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Breeding Scheme"),
      ),
      body: body(),
    );
  }

  Widget body() {
    return Center(
      child: Form(
        key: _fomrKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Column(
              children: [
                const Text(
                  "Enter Custom Rat details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: MyInputText(
                    controller: _maleController,
                    hintText: "Male Rat",
                    validatorMessage: "Required",
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: MyInputText(
                    controller: _femaleController,
                    hintText: "Female Rat",
                    validatorMessage: "Required",
                  ),
                ),
                const Text(
                  "or",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          onPressed: () {
                            _femaleController.clear();
                            _maleController.clear();
                            showDialog(
                              context: context,
                              builder: (context) {
                                return existingRatsList();
                              },
                            );
                          },
                          style: MyElevatedButtonStyle.buttonStyle,
                          child: const Text("Choose Existing Rats"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(10),
              width: 150,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  if (_fomrKey.currentState!.validate()) {
                    print(_maleController.text + "\n" + _maleController.text);
                  }
                },
                style: MyElevatedButtonStyle.buttonStyle,
                child: const Text("Create Scheme"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget existingRatsList() {
    final List<QueryDocumentSnapshot<Object?>> rats = widget.rats;

    const title = Text("Existing Rats");

    final actions = [
      ElevatedButton(
        onPressed: () {
          navPop(context);
        },
        style: MyElevatedButtonStyle.buttonStyle,
        child: const Text("Cancel"),
      ),
      ElevatedButton(
          onPressed: () {},
          style: MyElevatedButtonStyle.buttonStyle,
          child: const Text("Done"))
    ];

    final content = ListView.builder(
      itemCount: rats.length,
      itemBuilder: (context, index) {
        return StatefulBuilder(
          builder: (context, setState) {
            final rat = rats[index];
            return Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide()),
              child: ListTile(
                trailing: chosenratsList.contains(rat["name"])
                    ? const Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    : null,
                onTap: () {
                  print(chosenratsList.length);
                  if(chosenratsList.contains(rat["name"])){
                    chosenratsList.remove(rat["name"]);
                    setState((){});
                    print(chosenratsList);
                    return;
                  }
                  if (chosenratsList.length == 2){
                    chosenratsList.removeAt(1);
                    chosenratsList.add(rat["name"]);
                    print(chosenratsList);
                    setState((){});
                    return;
                  }
                  chosenratsList.add(rat["name"]);
                  setState((){});
                  print(chosenratsList);
                },
                title: Text(rat["name"]),
              ),
            );
          },
        );
      },
    );

    return AlertDialog(
      title: title,
      actions: actions,
      content: content,
    );
  }
}
