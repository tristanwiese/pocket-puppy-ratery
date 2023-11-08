import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Functions/nav.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';
import 'package:pocket_puppy_rattery/Models/pup_model.dart';
import 'package:pocket_puppy_rattery/Services/custom_widgets.dart';
import 'package:pocket_puppy_rattery/Views/Breeding%20Scheme/add_pup.dart';
import 'package:pocket_puppy_rattery/Views/Breeding%20Scheme/pup_gallery.dart';
import 'package:pocket_puppy_rattery/providers/breeding_scheme_provider.dart';
import 'package:pocket_puppy_rattery/providers/pups_provider.dart';
import 'package:pocket_puppy_rattery/providers/rats_provider.dart';
import 'package:provider/provider.dart';

class PupInfo extends StatefulWidget {
  const PupInfo({super.key});

  @override
  State<PupInfo> createState() => _PupInfoState();
}

class _PupInfoState extends State<PupInfo> {
  late BreedingSchemeProvider breedProv;

  @override
  Widget build(BuildContext context) {
    breedProv = Provider.of<BreedingSchemeProvider>(context, listen: false);
    return Consumer<PupsProvider>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Pup: ${value.pup.name}"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              details(value: value),
              age(value: value),
              parents(value: value),
              coat(value: value),
              markings(value: value),
              colors(value: value),
              pupNotes(value: value),
              buttonRow(value: value),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    });
  }

  MyInfoCard pupNotes({required PupsProvider value}) {
    return MyInfoCard(
      title: "Notes",
      child: Column(
        children: [
          value.pup.notes!.isNotEmpty
              ? SizedBox(
                  height: value.pup.notes!.length > 10
                      ? 200
                      : value.pup.notes!.length * 20,
                  child: ListView.builder(
                    itemCount: value.pup.notes!.length,
                    itemBuilder: (context, index) => Text(
                        "- ${value.pup.notes![index]["title"]}: ${value.pup.notes![index]["note"]}"),
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
                  addNote(value: value);
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
                            itemCount: value.pup.notes!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: ListTile(
                                  onTap: () => addNote(
                                      value: value,
                                      index: index,
                                      note: value.pup.notes![index]["note"],
                                      noteTitle: value.pup.notes![index]
                                          ["title"]),
                                  title: Text(value.pup.notes![index]['title']),
                                  trailing: IconButton(
                                    onPressed: () {
                                      FirebaseSchemes.doc(
                                              breedProv.getScheme.id)
                                          .collection('pups')
                                          .doc(value.pup.id)
                                          .update({
                                        'notes': FieldValue.arrayRemove(
                                            [value.pup.notes![index]])
                                      });

                                      final Pup pup = value.pup;

                                      pup.notes!.removeAt(index);
                                      value.updatePup(pup: pup);
                                      setState(
                                        () {},
                                      );
                                    },
                                    icon: const DeleteIcon(),
                                  ),
                                ),
                              );
                            },
                          ),
                        );

                        return SizedBox(
                          height: 400,
                          child: AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
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

  Row markings({required PupsProvider value}) {
    return Row(
      children: [
        Expanded(
          child: MyInfoCard(
            title: "Markings",
            child: SizedBox(
              height:
                  listContainerHeight(itemLenght: value.pup.markings.length),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.pup.markings.length,
                itemBuilder: (context, index) {
                  return Text("- ${value.pup.markings[index]}");
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row age({required PupsProvider value}) {
    return Row(
      children: [
        Expanded(
          child: MyInfoCard(
              title: "Age",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                      "Birthday: ${birthdayView(data: breedProv.getScheme.dateOfLabour!.toDate())}"),
                  Text(
                      "Age: ${defaultAgeCalculator(breedProv.getScheme.dateOfLabour!.toDate())}"),
                ],
              )),
        ),
      ],
    );
  }

  Row coat({required PupsProvider value}) {
    return Row(
      children: [
        Expanded(
          child: MyInfoCard(
            title: "Coat",
            child: Text("Coat: ${value.pup.coat.name}"),
          ),
        ),
        Expanded(
            child: MyInfoCard(
                title: "Ears", child: Text("Ears: ${value.pup.ears.name}")))
      ],
    );
  }

  Row details({required PupsProvider value}) {
    return Row(
      children: [
        Expanded(
          child: MyInfoCard(
              title: "Details",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: ${value.pup.name}"),
                  Text("Registered Name: ${value.pup.registeredName}"),
                  Text("Gender: ${value.pup.gender}"),
                ],
              )),
        ),
      ],
    );
  }

  parents({required PupsProvider value}) {
    final RatsProvider prov = Provider.of<RatsProvider>(context, listen: false);
    dynamic mom = breedProv.getScheme.isCustomRats
        ? value.pup.parents.mom
        : List.from(prov.rats!
                .where((element) => element.id == value.pup.parents.mom))[0]
            ['name'];
    dynamic dad = breedProv.getScheme.isCustomRats
        ? value.pup.parents.dad
        : List.from(prov.rats!
                .where((element) => element.id == value.pup.parents.dad))[0]
            ['name'];
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

  Row colors({required PupsProvider value}) {
    return Row(
      children: [
        Expanded(
          child: MyInfoCard(
            title: "Colours",
            child: SizedBox(
              height: listContainerHeight(itemLenght: value.pup.colours.length),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.pup.colours.length,
                itemBuilder: (context, index) {
                  return Text("- ${value.pup.colours[index]}");
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buttonRow({required PupsProvider value}) {
    return Row(
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
                      AddPup(
                    scheme: breedProv.getScheme,
                    pup: value.pup,
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
                      const PupGallery(),
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
    );
  }

  Future<dynamic> addNote({
    String noteTitle = "",
    String note = "",
    int? index,
    required PupsProvider value,
  }) {
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
                FirebaseSchemes.doc(breedProv.getScheme.id)
                    .collection('pups')
                    .doc(value.pup.id)
                    .update({
                  "notes": FieldValue.arrayRemove([value.pup.notes![index!]]),
                });
                final Pup pup = value.pup;

                pup.notes![index] = {
                  "title": titleController.text.trim(),
                  "note": noteController.text.trim()
                };
                value.updatePup(pup: pup);
                FirebaseSchemes.doc(breedProv.getScheme.id)
                    .collection('pups')
                    .doc(value.pup.id)
                    .update({
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
              final Pup pup = value.pup;

              pup.notes!.add({
                "title": titleController.text.trim(),
                "note": noteController.text.trim()
              });
              value.updatePup(pup: pup);

              FirebaseSchemes.doc(breedProv.getScheme.id)
                  .collection('pups')
                  .doc(value.pup.id)
                  .update({
                "notes": FieldValue.arrayUnion([
                  {
                    "title": titleController.text.trim(),
                    "note": noteController.text.trim()
                  }
                ]),
              });
              navPop(context);
              // titleController.dispose();
              // noteController.dispose();
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: title,
          actions: actions,
          content: content,
        );
      },
    );
  }
}
