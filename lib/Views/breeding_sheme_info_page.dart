import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  late final QueryDocumentSnapshot<Object?> scheme;

  TextEditingController name = TextEditingController();
  TextEditingController male = TextEditingController();
  TextEditingController female = TextEditingController();

  bool editAble = false;

  @override
  void initState() {
    scheme = widget.scheme;
    name = TextEditingController(text: scheme["name"]);
    male = TextEditingController(text: scheme["male"]);
    female = TextEditingController(text: scheme["female"]);

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
              title: "Notes",
              child: Column(
                children: [
                  !scheme["notes"].isEmpty
                      ? SizedBox(
                          height: 100,
                          child: ListView.builder(
                            itemCount: scheme["notes"].length,
                            itemBuilder: (context, index) => Text(
                                "- ${scheme["notes"][index]["title"]}: ${scheme["notes"][index]["note"]}"),
                          ),
                        )
                      : const Text("No notes"),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        label: const Text("Add Note"),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              final TextEditingController _titleController =
                                  TextEditingController();
                              final TextEditingController _noteController =
                                  TextEditingController();

                              const Widget title = Text("Note");

                              final List<Widget> actions = [
                                ElevatedButton(
                                  onPressed: () {
                                    navPop(context);
                                  },
                                  style:
                                      MyElevatedButtonStyle.cancelButtonStyle,
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (context) => const Center(
                                          child: CircularProgressIndicator()),
                                    );
                                    await FirebaseSchemes.doc(scheme.id)
                                        .update({
                                      "notes": FieldValue.arrayUnion([
                                        {
                                          "title": _titleController.text.trim(),
                                          "note": _noteController.text.trim()
                                        }
                                      ]),
                                    });
                                    navPop(context);
                                    navPop(context);
                                    _titleController.dispose();
                                    _noteController.dispose();
                                  },
                                  style: MyElevatedButtonStyle.doneButtonStyle,
                                  child: const Text("Add Note"),
                                ),
                              ];

                              final Widget content = SizedBox(
                                height: 300,
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: _titleController,
                                      decoration: const InputDecoration(
                                        hintText: "Title",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black45),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: TextField(
                                        decoration: const InputDecoration(
                                            hintText: "Note",
                                            border: InputBorder.none,
                                            constraints: BoxConstraints.expand(
                                                height: 200)),
                                        controller: _noteController,
                                        maxLines: null,
                                      ),
                                    ),
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
                                  ElevatedButton(onPressed: () => navPop(context), child: const Text("Done"),),
                                ];

                                final Widget content = SizedBox(
                                  height: 300,
                                  child: ListView.builder(
                                    itemCount: scheme["notes"].length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        elevation: 10,
                                        shape:  RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: ListTile(
                                          title: Text(scheme["notes"][index]['title']),
                                          trailing: IconButton(
                                            onPressed: () {
                                              FirebaseSchemes.doc(scheme.id).update({
                                                "notes": FieldValue.arrayRemove([scheme["notes"][index]])
                                              });
                                            },
                                            icon: Icon(Icons.delete, color: Colors.red[300],),
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
                              },),);
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
        )
      ],
    );
  }
}
