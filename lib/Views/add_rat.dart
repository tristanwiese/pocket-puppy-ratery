

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Functions/nav.dart';
import '../Functions/utils.dart';

const List<Text> markings = <Text>[
  Text('C-Locus'), Text('H-Locus')
];

final List<bool> selectedMarkings = <bool>[true, false];

var markingList = ['hello', 'c2'];


class AddRat extends StatefulWidget {
  const AddRat({super.key});

  @override
  State<AddRat> createState() => _AddRatState();
}

class _AddRatState extends State<AddRat> {
  //TextEditControllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController registeredNameController =
      TextEditingController();
  final TextEditingController colourController = TextEditingController();
  final TextEditingController earController = TextEditingController();
  final TextEditingController coatController = TextEditingController();
  final TextEditingController momController = TextEditingController();
  final TextEditingController dadController = TextEditingController();
  final TextEditingController markingsController = TextEditingController();

  String genderValue = 'Male';
  String markingValue = 'hello';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                      hintText: 'Praent: Father',
                      validatorMessage: 'Parent Required'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ToggleButtons(
                        onPressed: (index) {
                         for (var i = 0; i < 2; i++){
                           setState(() {
                             selectedMarkings[i] = false;
                           });
                         }
                         setState(() {
                           selectedMarkings[index] = !selectedMarkings[index];
                         });
                         if (index == 0){
                          setState(() {
                            markingList = ['hello', 'c2'];
                            markingValue = 'hello';
                          });
                         }else{
                          setState(() {
                            markingList = ['h1', 'h2'];
                            markingValue = 'h1';
                          });
                         }
                        },
                        isSelected: selectedMarkings,
                        direction: Axis.horizontal,
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        selectedBorderColor: Colors.black,
                        selectedColor: Colors.white,
                        fillColor: secondaryThemeColor,
                        color: secondaryThemeColor,
                        constraints:
                            const BoxConstraints(minHeight: 40.0, minWidth: 80),
                        children: markings,
                      ),
                      const SizedBox(width: 20,),
                      DropdownButton<String>(
                          hint: const Text('Gender'),
                          value: markingValue,
                          items: markingList
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
                              markingValue = value!;
                            });
                          },
                        ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      children: [
                        const Text('Gender: '),
                        const SizedBox(height: 10),
                        DropdownButton<String>(
                          hint: const Text('Gender'),
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
                              genderValue = value!;
                            });
                          },
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );
                            },
                            child: const Text('Brithday'))
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
                              return Center(child: CircularProgressIndicator());
                            },
                          );
                          await FirebaseFirestore.instance
                              .collection('rats')
                              .doc(nameController.text)
                              .set({'name': nameController.text});
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
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
