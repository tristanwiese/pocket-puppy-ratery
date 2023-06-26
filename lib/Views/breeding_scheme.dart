import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final TextEditingController _nameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _nameKey = GlobalKey<FormState>();

  List chosenRatsList = [];
  bool showCustomRatScreen = false;

  @override
  void dispose() {
    _femaleController.dispose();
    _maleController.dispose();

    super.dispose();
  }

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
    return Form(
      key: _nameKey,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              !showCustomRatScreen
                  ? "Choose two rats from existing rats"
                  : "Enter name of two rats",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: MyInputText(
              controller: _nameController,
              hintText: "Name Scheme",
              validatorMessage: "Required",
              textInputAction: TextInputAction.next,
            ),
          ),
          showCustomRatScreen ? customRatScreen() : existingRatScreen(),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 150,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                if (showCustomRatScreen) {
                  setState(() {
                    showCustomRatScreen = false;
                  });
                  return;
                }
                setState(() {
                  showCustomRatScreen = true;
                });
              },
              style: MyElevatedButtonStyle.buttonStyle,
              child:
                  Text(showCustomRatScreen ? "Existing Rats" : "Custom Rats"),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: 150,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                if (_nameKey.currentState!.validate()) {
                  if (showCustomRatScreen) {
                    if (_formKey.currentState!.validate()) {
                      addScheme(
                          _maleController.text.trim(),
                          _femaleController.text.trim(),
                          _nameController.text.trim());
                    }
                    return;
                  }

                  if (chosenRatsList.length != 2) {
                    scaffoldKey.currentState!.showSnackBar(
                      const SnackBar(
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.green,
                        content: Text("Please choose two rats"),
                      ),
                    );
                    return;
                  }
                  if (chosenRatsList[0]["gender"] ==
                      chosenRatsList[1]["gender"]) {
                    scaffoldKey.currentState!.showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 2),
                        backgroundColor: primaryThemeColor,
                        content: const Text(
                            "Cannot choose 2 rats with the same gender"),
                      ),
                    );
                    return;
                  }
                  final male = chosenRatsList[chosenRatsList
                      .indexWhere((element) => element["gender"] == "Male")];
                  final female = chosenRatsList[chosenRatsList
                      .indexWhere((element) => element["gender"] == "Female")];
                  addScheme(male["name"], female["name"],
                      _nameController.text.trim());
                }
              },
              style: MyElevatedButtonStyle.buttonStyle,
              child: const Text("Create Scheme"),
            ),
          ),
        ],
      ),
    );
  }

  Widget customRatScreen() {
    return Expanded(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: MyInputText(
                controller: _maleController,
                hintText: "Male Rat",
                validatorMessage: "Required",
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: MyInputText(
                controller: _femaleController,
                hintText: 'Female Rat',
                validatorMessage: "Required",
                textInputAction: TextInputAction.done,
                onFieldSubmited: (p0) {
                  if (_formKey.currentState!.validate()) {
                    addScheme(
                        _maleController.text.trim(),
                        _femaleController.text.trim(),
                        _nameController.text.trim());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget existingRatScreen() {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.rats.length,
        itemBuilder: (context, index) {
          final rat = widget.rats[index];
          return Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: secondaryThemeColor)),
            child: ListTile(
              title: Text(rat["name"]),
              subtitle: Text(rat["gender"]),
              trailing: chosenRatsList.contains(rat)
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                if (chosenRatsList.contains(rat)) {
                  chosenRatsList.remove(rat);
                  setState(() {});
                  return;
                }
                if (chosenRatsList.length == 2) {
                  chosenRatsList.removeAt(1);
                  chosenRatsList.add(rat);
                  setState(() {});
                  return;
                }
                chosenRatsList.add(rat);
                setState(() {});
              },
            ),
          );
        },
      ),
    );
  }

  void addScheme(String male, String female, String name) async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("breedingSchemes")
        .add({"male": male, "female": female, "name": name});

    // ignore: use_build_context_synchronously
    navPop(context);
    navPop(context);
  }
}
