// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Functions/nav.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';
import 'package:pocket_puppy_rattery/Models/breeding_scheme_model.dart';
import 'package:pocket_puppy_rattery/providers/breeding_scheme_provider.dart';
import 'package:provider/provider.dart';
import '../../Services/custom_widgets.dart';

class BreedingScheme extends StatefulWidget {
  const BreedingScheme({
    super.key,
    required this.rats,
    required this.schemeCount,
    this.chosenRats,
    this.date,
    this.isCustomRats,
    this.name,
    this.id,
  });

  final List<QueryDocumentSnapshot> rats;
  final int schemeCount;
  final List<String>? chosenRats;
  final DateTime? date;
  final bool? isCustomRats;
  final String? name;
  final String? id;

  @override
  State<BreedingScheme> createState() => _BreedingSchemeState();
}

class _BreedingSchemeState extends State<BreedingScheme> {
  TextEditingController _maleController = TextEditingController();
  TextEditingController _femaleController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _nameKey = GlobalKey<FormState>();

  List chosenRatsList = [];
  bool showCustomRatScreen = false;

  DateTime? customDate;

  String createSchemeButtonText = "Create Scheme";

  @override
  void initState() {
    if (widget.isCustomRats != null) {
      createSchemeButtonText = "Update Scheme";
      _maleController = TextEditingController(text: widget.chosenRats![0]);
      _femaleController = TextEditingController(text: widget.chosenRats![1]);
      customDate = widget.date;
      _nameController = TextEditingController(text: widget.name);
      showCustomRatScreen = true;
      if (!widget.isCustomRats!) {
        for (String id in widget.chosenRats!) {
          chosenRatsList.add(widget
              .rats[widget.rats.indexWhere((element) => element.id == id)]);
        }
        _maleController.clear();
        _femaleController.clear();
        showCustomRatScreen = false;
      }
      return;
    }

    _nameController =
        TextEditingController(text: "Scheme: ${widget.schemeCount + 1}");

    super.initState();
  }

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
    return SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: _nameKey,
          child: Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 80,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      !showCustomRatScreen
                          ? "Choose two rats from existing rats"
                          : "Enter name of two rats",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const DirectiveText(text: "Name Scheme: "),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: "Name Scheme",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Required";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  const DirectiveText(
                      text: "Select Custom date. Defaults to current date"),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        customDate = await showDatePicker(
                          context: context,
                          initialDate:
                              customDate == null ? DateTime.now() : customDate!,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                      },
                      style: MyElevatedButtonStyle.buttonStyle,
                      child: const Text("Custom Date"),
                    ),
                  ),
                  const SizedBox(height: 50),
                  showCustomRatScreen
                      ? Container()
                      : const DirectiveText(text: "Select rat"),
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
                      child: Text(showCustomRatScreen
                          ? "Existing Rats"
                          : "Custom Rats"),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    width: 150,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_nameKey.currentState!.validate()) {
                          if (showCustomRatScreen) {
                            if (_formKey.currentState!.validate()) {
                              await addScheme(
                                dateOfBreeding: (customDate == null)
                                    ? DateTime.now()
                                    : customDate!,
                                male: _maleController.text.trim(),
                                female: _femaleController.text.trim(),
                                name: _nameController.text.trim(),
                              );

                              navPop(context);
                            }
                            return;
                          }

                          if (chosenRatsList.length != 2) {
                            alert(text: "Please choose two rats");
                            return;
                          }
                          if (chosenRatsList[0]["gender"] ==
                              chosenRatsList[1]["gender"]) {
                            alert(
                                text:
                                    "Cannot choose 2 rats with the same gender");
                            return;
                          }
                          final QueryDocumentSnapshot<Object?> male =
                              chosenRatsList[chosenRatsList.indexWhere(
                                  (element) => element["gender"] == "Male")];
                          final QueryDocumentSnapshot<Object?> female =
                              chosenRatsList[chosenRatsList.indexWhere(
                                  (element) => element["gender"] == "Female")];

                          await addScheme(
                            male: male.id,
                            female: female.id,
                            name: _nameController.text.trim(),
                            dateOfBreeding: (customDate == null)
                                ? DateTime.now()
                                : customDate!,
                          );
                          navPop(context);
                        }
                      },
                      style: MyElevatedButtonStyle.buttonStyle,
                      child: Text(createSchemeButtonText),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
            const DirectiveText(text: "Name Rats"),
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
                        dateOfBreeding:
                            (customDate == null) ? DateTime.now() : customDate!,
                        male: _maleController.text.trim(),
                        female: _femaleController.text.trim(),
                        name: _nameController.text.trim());
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
            color: chosenRatsList.contains(rat) ? primaryThemeColor : null,
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

  Future addScheme({
    required String male,
    required String female,
    required String name,
    required DateTime dateOfBreeding,
  }) async {
    BreedingSchemeProvider provider =
        Provider.of<BreedingSchemeProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (widget.name == null) {
      final scheme = BreedingSchemeModel(
        male: male,
        female: female,
        name: name,
        isCustomRats: showCustomRatScreen,
        date: dateOfBreeding,
      );
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("breedingSchemes")
          .add(scheme.toDB());
    } else {
      final scheme = BreedingSchemeModel(
        male: male,
        female: female,
        name: name,
        isCustomRats: showCustomRatScreen,
        date: dateOfBreeding,
        dateOfLabour: provider.getScheme.dateOfLabour,
        notes: provider.getScheme.notes,
        numberOfPups: provider.getScheme.numberOfPups,
        weightTracker: provider.getScheme.weightTracker,
      );
      FirebaseSchemes.doc(widget.id).update(scheme.toDB());

      provider.updateScheme(scheme);
    }
    navPop(context);
  }
}
