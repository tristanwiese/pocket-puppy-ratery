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
                      "Name: ${info!["name"] ?? "name" }",
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Text("Registered Name: ${info["registeredName"]}"),
                    const SizedBox(height: 10),
                    Text("Color: ${stringreplace(string: info["colours"].toString(), searchElement: ["[", "]"], replacementElement: "")}"),
                    const SizedBox(height: 10),
                    Text("Coat: ${info["coat"]}"),
                    const SizedBox(height: 10),
                    Text("Markings: ${stringreplace(string: info["markings"].toString(), searchElement: ["[", "]"], replacementElement: "")}"),
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
                    const SizedBox(
                      height: 10
                    ),
                    Text("Age: ${ageCalculator(info["birthday"][0], info["birthday"][1])}"),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        navPush(context, AddRat(
                          coat: info["coat"],
                          color: info["colours"],
                          ears: info["ears"],
                          father: info["father"],
                          mother: info["mother"],
                          name: info["name"],
                          regName: info["registeredName"],
                          markings: info["markings"],
                          gender: info["gender"],
                          birthday: DateTime(info["birthday"][0],info["birthday"][1],info["birthday"][2]),
                          id: widget.info.id,
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(80, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                        )
                      ),
                      child: const Text("Edit"),
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
