// ignore_for_file: use_build_context_synchronously
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:pocket_puppy_rattery/Functions/nav.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';
import 'package:pocket_puppy_rattery/Views/breeding_scheme.dart';
import 'package:pocket_puppy_rattery/Views/rat_info.dart';

class BreedingShcemeInfoPage extends StatefulWidget {
  const BreedingShcemeInfoPage(
      {super.key, required this.scheme, required this.rats});

  final QueryDocumentSnapshot<Object?> scheme;
  final List<QueryDocumentSnapshot<Object?>>? rats;

  @override
  State<BreedingShcemeInfoPage> createState() => _BreedingShcemeInfoPageState();
}

class _BreedingShcemeInfoPageState extends State<BreedingShcemeInfoPage> {
  late final scheme;

  // TextEditingController name = TextEditingController();
  // TextEditingController male = TextEditingController();
  // TextEditingController female = TextEditingController();

  bool editAble = false;
  List<Map> notes = [];
  List<Map> weights = [];

  customSetState() => setState(() {});

  updateScheme() async => FirebaseSchemes.doc(scheme.id)
      .get()
      .then((value) => scheme = value.data());

  @override
  void initState() {
    scheme = widget.scheme;
    // // name = TextEditingController(text: scheme["name"]);
    // male = TextEditingController(text: scheme["male"]);
    // female = TextEditingController(text: scheme["female"]);

    for (int i = 0; i < scheme["notes"].length; i++) {
      notes.add(scheme["notes"][i]);
    }
    for (int i = 0; i < scheme["weightTracker"].length; i++) {
      weights.add(scheme["weightTracker"][i]);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(scheme["name"]),
      ),
      body: breedingSchemeInfoBody(),
    );
  }

  Widget breedingSchemeInfoBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(),
        Column(
          children: [
            MyInfoCard(
              title: "Date of Breeding",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${scheme["dateOfMating"][0]}/${scheme["dateOfMating"][1]}/${scheme["dateOfMating"][2]}",
                  ),
                ],
              ),
            ),
            MyInfoCard(
              title: "Parent Details",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Male: ${scheme["male"]}"),
                  Text("Female: ${scheme["female"]}"),
                ],
              ),
            ),
            MyInfoCard(
              title: "Weight Tracker",
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  weights.isNotEmpty
                      ? SizedBox(
                          height:
                              weights.length > 10 ? 200 : weights.length * 20,
                          child: ListView.builder(
                            itemCount: weights.length,
                            itemBuilder: (context, index) {
                              return Text(
                                  "- ${weights[index]["date"][0]}/${weights[index]["date"][1]}/${weights[index]["date"][2]} : ${weights[index]["weight"]}g");
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
            ),
            MyInfoCard(
              title: "Notes",
              child: Column(
                children: [
                  notes.isNotEmpty
                      ? SizedBox(
                          height: notes.length > 10 ? 200 : notes.length * 20,
                          child: ListView.builder(
                            itemCount: notes.length,
                            itemBuilder: (context, index) => Text(
                                "- ${notes[index]["title"]}: ${notes[index]["note"]}"),
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
                                      customSetState();
                                      navPop(context);
                                    },
                                    child: const Text("Done"),
                                  ),
                                ];

                                final Widget content = SizedBox(
                                  height: 300,
                                  child: ListView.builder(
                                    itemCount: notes.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: ListTile(
                                          onTap: () => addNote(
                                              index: index,
                                              note: notes[index]["note"],
                                              noteTitle: notes[index]["title"]),
                                          title: Text(notes[index]['title']),
                                          trailing: IconButton(
                                            onPressed: () {
                                              FirebaseSchemes.doc(scheme.id)
                                                  .update({
                                                "notes": FieldValue.arrayRemove(
                                                  [notes[index]],
                                                )
                                              });
                                              customSetState();
                                              setState(() {
                                                notes.removeAt(index);
                                              });
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red[300],
                                            ),
                                          ),
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
                        },
                        label: const Text("Edit Notes"),
                        icon: const Icon(Icons.edit),
                        style: MyElevatedButtonStyle.buttonStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
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
                      chosenRats: [scheme["male"], scheme["female"]],
                      date: DateTime(scheme["dateOfMating"][0],
                          scheme["dateOfMating"][1], scheme["dateOfMating"][2]),
                      isCustomRats: scheme["isCustomRats"],
                      name: scheme["name"],
                      id: scheme.id,
                    ),
                  );
                },
                style: MyElevatedButtonStyle.buttonStyle,
                child: const Text('Edit'),
              ),
            ),
            // Container(
            //   margin: const EdgeInsets.symmetric(vertical: 10),
            //   width: 150,
            //   height: 40,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       setState(() {});
            //     },
            //     style: MyElevatedButtonStyle.buttonStyle,
            //     child: const Text('Refresh'),
            //   ),
            // ),
          ],
        )
      ],
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
                  "notes": FieldValue.arrayRemove([notes[index!]]),
                });
                notes[index] = {
                  "title": titleController.text.trim(),
                  "note": noteController.text.trim()
                };
                FirebaseSchemes.doc(scheme.id).update({
                  "notes": FieldValue.arrayUnion([
                    {
                      "title": titleController.text.trim(),
                      "note": noteController.text.trim()
                    }
                  ]),
                });
                setState(() {});

                navPop(context);
                navPop(context);
                return;
              }
              notes.add({
                "title": titleController.text.trim(),
                "note": noteController.text.trim()
              });
              customSetState();
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

  void addWeightEntry({int weight = 300, DateTime? date, int? index}) {
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
                      "weightTracker": FieldValue.arrayRemove([weights[index]]),
                    });
                    weights[index] = entry;
                    FirebaseSchemes.doc(scheme.id).update({
                      "weightTracker": FieldValue.arrayUnion([entry]),
                    });
                    customSetState();
                    navPop(context);
                    navPop(context);
                    return;
                  }
                  weights.add(entry);
                  customSetState();
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
                customSetState();
                navPop(context);
              },
              child: const Text("Done"),
            ),
          ];

          final Widget content = SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: weights.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    onTap: () => addWeightEntry(
                        date: DateTime(
                            weights[index]["date"][0],
                            weights[index]["date"][1],
                            weights[index]["date"][2]),
                        weight: weights[index]["weight"],
                        index: index),
                    title: Text(
                        "- ${weights[index]["date"][0]}/${weights[index]["date"][1]}/${weights[index]["date"][2]} : ${weights[index]["weight"]}g"),
                    trailing: IconButton(
                      onPressed: () {
                        FirebaseSchemes.doc(scheme.id).update({
                          "weightTracker": FieldValue.arrayRemove(
                            [weights[index]],
                          )
                        });

                        setState(() {
                          weights.removeAt(index);
                        });
                        customSetState();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red[300],
                      ),
                    ),
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
