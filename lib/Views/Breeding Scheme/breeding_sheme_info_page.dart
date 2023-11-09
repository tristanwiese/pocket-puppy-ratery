// ignore_for_file: use_build_context_synchronously
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:pocket_puppy_rattery/Functions/db.dart';
import 'package:pocket_puppy_rattery/Functions/nav.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';
import 'package:pocket_puppy_rattery/Models/breeding_scheme_model.dart';
import 'package:pocket_puppy_rattery/Models/pup_model.dart';
import 'package:pocket_puppy_rattery/Views/Breeding%20Scheme/pups.dart';
import 'package:pocket_puppy_rattery/providers/breeding_scheme_provider.dart';
import 'package:pocket_puppy_rattery/providers/pups_provider.dart';
import 'package:provider/provider.dart';

import '../../Services/custom_widgets.dart';
import 'breeding_scheme.dart';

class BreedingShcemeInfoPage extends StatefulWidget {
  const BreedingShcemeInfoPage({super.key, required this.rats});

  final List<QueryDocumentSnapshot<Object?>>? rats;

  @override
  State<BreedingShcemeInfoPage> createState() => _BreedingShcemeInfoPageState();
}

class _BreedingShcemeInfoPageState extends State<BreedingShcemeInfoPage> {
  late BreedingSchemeModel scheme;
  late BreedingSchemeProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<BreedingSchemeProvider>(context, listen: false);
    return Consumer<BreedingSchemeProvider>(
      builder: (context, value, child) {
        scheme = value.getScheme;
        return Scaffold(
          appBar: AppBar(
            title: Text(scheme.name),
          ),
          body: breedingSchemeInfoBody(),
        );
      },
    );
  }

  Widget breedingSchemeInfoBody() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Column(
            children: [
              dates(),
              parentDetails(),
              weightTracker(),
              schemeNotes(),
              pups()
            ],
          ),
          editButton()
        ],
      ),
    );
  }

  Row editButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: 150,
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              navPush(
                context,
                BreedingScheme(
                  schemeCount: 0,
                  rats: widget.rats!,
                  chosenRats: [scheme.male, scheme.female],
                  date: scheme.date,
                  isCustomRats: scheme.isCustomRats,
                  name: scheme.name,
                  id: scheme.id,
                ),
              );
            },
            style: MyElevatedButtonStyle.buttonStyle,
            child: const Text('Edit'),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: 150,
          height: 40,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const Pups(),
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
            child: const Text('Pups'),
          ),
        ),
      ],
    );
  }

  MyInfoCard schemeNotes() {
    return MyInfoCard(
      title: "Notes",
      child: Column(
        children: [
          scheme.notes.isNotEmpty
              ? SizedBox(
                  height:
                      scheme.notes.length > 10 ? 200 : scheme.notes.length * 20,
                  child: ListView.builder(
                    itemCount: scheme.notes.length,
                    itemBuilder: (context, index) => Text(
                        "- ${scheme.notes[index]["title"]}: ${scheme.notes[index]["note"]}"),
                  ),
                )
              : const Text("No notes"),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                label: const Text("Add Note"),
                onPressed: () {
                  addNote();
                },
                style: MyElevatedButtonStyle.buttonStyle,
                icon: const Icon(
                  Icons.add,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => StatefulBuilder(
                      builder: (context, setState) {
                        const Widget title = Text("Edit Notes");

                        final List<Widget> actions = [
                          ElevatedButton(
                            onPressed: () {
                              navPop(context);
                            },
                            style: MyElevatedButtonStyle.doneButtonStyle,
                            child: const Text("Done"),
                          ),
                        ];

                        final Widget content = SizedBox(
                          height: 300,
                          width: double.maxFinite,
                          child: ListView.builder(
                            itemCount: scheme.notes.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: ListTile(
                                  onTap: () => addNote(
                                      index: index,
                                      note: scheme.notes[index]["note"],
                                      noteTitle: scheme.notes[index]["title"]),
                                  title: Text(scheme.notes[index]['title']),
                                  trailing: IconButton(
                                      onPressed: () {
                                        FirebaseSchemes.doc(scheme.id).update({
                                          "notes": FieldValue.arrayRemove(
                                            [scheme.notes[index]],
                                          )
                                        });

                                        provider.editNotes(
                                            action: "remove", index: index);
                                        setState(
                                          () {},
                                        );
                                      },
                                      icon: const DeleteIcon()),
                                ),
                              );
                            },
                          ),
                        );

                        return SizedBox(
                          height: 400,
                          child: AlertDialog(
                            title: title,
                            actions: actions,
                            content: content,
                          ),
                        );
                      },
                    ),
                  );
                },
                label: const Text("Edit Notes"),
                icon: const Icon(Icons.edit),
                style: MyElevatedButtonStyle.buttonStyle,
              ),
            ],
          ),
        ],
      ),
    );
  }

  MyInfoCard pups() {
    return MyInfoCard(
      title: "Pups",
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('breedingSchemes')
              .doc(scheme.id)
              .collection('pups')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final pups = snapshot.data!.docs;
            if (pups.isEmpty) {
              Provider.of<PupsProvider>(context, listen: false)
                  .setPups(pups: []);
              return const Center(child: Text('No pups'));
            }
            final List<Pup> pupModels = [];
            // ignore: avoid_function_literals_in_foreach_calls
            pups.forEach((element) {
              createFieldPups(
                breedID: scheme.id,
                boolean: checkDBScheme(db: element.toString(), key: 'photos'),
                buildItem: element,
                data: [],
                key: 'photos',
              );
              pupModels.add(Pup.fromDb(dbPup: element));
            });
            Provider.of<PupsProvider>(context, listen: false)
                .setPups(pups: pupModels);
            return Column(
              children: [
                SizedBox(
                  height: listContainerHeight(
                    itemLenght: pups.length,
                    custoSizePerLine: 60,
                  ),
                  child: ListView.builder(
                    itemCount: pups.length,
                    itemBuilder: (context, index) {
                      final Pup pup = Pup.fromDb(dbPup: pups[index]);
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: secondaryThemeColor)),
                        child: ListTile(
                          title: Text(pup.name),
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          }),
    );
  }

  MyInfoCard weightTracker() {
    return MyInfoCard(
      title: "Weight Tracker",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          scheme.weightTracker.isNotEmpty
              ? SizedBox(
                  height: scheme.weightTracker.length > 10
                      ? 200
                      : scheme.weightTracker.length * 20,
                  child: ListView.builder(
                    itemCount: scheme.weightTracker.length,
                    itemBuilder: (context, index) {
                      return Text(
                          "- ${scheme.weightTracker[index]["date"][0]}/${scheme.weightTracker[index]["date"][1]}/${scheme.weightTracker[index]["date"][2]} : ${scheme.weightTracker[index]["weight"]}g");
                    },
                  ),
                )
              : const Text("No Weights Recorded"),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                label: const Text("Add Entry"),
                style: MyElevatedButtonStyle.buttonStyle,
                onPressed: () {
                  addWeightEntry();
                },
                icon: const Icon(Icons.add, color: Colors.green),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                label: const Text("Edit Entries"),
                style: MyElevatedButtonStyle.buttonStyle,
                onPressed: () {
                  editWeightEntries();
                },
                icon: const Icon(Icons.edit),
              )
            ],
          )
        ],
      ),
    );
  }

  MyInfoCard parentDetails() {
    dynamic male;
    dynamic female;
    if (!scheme.isCustomRats) {
      male =
          List.from(widget.rats!.where((element) => element.id == scheme.male));
      male = male[0].data()['name'];
      female = List.from(
          widget.rats!.where((element) => element.id == scheme.female));
      female = female[0].data()['name'];
    } else {
      male = scheme.male;
      female = scheme.female;
    }
    return MyInfoCard(
      title: "Parent Details",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("Male: $male"),
          Text("Female: $female"),
        ],
      ),
    );
  }

  MyInfoCard dates() {
    return MyInfoCard(
      title: "Dates",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Breeding: ${scheme.date.year}/${scheme.date.month}/${scheme.date.day}",
                ),
                Text(scheme.dateOfLabour != null
                    ? "Labour: ${scheme.dateOfLabour!.toDate().year}/${scheme.dateOfLabour!.toDate().month}/${scheme.dateOfLabour!.toDate().day}"
                    : "Labour: Not set"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> addNote(
      {String noteTitle = "", String note = "", int? index}) {
    return showDialog(
      context: context,
      builder: (context) {
        final TextEditingController titleController =
            TextEditingController(text: noteTitle);
        final TextEditingController noteController =
            TextEditingController(text: note);

        const Widget title = Text("Note");

        final List<Widget> actions = [
          ElevatedButton(
            onPressed: () {
              navPop(context);
            },
            style: MyElevatedButtonStyle.cancelButtonStyle,
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (note != '' || noteTitle != "") {
                FirebaseSchemes.doc(scheme.id).update({
                  "notes": FieldValue.arrayRemove([scheme.notes[index!]]),
                });
                provider.editNotes(action: "update", index: index, note: {
                  "title": titleController.text.trim(),
                  "note": noteController.text.trim()
                });
                FirebaseSchemes.doc(scheme.id).update({
                  "notes": FieldValue.arrayUnion([
                    {
                      "title": titleController.text.trim(),
                      "note": noteController.text.trim()
                    }
                  ]),
                });
                navPop(context);
                navPop(context);
                return;
              }
              provider.editNotes(action: "add", note: {
                "title": titleController.text.trim(),
                "note": noteController.text.trim()
              });
              FirebaseSchemes.doc(scheme.id).update({
                "notes": FieldValue.arrayUnion([
                  {
                    "title": titleController.text.trim(),
                    "note": noteController.text.trim()
                  }
                ]),
              });
              navPop(context);
              titleController.dispose();
              noteController.dispose();
            },
            style: MyElevatedButtonStyle.doneButtonStyle,
            child:
                Text((note != '' || noteTitle != "") ? "Update" : "Add Note"),
          ),
        ];

        final Widget content = SingleChildScrollView(
          child: SizedBox(
            height: 300,
            child: Column(
              children: [
                TextField(
                  textInputAction: TextInputAction.next,
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: "Title",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black45),
                      borderRadius: BorderRadius.circular(5)),
                  child: TextField(
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                        hintText: "Note",
                        border: InputBorder.none,
                        constraints: BoxConstraints.expand(height: 200)),
                    controller: noteController,
                    maxLines: null,
                  ),
                ),
              ],
            ),
          ),
        );

        return AlertDialog(
          title: title,
          actions: actions,
          content: content,
        );
      },
    );
  }

  void addWeightEntry({
    int weight = 300,
    DateTime? date,
    int? index,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        decreaseWeight() {
          if (weight > 100) {
            weight -= 100;
          } else {
            weight = 0;
          }
        }

        increaseWeight() {
          if (weight < 900) {
            weight += 100;
          } else {
            weight = 1000;
          }
        }

        return StatefulBuilder(
          builder: (context, setState) {
            date ??= DateTime.now();

            const title = Text("Add Weight Entry");

            final actions = [
              ElevatedButton(
                onPressed: () => navPop(context),
                style: MyElevatedButtonStyle.cancelButtonStyle,
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  final entry = {
                    "date": [date!.year, date!.month, date!.day],
                    "weight": weight
                  };
                  if (index != null) {
                    FirebaseSchemes.doc(scheme.id).update({
                      "weightTracker":
                          FieldValue.arrayRemove([scheme.weightTracker[index]]),
                    });
                    provider.editweights(
                        action: "update", index: index, weight: entry);
                    FirebaseSchemes.doc(scheme.id).update({
                      "weightTracker": FieldValue.arrayUnion([entry]),
                    });
                    navPop(context);
                    navPop(context);
                    return;
                  }
                  provider.editweights(action: "add", weight: entry);
                  FirebaseSchemes.doc(scheme.id).update({
                    "weightTracker": FieldValue.arrayUnion([entry])
                  });
                  navPop(context);
                },
                style: MyElevatedButtonStyle.doneButtonStyle,
                child: Text((index != null) ? "Update" : "Add"),
              ),
            ];

            final content = SizedBox(
              height: 240,
              child: Column(
                children: [
                  const DirectiveText(
                      text: "Select Date.\nDefaults to current date"),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                              onPressed: () async {
                                date = await showDatePicker(
                                  context: context,
                                  initialDate: date!,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime.now(),
                                );
                              },
                              style: MyElevatedButtonStyle.buttonStyle,
                              child: const Text("Date")),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const DirectiveText(text: "Select weight"),
                  NumberPicker(
                    axis: Axis.horizontal,
                    minValue: 0,
                    maxValue: 1000,
                    value: weight,
                    onChanged: (value) {
                      weight = value;
                      setState(
                        () {},
                      );
                    },
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Current Weight: $weight"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              decreaseWeight();
                              setState(
                                () {},
                              );
                            },
                            icon: const Icon(
                              (Icons.remove),
                            ),
                          ),
                          const Text("Increment: 100"),
                          IconButton(
                            onPressed: () {
                              increaseWeight();
                              setState(
                                () {},
                              );
                            },
                            icon: const Icon(
                              (Icons.add),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            );

            return AlertDialog(
              title: title,
              actions: actions,
              content: content,
            );
          },
        );
      },
    );
  }

  void editWeightEntries() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          const Widget title = Text("Edit Entries");

          final List<Widget> actions = [
            ElevatedButton(
              onPressed: () {
                navPop(context);
              },
              style: MyElevatedButtonStyle.doneButtonStyle,
              child: const Text("Done"),
            ),
          ];

          final Widget content = SizedBox(
            height: 300,
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: scheme.weightTracker.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    onTap: () => addWeightEntry(
                        date: DateTime(
                            scheme.weightTracker[index]["date"][0],
                            scheme.weightTracker[index]["date"][1],
                            scheme.weightTracker[index]["date"][2]),
                        weight: scheme.weightTracker[index]["weight"],
                        index: index),
                    title: Text(
                        "- ${scheme.weightTracker[index]["date"][0]}/${scheme.weightTracker[index]["date"][1]}/${scheme.weightTracker[index]["date"][2]} : ${scheme.weightTracker[index]["weight"]}g"),
                    trailing: IconButton(
                        onPressed: () {
                          FirebaseSchemes.doc(scheme.id).update({
                            "weightTracker": FieldValue.arrayRemove(
                              [scheme.weightTracker[index]],
                            )
                          });

                          provider.editweights(action: "remove", index: index);
                          setState(
                            () {},
                          );
                        },
                        icon: const DeleteIcon()),
                  ),
                );
              },
            ),
          );

          return AlertDialog(
            title: title,
            actions: actions,
            content: content,
          );
        },
      ),
    );
  }
}
