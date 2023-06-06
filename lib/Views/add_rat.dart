// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Functions/nav.dart';
import '../Functions/utils.dart';
import '../Models/rat.dart';
import '../Services/constants.dart';

const List<Text> toggleMarkings = <Text>[Text('C-Locus'), Text('H-Locus')];
const List<Text> toggleGender = <Text>[Text("Male"), Text("Female")];

List<String> cMarkingList = Rat.cLocusToList();
List<String> hMarkingsList = Rat.hLocusToList();
List<String> colorsList = Rat.colorsToList();
List<String> earsList = Rat.earsToList();
List<String> coatsList = Rat.coatsToList();
List<String> genderList = Rat.genderToList();

class AddRat extends StatefulWidget {
  const AddRat(
      {super.key,
      this.id,
      this.name,
      this.coat,
      this.color,
      this.ears,
      this.father,
      this.mother,
      this.regName,
      this.birthday,
      this.gender,
      this.markings});
  final String? name;
  final String? regName;
  final List? color;
  final String? ears;
  final String? coat;
  final String? mother;
  final String? father;
  final String? gender;
  final DateTime? birthday;
  final List? markings;
  final String? id;

  @override
  State<AddRat> createState() => _AddRatState();
}

class _AddRatState extends State<AddRat> {
  //TextEditControllers
  TextEditingController nameController = TextEditingController();
  TextEditingController momController = TextEditingController();
  TextEditingController dadController = TextEditingController();
  TextEditingController registeredNameController = TextEditingController();

  //dropdown list values
  String? colourController;
  String? earController;
  String? coatController;
  String? genderValue;
  List actvieMarkingsList = [];
  List activeColorsList = [];

  Gender? _pickedGender;

  List<String> markingList = cMarkingList;

  DateTime? _pickedDate;
  DateTime _selectedDate = DateTime.now();

