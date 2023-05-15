// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Functions/nav.dart';
import '../Functions/utils.dart';
import '../Models/rat.dart';

const List<Text> toggleValues = <Text>[Text('C-Locus'), Text('H-Locus')];

List<bool> selectedMarkings = <bool>[true, false];

List<String> cMarkingList = Rat.cLocusToList();
List<String> hMarkingsList = Rat.hLocusToList();
List<String> colorsList = Rat.colorsToList();
List<String> earsList = Rat.earsToList();
List<String> coatsList = Rat.coatsToList();
List<String> genderList = Rat.genderToList();

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
  TextEditingController momController = TextEditingController();
  TextEditingController dadController = TextEditingController();
  TextEditingController registeredNameController = TextEditingController();

  //dropdown list values
  String? colourController;
  String? earController;
  String? coatController;
  String? genderValue;
  String? markingValue;

  Gender? _pickedGender;

  List<String> markingList = cMarkingList;

  DateTime? _pickedDate;
  DateTime _selectedDate = DateTime.now();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    print(colorsList);
    super.initState();
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
                          hintText: 'Regestered Name',
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
                          Expanded(child: ColorSelect()),
                          const SizedBox(width: 10),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: EarSelect()),
                          const SizedBox(width: 10),
                          Expanded(child: GenderSelect()),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LocusSelect(),
                        ],
                      ),
                      const SizedBox(height: 10),
                      LocusDropDown(),
                      const SizedBox(
                        height: 10,
                      ),
                      BirthdaySelect(context),
                      const SizedBox(height: 10),
                      SaveButton(context),
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
      ),
    );
  }

  Center SaveButton(BuildContext context) {
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
            if (markingValue == null) {
              showError("Markings");
              navPop(context);
              return;
            }
            final Rat rat = Rat(
              name: nameController.text.trim(),
              registeredName: registeredNameController.text.trim(),
              colours: Colours.values[colorsList
                  .indexWhere((element) => element == colourController)],
              ears: Ears.values[
                  earsList.indexWhere((element) => element == earController)],
              gender: _pickedGender!,
              markings: markingValue!,
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
                  .doc(widget.name)
                  .update(rat.toDb());
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
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              minimumSize: const Size(100, 50),
              backgroundColor: secondaryThemeColor),
          child: const Text('Save')),
    );
  }

  Container BirthdaySelect(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
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
    );
  }

  Container GenderSelect() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: secondaryThemeColor, width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: const Center(
              child: Text(
            'Gender',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
          )),
          value: genderValue,
          items: <String>['Male', 'Female']
              .map<DropdownMenuItem<String>>((String value) {
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
                _pickedGender = Gender.Male;
              } else {
                _pickedGender = Gender.Female;
              }
            });
          },
        ),
      ),
    );
  }

  Container LocusDropDown() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: secondaryThemeColor, width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: const Center(
              child: Text('Locus',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15))),
          value: markingValue,
          items: markingList.map<DropdownMenuItem<String>>((String value) {
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
    );
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
          markingValue = null;
        } else {
          markingList = hMarkingsList;
          markingValue = null;
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
      constraints: BoxConstraints(minHeight: 40.0, minWidth: 100),
      children: toggleValues,
    );
  }

  Container CoatSelect() {
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
              child: Text(
                value,
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

  Container EarSelect() {
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
              child: Text(
                value,
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

  Container ColorSelect() {
    return Container(
      width: 50,
      decoration: BoxDecoration(
          border: Border.all(color: secondaryThemeColor, width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: const Center(
              child: Text('Colors',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15))),
          value: colourController,
          items: colorsList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
              ),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              colourController = value!;
            });
          },
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
