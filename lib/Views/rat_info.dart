// ignore_for_file: no_logic_in_create_state

// ignore: unused_import
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Functions/nav.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';
import 'package:pocket_puppy_rattery/Views/add_rat.dart';

class RatInfo extends StatefulWidget {
  const RatInfo({
    super.key,
    required this.info,
  });

  final QueryDocumentSnapshot info;

  @override
  State<RatInfo> createState() => _RatInfoState(info: info);
}

class _RatInfoState extends State<RatInfo> {
  _RatInfoState({required this.info});

  final dynamic info;

  // Age to be displayed, dynamically calculated by ageCalculator
  String age = '';

  List<String> ageView = ["Years", "Months", "Weeks", "Days", "Default"];
  String? _dropDownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: myAppBar(), body: myBody());
  }

  Widget myBody() {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection("rats")
          .doc(widget.info.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text(
              "Catching ${widget.info["name"]}....",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          );
        }
        if (!snapshot.hasData) {
          return Center(
            child: Text(
                'Sorry, something went wrong while fetching ${widget.info["name"]}!'),
          );
        }
        final info = snapshot.data!.data();
        DateTime birthdate = DateTime(
            info!["birthday"][0], info["birthday"][1], info["birthday"][2]);
        if (_dropDownValue == null) {
          age = defaultAgeCalculator(birthdate);
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20),
                    color: secondaryThemeColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Name: ${info["name"] ?? "name"}",
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Text("Registered Name: ${info["registeredName"]}"),
                    const SizedBox(height: 10),
                    Text(
                        "Color: ${stringReplace(string: info["colours"].toString(), searchElement: [
                              "[",
                              "]"
                            ], replacementElement: "")}"),
                    const SizedBox(height: 10),
                    Text("Coat: ${info["coat"]}"),
                    const SizedBox(height: 10),
                    Text(
                        "Markings: ${stringReplace(string: info["markings"].toString(), searchElement: [
                              "[",
                              "]"
                            ], replacementElement: "")}",
                            textAlign: TextAlign.center,
                            ),
                    const SizedBox(height: 10),
                    Text("Ears: ${info["ears"]}"),
                    const SizedBox(height: 10),
                    Text("Gender: ${info["gender"]}"),
                    const SizedBox(height: 10),
                    Text(
                        "Birthday: ${info["birthday"][0]}/${info["birthday"][1]}/${info["birthday"][2]}"),
                    const SizedBox(height: 10),
                    Text("Mother: ${info["mother"]}"),
                    const SizedBox(height: 10),
                    Text("Father: ${info["father"]}"),
                    const SizedBox(height: 10),
                    Text("Age: $age"),
                    (_dropDownValue == "Days") ? 
                    const Text("This number in a rough estimate and does not consider leap years or other factors that could effect the result!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 10,
                    ),
                    ) :
                    Container(),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            navPush(
                                context,
                                AddRat(
                                  coat: info["coat"],
                                  color: info["colours"],
                                  ears: info["ears"],
                                  father: info["father"],
                                  mother: info["mother"],
                                  name: info["name"],
                                  regName: info["registeredName"],
                                  markings: info["markings"],
                                  gender: info["gender"],
                                  birthday: DateTime(info["birthday"][0],
                                      info["birthday"][1], info["birthday"][2]),
                                  id: widget.info.id,
                                ));
                          },
                          style: ElevatedButton.styleFrom(
                              fixedSize: const Size(80, 40),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          child: const Text("Edit"),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          height: 40,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(15)
                          ),
                          child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                            hint: const Text("View Age"),
                            items: ageView
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                  value: value, child: Text(value));
                            }).toList(),
                            value: _dropDownValue,
                            onChanged: (value) {
                              log(value!);
                              _dropDownValue = value;
                              switch (value) {
                                case "Days":
                                  age = "${ageCalculatorDay(birthdate)} days";
                                  break;
                                case "Weeks":
                                  age = "${ageCalculatorWeek(birthdate)} weeks";
                                  break;
                                case "Months":
                                  age = "${ageCalculatorMonth(birthdate)} months";
                                  break;
                                case "Years":
                                  age = "${ageCalculatorYear(birthdate)} years";
                                  break;
                                case "Default":
                                  age = "${defaultAgeCalculator(birthdate)}";
                              }
                              setState(() {
                                log(age);
                              });
                            },
                          )),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox()
            ],
          ),
        );
      },
    );
  }

  AppBar myAppBar() => AppBar(
        title: Text("Rat: ${widget.info["name"]}"),
      );
}
