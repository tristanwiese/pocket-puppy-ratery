// ignore_for_file: no_logic_in_create_state

// ignore: unused_import
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
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
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyInfoCard(
                  title: "Details",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Name: ${info["name"]}"),
                      Text("Regestered Name: ${info["registeredName"]}"),
                      Text("Gender: ${info["gender"]}"),
                    ],
                  ),
                ),
                MyInfoCard(
                  title: "Age",
                  child: Column(
                    children: [
                      Text('Age: $age'),
                      const SizedBox(height: 10),
                      ageViewSelector(birthdate)
                    ],
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyInfoCard(
                  title: "Markings",
                  child: SizedBox(
                    height: 100,
                    width: 200,
                    child: ListView.builder(

                      itemCount: info["markings"].length,
                      itemBuilder: (context, index) {
                        return Text("- ${info["markings"][index]}");
                      },
                    ),
                  ),
                ),
                MyInfoCard(title: "Colours", 
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: ListView.builder(
                    itemCount: info["colours"].length,
                    itemBuilder: (context, index) {
                      return Text("- ${info["colours"][index]}");
                    },
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 40,
              width: 100,
              child: ElevatedButton(
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
                      birthday: DateTime(info["birthday"][0], info["birthday"][1],
                          info["birthday"][2]),
                      id: widget.info.id,
                      colorCode: info["colorCode"]));
                      },
                      style: MyElevatedButtonStyle.buttonStyle,
                      child: const Text("Edit"),
                    ),
            ),
          ],
        );
      },
    );
  }

  Row editRow(
      BuildContext context, Map<String, dynamic> info, DateTime birthdate) {
    return Row(
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
                    birthday: DateTime(info["birthday"][0], info["birthday"][1],
                        info["birthday"][2]),
                    id: widget.info.id,
                    colorCode: info["colorCode"]));
          },
          style: ElevatedButton.styleFrom(
              fixedSize: const Size(80, 40),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15))),
          child: const Text("Edit"),
        ),
      ],
    );
  }

  ageViewSelector(DateTime birthdate) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: secondaryThemeColor)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:8.0),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
          hint: const Text("View Age"),
          items: ageView.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
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
      ),
    );
  }

  AppBar myAppBar() => AppBar(
        title: Text("Rat: ${widget.info["name"]}"),
      );
}

class MyInfoCard extends StatelessWidget {
  const MyInfoCard({super.key, required this.child, required this.title});

  final Widget child;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      semanticContainer: false,
      shape: RoundedRectangleBorder(
          side: BorderSide(
            color: secondaryThemeColor,
            width: 1.4,
          ),
          borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            child
          ],
        ),
      ),
    );
  }
}
