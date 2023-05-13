// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Functions/nav.dart';
import '../Functions/utils.dart';
import '../Models/rat.dart';

const List<Text> markings = <Text>[Text('C-Locus'), Text('H-Locus')];

List<bool> selectedMarkings = <bool>[true, false];

var markingList = ['C1', 'C2'];

class AddRat extends StatefulWidget {
  const AddRat(
      {super.key,
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
  final String? color;
  final String? ears;
  final String? coat;
  final String? mother;
  final String? father;
  final String? gender;
  final DateTime? birthday;
  final String? markings;

  @override
  State<AddRat> createState() => _AddRatState();
}

class _AddRatState extends State<AddRat> {
  //TextEditControllers
  TextEditingController nameController = TextEditingController();
  TextEditingController registeredNameController = TextEditingController();
  TextEditingController colourController = TextEditingController();
  TextEditingController earController = TextEditingController();
  TextEditingController coatController = TextEditingController();
  TextEditingController momController = TextEditingController();
  TextEditingController dadController = TextEditingController();

  String? genderValue;
  Gender? _pickedGender;

  String? markingValue;

  DateTime? _pickedDate;
  DateTime _selectedDate = DateTime.now();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.name != null) {
      editRat();
    }
    super.initState();
  }

  editRat() {
    nameController = TextEditingController(text: widget.name);
    registeredNameController = TextEditingController(text: widget.regName);
    colourController = TextEditingController(text: widget.color);
    earController = TextEditingController(text: widget.ears);
    coatController = TextEditingController(text: widget.coat);
    momController = TextEditingController(text: widget.mother);
    dadController = TextEditingController(text: widget.father);
    markingValue = widget.markings;
    _pickedDate = widget.birthday;
    _selectedDate = widget.birthday!;
    if (widget.markings!.contains("H")) {
      setState(() {
        markingList = ['H1', 'H2'];
        selectedMarkings = <bool>[false, true];
      });
    }else{
      setState(() {
        markingList = ['C1', 'C2'];
        selectedMarkings = <bool>[true, false];
      });
    }
    if (widget.gender == "male"){
      genderValue = "Male";
      _pickedGender = Gender.male;
    }else{
      genderValue = "Female";
      _pickedGender = Gender.female;
    }
    log(markingValue.toString());
    log(markingList.toString());
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyInputText(
                        controller: nameController,
                        hintText: 'Name',
                        validatorMessage: 'Name required'),
                    MyInputText(
                        controller: registeredNameController,
                        hintText: 'Regestered Name',
                        validatorMessage: 'Regestered Name Required'),
                    MyInputText(
                        controller: coatController,
                        hintText: 'Coat',
                        validatorMessage: 'Coat Required'),
                    MyInputText(
                        controller: colourController,
                        hintText: 'Colour',
                        validatorMessage: 'Colour Required'),
                    MyInputText(
                        controller: earController,
                        hintText: 'Ears',
                        validatorMessage: 'Ears Required'),
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
                        ToggleButtons(
                          onPressed: (index) {
                            for (var i = 0; i < 2; i++) {
                              setState(() {
                                selectedMarkings[i] = false;
                              });
                            }
                            selectedMarkings[index] = !selectedMarkings[index];
                            if (index == 0) {
                              markingList = ['C1', 'C2'];
                              markingValue = null;
                            } else {
                              markingList = ['H1', 'H2'];
                              markingValue = null;
                            }
                            setState(() {});
                          },
                          isSelected: selectedMarkings,
                          direction: Axis.horizontal,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          selectedBorderColor: Colors.black,
                          selectedColor: Colors.white,
                          fillColor: secondaryThemeColor,
                          color: secondaryThemeColor,
                          constraints: const BoxConstraints(
                              minHeight: 40.0, minWidth: 80),
                          children: markings,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: secondaryThemeColor, width: 2),
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: const Text('Locus'),
                              value: markingValue,
                              items: markingList.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  markingValue = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Gender: '),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: secondaryThemeColor, width: 2),
                                borderRadius: BorderRadius.circular(10)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                hint: const Text('Gender'),
                                value: genderValue,
                                items: <String>[
                                  'Male',
                                  'Female'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    genderValue = value;
                                    if (value! == "Male") {
                                      _pickedGender = Gender.male;
                                    } else {
                                      _pickedGender = Gender.female;
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              _pickedDate = await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );
                              if (_pickedDate != null &&
                                  _pickedDate != _selectedDate) {
                                setState(() {
                                  _selectedDate = _pickedDate!;
                                });
                                log(_selectedDate.toString());
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: secondaryThemeColor,
                              fixedSize: const Size(100, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Brithday'),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              },
                            );
                            if (_pickedGender == null) {
                              showError("Gender");
                              navPop(context);
                              return;
                            }
                            if (markingValue == null) {
                              showError("Markings");
                              navPop(context);
                              return;
                            }
                            final Rat rat = Rat(
                              name: nameController.text.trim(),
                              registeredName:
                                  registeredNameController.text.trim(),
                              colours: colourController.text.trim(),
                              ears: earController.text.trim(),
                              gender: _pickedGender!,
                              markings: markingValue!,
                              parents: Parents(
                                  dad: dadController.text.trim(),
                                  mom: momController.text.trim()),
                              coat: coatController.text.trim(),
                              birthday: _selectedDate,
                            );
                            if (widget.name != null){
                              await FirebaseFirestore.instance.collection("rats").doc(widget.name).update(rat.toDb());
                            }
                            await FirebaseFirestore.instance
                                .collection("rats")
                                .doc(nameController.text.trim())
                                .set(rat.toDb());
                            navPop(context);
                            navPop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              minimumSize: const Size(100, 50),
                              backgroundColor: secondaryThemeColor),
                          child: const Text('Save')),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar myAppBar() => AppBar(
        title: const Text("Add Rat Info"),
      );

  showError(String errorVal) {
    scaffoldKey.currentState!.showSnackBar(SnackBar(
      content: Text("$errorVal not set!"),
      duration: const Duration(seconds: 5),
      backgroundColor: primaryThemeColor,
    ));
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
      margin: const EdgeInsets.all(10),
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