  List<bool> selectedMarkings = <bool>[true, false];
List<bool> selectedGender = <bool>[false, false];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.name != null) {
      log("fired!");
      nameController = TextEditingController(text: widget.name);
      momController = TextEditingController(text: widget.mother);
      dadController = TextEditingController(text: widget.father);
      registeredNameController = TextEditingController(text: widget.regName);
      activeColorsList = widget.color!;
      earController = widget.ears;
      coatController = widget.coat;
      actvieMarkingsList = widget.markings!;
      activeColorsList = widget.color!;
      _selectedDate = widget.birthday!;

      if (widget.gender == "Male") {
        _pickedGender = Gender.Male;
        selectedGender = [true, false];
      } else {
        _pickedGender = Gender.Female;
        selectedGender = [false, true];
      }
      if (getMarkingtype(widget.markings!) == "hLocus") {
        markingList = hMarkingsList;
        selectedMarkings = [false, true];
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    momController.dispose();
    dadController.dispose();
    registeredNameController.dispose();

    super.dispose();
  }

  getMarkingtype(List markings) {
    for (int i = 0; i < cMarkingList.length; i++) {
      if (markings.contains(cMarkingList[i])) {
        return "cLocus";
      }
    }
    return "hLocus";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: 500,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyInputText(
                          controller: nameController,
                          hintText: 'Name',
                          validatorMessage: 'Name required'),
                      MyInputText(
                          controller: registeredNameController,
                          hintText: 'Registered Name',
                          validatorMessage: 'Regestered Name Required'),
                      MyInputText(
                          controller: momController,
                          hintText: 'Parent: Mother',
                          validatorMessage: 'Parent Required'),
                      MyInputText(
                          controller: dadController,
                          hintText: 'Parent: Father',
                          validatorMessage: 'Parent Required'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: CoatSelect()),
                          const SizedBox(width: 10),
                          Expanded(child: EarSelect()),
                          const SizedBox(width: 10),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ColorSelect(),
                      const SizedBox(height: 10),
                      LocusSelect(),
                      const SizedBox(height: 10),
                      locusDropdownButton(),
                      const SizedBox(height: 10),
                      GenderSelect(),
                      const SizedBox(height: 10),
                      BirthdaySelect(context),
                      const SizedBox(height: 10),
                      SaveButton(context),
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget SaveButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) {
              return;
            }
            showDialog(
              context: context,
              builder: (context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
            if (_pickedGender == null) {
              showError("Gender");
              navPop(context);
              return;
            }
            if (actvieMarkingsList.isEmpty) {
              showError("Markings");
              navPop(context);
              return;
            }
            if (activeColorsList.isEmpty){
              showError("Colors");
              navPop(context);
              return;
            }
            if (earController == null){
              showError("Ears");
              navPop(context);
              return;
            }
            if (coatController == null){
              showError("Coat");
              navPop(context);
              return;
            }
            final Rat rat = Rat(
              name: nameController.text.trim(),
              registeredName: registeredNameController.text.trim(),
              colours: activeColorsList,
              ears: Ears.values[
                  earsList.indexWhere((element) => element == earController)],
              gender: _pickedGender!,
              markings: actvieMarkingsList,
              parents: Parents(
                  dad: dadController.text.trim(),
                  mom: momController.text.trim()),
              coat: Coats.values[
                  coatsList.indexWhere((element) => element == coatController)],
              birthday: _selectedDate,
            );
            if (widget.name != null) {
              await FirebaseFirestore.instance
                  .collection("rats")
                  .doc(widget.id)
                  .update(rat.toDb());

              navPop(context);
              return;
            }
            await FirebaseFirestore.instance
                .collection("rats")
                .doc()
                .set(rat.toDb());
            navPop(context);
            navPop(context);
          },
          style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              minimumSize: const Size(100, 50),
              backgroundColor: secondaryThemeColor),
          child: const Text('Save')),
    );
  }

  Widget BirthdaySelect(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        _pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (_pickedDate != null && _pickedDate != _selectedDate) {
          setState(() {
            _selectedDate = _pickedDate!;
          });
          log(_selectedDate.toString());
        }
      },
      style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(60),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: secondaryThemeColor))),
      child: const Text('Brithday', style: TextStyle(color: Colors.black87)),
    );
  }

  Widget GenderSelect() {
    return ToggleButtons(
      onPressed: (index) {
        for (var i = 0; i < 2; i++) {
          setState(() {
            selectedGender[i] = false;
          });
        }
        selectedGender[index] = !selectedGender[index];
        _pickedGender = Gender.values[index];
        setState(() {});
      },
      isSelected: selectedGender,
      direction: Axis.horizontal,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      selectedBorderColor: Colors.black,
      selectedColor: Colors.white,
      fillColor: secondaryThemeColor,
      color: secondaryThemeColor,
      constraints: BoxConstraints(
        minHeight: 40.0,
        minWidth: (MediaQuery.of(context).size.width <= 500)
            ? (MediaQuery.of(context).size.width / 2) - 20
            : 240,
      ),
      children: toggleGender,
    );
  }

  Widget locusDropdownButton() {
    return showListButton(
        listOf: "Markings",
        title:
            "Choose Markings: ${toggleMarkings[selectedMarkings.indexWhere((element) => element == true)].data}",
        buildList: markingList,
        activeList: actvieMarkingsList);
  }

  Widget LocusSelect() {
    return ToggleButtons(
      onPressed: (index) {
        for (var i = 0; i < 2; i++) {
          setState(() {
            selectedMarkings[i] = false;
          });
        }
        selectedMarkings[index] = !selectedMarkings[index];
        if (index == 0) {
          markingList = cMarkingList;
          actvieMarkingsList.clear();
        } else {
          markingList = hMarkingsList;
          actvieMarkingsList.clear();
        }
        setState(() {});
      },
      isSelected: selectedMarkings,
      direction: Axis.horizontal,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      selectedBorderColor: Colors.black,
      selectedColor: Colors.white,
      fillColor: secondaryThemeColor,
      color: secondaryThemeColor,
      constraints: BoxConstraints(
        minHeight: 40.0,
        minWidth: (MediaQuery.of(context).size.width <= 500)
            ? (MediaQuery.of(context).size.width / 2) - 20
            : 240,
      ),
      children: toggleMarkings,
    );
  }

  Widget CoatSelect() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: secondaryThemeColor, width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: const Center(
              child: Text('Coat',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15))),
          value: coatController,
          items: coatsList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Center(
                child: Text(
                  value,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              coatController = value!;
            });
          },
        ),
      ),
    );
  }

  Widget EarSelect() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: secondaryThemeColor, width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: const Center(
              child: Text('Ears',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15))),
          value: earController,
          items: earsList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Center(
                child: Text(
                  value,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              earController = value!;
            });
          },
        ),
      ),
    );
  }

  Widget ColorSelect() {
    return showListButton(
        title: "Choose Colour",
        listOf: "Colors",
        buildList: colorsList,
        activeList: activeColorsList);
    // return Container(
    //   width: 50,
    //   decoration: BoxDecoration(
    //       border: Border.all(color: secondaryThemeColor, width: 2),
    //       borderRadius: BorderRadius.circular(10)),
    //   child: DropdownButtonHideUnderline(
    //     child: DropdownButton<String>(
    //       isExpanded: true,
    //       hint: const Center(
    //           child: Text('Colors',
    //               style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15))),
    //       value: colourController,
    //       items:  colorsList.map<DropdownMenuItem<String>>((String value) {
    //         return DropdownMenuItem<String>(
    //           value: stringreplace(
    //               string: value, searchElement: "_", replacementElement: " "),
    //           child: Text(
    //             stringreplace(
    //                 string: value, searchElement: "_", replacementElement: " "),
    //           ),
    //         );
    //       }).toList(),
    //       onChanged: (String? value) {
    //         setState(() {
    //           colourController = value!;
    //         });
    //       },
    //     ),
    //   ),
    // );
  }

  AppBar myAppBar() {
    return AppBar(
      title: const Text("Add Rat Info"),
    );
  }

  showError(String errorVal) {
    scaffoldKey.currentState!.showSnackBar(SnackBar(
      content: Text("$errorVal not set!"),
      duration: const Duration(seconds: 5),
      backgroundColor: primaryThemeColor,
    ));
  }

  Widget showListButton(
      {required String title,
      required String listOf,
      required List buildList,
      required List activeList}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(60),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: secondaryThemeColor))),
      onPressed: () {
        showList(
          title: title,
          buildList: buildList,
          activeList: activeList,
        );
      },
      child: Text(
        listOf,
        style: const TextStyle(color: Colors.black87),
      ),
    );
  }

  Future<dynamic> showList(
      {required String title,
      required List buildList,
      required List activeList}) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(title),
            content: SizedBox(
              height: 400,
              width: MediaQuery.of(context).size.width / 1.2,
              child: ListView.builder(
                itemCount: buildList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(7),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        title: Text(buildList[index]),
                        trailing: SizedBox(
                          height: 10,
                          width: 10,
                          child: activeList.contains(buildList[index])
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                              : Container(),
                        ),
                        onTap: () {
                          if (activeList.contains(buildList[index])) {
                            log("removed ${buildList[index]}");
                            activeList.remove(buildList[index]);
                            setState(() {});
                          } else {
                            setState(() {
                              log("added ${buildList[index]}");
                              activeList.add(buildList[index]);
                            });
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class MyInputText extends StatelessWidget {
  const MyInputText({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validatorMessage,
  });

  final TextEditingController controller;
  final String hintText;
  final String validatorMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
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
