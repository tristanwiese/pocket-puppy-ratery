// ignore_for_file: no_logic_in_create_state

// ignore: unused_import
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Functions/nav.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';
import 'package:pocket_puppy_rattery/Services/constants.dart';
import 'package:pocket_puppy_rattery/Views/add_rat.dart';

import '../Models/rat.dart';

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
        final ratInfo = infoToModel(info: info!);

        if (_dropDownValue == null) {
          age = defaultAgeCalculator(ratInfo.birthday);
        }
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              details(ratInfo),
              ageContainer(ratInfo),
              parents(ratInfo),
              coat(ratInfo),
              makrings(ratInfo),
              colors(ratInfo),
              SizedBox(
                height: 40,
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    navPush(
                        context,
                        AddRat(
                          id: widget.info.id,
                          rat: ratInfo,
                        ));
                  },
                  style: MyElevatedButtonStyle.buttonStyle,
                  child: const Text("Edit"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Row colors(Rat ratInfo) {
    return Row(
      children: [
        Expanded(
          child: MyInfoCard(
            title: "Colours",
            child: SizedBox(
              height: listContainerHeight(itemLenght: ratInfo.colours.length),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ratInfo.colours.length,
                itemBuilder: (context, index) {
                  return Text("- ${ratInfo.colours[index]}");
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row makrings(Rat ratInfo) {
    return Row(
      children: [
        Expanded(
          child: MyInfoCard(
            title: "Markings",
            child: SizedBox(
              height: listContainerHeight(itemLenght: ratInfo.markings.length),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: ratInfo.markings.length,
                itemBuilder: (context, index) {
                  return Text("- ${ratInfo.markings[index]}");
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row parents(Rat ratInfo) {
    return Row(
      children: [
        Expanded(
          child: MyInfoCard(
            title: "Parents",
            child: Row(
              children: [
                Expanded(
                  child: MyInfoCard(
                    title: "Mother",
                    child: Text(ratInfo.parents.mom),
                  ),
                ),
                Expanded(
                  child: MyInfoCard(
                    title: "Father",
                    child: Text(ratInfo.parents.dad),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Row coat(Rat ratInfo) {
    return Row(
      children: [
        Expanded(
          child: MyInfoCard(
            title: "Coat",
            child: Text("Coat: ${ratInfo.coat.name}"),
          ),
        ),
        Expanded(
            child: MyInfoCard(
                title: "Ears", child: Text("Ears: ${ratInfo.ears.name}")))
      ],
    );
  }

  Row ageContainer(Rat ratInfo) {
    return Row(
      children: [
        Expanded(
          child: MyInfoCard(
            title: "Age",
            child: Column(
              children: [
                Text("Birthday: ${birthdayView(data: ratInfo.birthday)}"),
                Text('Age: $age'),
                const SizedBox(height: 10),
                ageViewSelector(ratInfo.birthday)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row details(Rat ratInfo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: MyInfoCard(
            title: "Details",
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: ${ratInfo.name}"),
                Text("Regestered Name: ${ratInfo.registeredName}"),
                Text("Gender: ${ratInfo.gender.name}"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  ageViewSelector(DateTime birthdate) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: secondaryThemeColor)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
          hint: const Text("View Age"),
          items: ageView.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          value: _dropDownValue,
          onChanged: (value) {
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
            setState(() {});
          },
        )),
      ),
    );
  }

  AppBar myAppBar() => AppBar(
        title: Text("Rat: ${widget.info["name"]}"),
      );

  double listContainerHeight({required itemLenght}) {
    //Compensate for title size
    const int headerSize = 5;

    //Size to give for each item in list
    const sizePerLine = 20;

    return (headerSize + itemLenght * sizePerLine).toDouble();
  }

  String birthdayView({required DateTime data}) {
    return "${data.year}/${data.month}/${data.day}";
  }

  Rat infoToModel({required info}) {
    DateTime birthday =
        DateTime(info["birthday"][0], info["birthday"][1], info["birthday"][2]);

    final rat = Rat(
      name: info["name"],
      registeredName: info["registeredName"],
      colours: info["colours"],
      ears: Ears.values[
          Rat.earsToList().indexWhere((element) => element == info["ears"])],
      gender: Gender.values[Rat.genderToList()
          .indexWhere((element) => element == info["gender"])],
      markings: info["markings"],
      parents: Parents(dad: info["father"], mom: info["mother"]),
      coat: Coats.values[
          Rat.coatsToList().indexWhere((element) => element == info["coat"])],
      birthday: birthday,
    );
    rat.colorCode = info["colorCode"];

    return rat;
  }
}

class MyInfoCard extends StatelessWidget {
  const MyInfoCard({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
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
