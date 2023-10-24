// ignore_for_file: no_logic_in_create_state

// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';
import 'package:pocket_puppy_rattery/Views/add_rat.dart';
import '../Models/rat.dart';
import '../Services/custom_widgets.dart';

class RatInfo extends StatefulWidget {
  const RatInfo({
    super.key,
    required this.rat,
    required this.rats,
  });

  final Rat rat;
  final List<QueryDocumentSnapshot<Object?>> rats;

  @override
  State<RatInfo> createState() => _RatInfoState();
}

class _RatInfoState extends State<RatInfo> {
  _RatInfoState();

  late Rat rat;

  // Age to be displayed, dynamically calculated by ageCalculator
  String age = '';

  List<String> ageView = ["Years", "Months", "Weeks", "Days", "Default"];
  String? _dropDownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: myAppBar(), body: myBody());
  }

  Widget myBody() {
    rat = widget.rat;
    if (_dropDownValue == null) {
      age = defaultAgeCalculator(rat.birthday);
    }
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          details(),
          ageContainer(),
          parents(),
          coat(),
          makrings(),
          colors(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 40,
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            AddRat(
                          id: rat.id,
                          rat: rat,
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          final tween = Tween(begin: begin, end: end);
                          final offsetAnimation = animation.drive(tween);
                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  style: MyElevatedButtonStyle.buttonStyle,
                  child: const Text("Edit"),
                ),
              ),
              SizedBox(
                height: 40,
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const RatGallery(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          final tween = Tween(begin: begin, end: end);
                          final offsetAnimation = animation.drive(tween);
                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  style: MyElevatedButtonStyle.buttonStyle,
                  child: const Text("Images"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Row colors() {
    return Row(
      children: [
        Expanded(
          child: MyInfoCard(
            title: "Colours",
            child: SizedBox(
              height: listContainerHeight(itemLenght: rat.colours.length),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rat.colours.length,
                itemBuilder: (context, index) {
                  return Text("- ${rat.colours[index]}");
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row makrings() {
    return Row(
      children: [
        Expanded(
          child: MyInfoCard(
            title: "Markings",
            child: SizedBox(
              height: listContainerHeight(itemLenght: rat.markings.length),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rat.markings.length,
                itemBuilder: (context, index) {
                  return Text("- ${rat.markings[index]}");
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row parents() {
    dynamic mom = rat.customParents
        ? rat.parents.mom
        : List.from(widget.rats
            .where((element) => element.id == rat.parents.mom))[0]['name'];
    dynamic dad = rat.customParents
        ? rat.parents.dad
        : List.from(widget.rats
            .where((element) => element.id == rat.parents.dad))[0]['name'];
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
                    child: Text(mom),
                  ),
                ),
                Expanded(
                  child: MyInfoCard(
                    title: "Father",
                    child: Text(dad),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Row coat() {
    return Row(
      children: [
        Expanded(
          child: MyInfoCard(
            title: "Coat",
            child: Text("Coat: ${rat.coat.name}"),
          ),
        ),
        Expanded(
            child: MyInfoCard(
                title: "Ears", child: Text("Ears: ${rat.ears.name}")))
      ],
    );
  }

  Row ageContainer() {
    return Row(
      children: [
        Expanded(
          child: MyInfoCard(
            title: "Age",
            child: Column(
              children: [
                Text("Birthday: ${birthdayView(data: rat.birthday)}"),
                Text('Age: $age'),
                const SizedBox(height: 10),
                ageViewSelector(rat.birthday)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row details() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: MyInfoCard(
            title: "Details",
            child: Column(
              children: [
                Text("Name: ${rat.name}"),
                Text("Registered Name: ${rat.registeredName}"),
                Text("Gender: ${rat.gender.name}"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  ageViewSelector(DateTime birthdate) {
    return Card(
      elevation: 3,
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
        title: Text("Rat: ${widget.rat.name}"),
      );
}
