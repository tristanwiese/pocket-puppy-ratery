import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:pocket_puppy_rattery/Functions/nav.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';
import 'package:pocket_puppy_rattery/Models/breeding_scheme_model.dart';
import 'package:pocket_puppy_rattery/Models/pup_model.dart';
import 'package:pocket_puppy_rattery/Services/breeding_scheme_provider.dart';
import 'package:pocket_puppy_rattery/Services/custom_widgets.dart';
import 'package:pocket_puppy_rattery/Views/Breeding%20Scheme/add_pup.dart';
import 'package:provider/provider.dart';

class Pups extends StatefulWidget {
  const Pups({
    super.key,
  });

  @override
  State<Pups> createState() => _PupsState();
}

class _PupsState extends State<Pups> {
  late BreedingSchemeModel scheme;
  late List pups;
  DateTime? date = DateTime.now();
  int numberOfPups = 0;
  late BreedingSchemeProvider provider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BreedingSchemeProvider>(builder: (context, value, child) {
      scheme = value.getScheme;
      pups = scheme.pups;
      provider = Provider.of<BreedingSchemeProvider>(context);
      return Scaffold(
          appBar: AppBar(
            title: const Text("Pups"),
          ),
          body: (scheme.dateOfLabour == null) ? addLabour() : body());
    });
  }

  Widget body() {
    final DateTime dateOfLabour = scheme.dateOfLabour!.toDate();
    return Center(
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "All Pups",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
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
                  scheme.numberOfPups! != pups.length
                      ? scheme.numberOfPups! > pups.length
                          ? DirectiveText(
                              text:
                                  "Litter Size is ${scheme.numberOfPups}, but only ${pups.length} pups were added:",
                              italic: true,
                            )
                          : DirectiveText(
                              text:
                                  "Litter Size is ${scheme.numberOfPups}, but ${pups.length} pups were added:",
                              italic: true,
                            )
                      : Container(),
                  pups.isEmpty
                      ? const Text("No Pups")
                      : SizedBox(
                          height: 400,
                          child: ListView.builder(
                            itemCount: pups.length,
                            itemBuilder: (context, index) {
                              final Pup pup = Pup.fromDb(dbPup: pups[index]);
                              return Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: ListTile(
                                  trailing: IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text("Delete ${pup.name}"),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () =>
                                                    navPop(context),
                                                style: MyElevatedButtonStyle
                                                    .cancelButtonStyle,
                                                child: const Text("Cancel"),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  FirebaseSchemes.doc(scheme.id)
                                                      .update({
                                                    "pups":
                                                        FieldValue.arrayRemove(
                                                            [pups[index]])
                                                  });
                                                  provider.editPups(
                                                      action: "remove",
                                                      index: index);
                                                  navPop(context);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.red[200]),
                                                child: const Text("Delete"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: const DeleteIcon(),
                                  ),
                                  leading: Text("${index + 1}",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  title: Row(
                                    children: [
                                      const DirectiveText(text: "Name:"),
                                      Text(pup.name),
                                    ],
                                  ),
                                  subtitle: Row(
                                    children: [
                                      const DirectiveText(
                                          text: "Registered name:"),
                                      Text(pup.name)
                                    ],
                                  ),
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
                    scheme.dateOfLabour = Timestamp.fromDate(date!);
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
