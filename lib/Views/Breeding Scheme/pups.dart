import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';
import 'package:pocket_puppy_rattery/Models/breeding_scheme_model.dart';
import 'package:pocket_puppy_rattery/Services/custom_widgets.dart';
import 'package:pocket_puppy_rattery/Views/Breeding%20Scheme/add_pup.dart';

class Pups extends StatefulWidget {
  const Pups({super.key, required this.scheme});

  final BreedingSchemeModel scheme;

  @override
  State<Pups> createState() => _PupsState();
}

class _PupsState extends State<Pups> {
  late final BreedingSchemeModel scheme;
  DateTime? date = DateTime.now();
  int numberOfPups = 0;

  @override
  void initState() {
    scheme = widget.scheme;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Pups"),
        ),
        body: (scheme.dateOfLabour == null) ? addLabour() : body());
  }

  Widget body() {
    final DateTime dateOfLabour = scheme.dateOfLabour.toDate();

    return Center(
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Text(
                    "All Pups",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  MyInfoCard(
                    title: "Labour Details",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            const DirectiveText(text: "Date:"),
                            Text(
                                "${dateOfLabour.year}/${dateOfLabour.month}/${dateOfLabour.day}"),
                          ],
                        ),
                        Row(
                          children: [
                            const DirectiveText(text: "Litter Size:"),
                            Text(scheme.numberOfPups.toString())
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  scheme.pups.isEmpty
                      ? const Text("No Pups")
                      : SizedBox(
                          height: 400,
                          child: ListView.builder(
                            itemCount: scheme.pups.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 5,
                                shape: const RoundedRectangleBorder(),
                                child: ListTile(
                                  title: Text(scheme.pups[index]["name"]),
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                height: 40,
                width: 150,
                child: ElevatedButton(
                  style: MyElevatedButtonStyle.buttonStyle,
                  onPressed: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            AddPup(scheme: scheme),
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
                  child: const Text("Add Pup"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget addLabour() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "Add labour Info",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            children: [
              const DirectiveText(
                  text: "Date of Labour(Defaults to current date):"),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        height: 40,
                        child: ElevatedButton(
                          style: MyElevatedButtonStyle.buttonStyle,
                          onPressed: () async {
                            date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now());
                          },
                          child: const Text("Date"),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const DirectiveText(text: "Litter Size:"),
              const SizedBox(height: 5),
              NumberPicker(
                minValue: 0,
                maxValue: 20,
                value: numberOfPups,
                axis: Axis.horizontal,
                onChanged: (value) {
                  numberOfPups = value;
                  setState(() {});
                },
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              height: 40,
              width: 150,
              child: ElevatedButton(
                  onPressed: () {
                    scheme.dateOfLabour = date;
                    scheme.numberOfPups = numberOfPups;
                    scheme.pups.clear();

                    FirebaseSchemes.doc(scheme.id).update({
                      "pups": FieldValue.arrayRemove(["notSet"]),
                      "dateOfLabour": date,
                      "numberOfPups": numberOfPups
                    });
                    setState(() {});
                  },
                  style: MyElevatedButtonStyle.buttonStyle,
                  child: const Text("Done")),
            ),
          )
        ],
      ),
    );
  }
}
