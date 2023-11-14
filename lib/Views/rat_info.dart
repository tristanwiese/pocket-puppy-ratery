// ignore_for_file: no_logic_in_create_state

// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Functions/nav.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';
import 'package:pocket_puppy_rattery/Views/add_rat.dart';
import 'package:pocket_puppy_rattery/Views/rat_gallery.dart';
import 'package:pocket_puppy_rattery/providers/rats_provider.dart';
import 'package:provider/provider.dart';
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

  late RatsProvider provider;

  late Rat rat;

  // Age to be displayed, dynamically calculated by ageCalculator
  String age = '';

  List<String> ageView = ["Years", "Months", "Weeks", "Days", "Default"];
  String? _dropDownValue;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<RatsProvider>(context, listen: false);
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
          ratNotes(),
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
                FirebaseRats.doc(rat.id).update({
                  "notes": FieldValue.arrayRemove([rat.notes![index!]]),
                });
                provider.editNotes(action: "update", index: index, note: {
                  "title": titleController.text.trim(),
                  "note": noteController.text.trim()
                });
                FirebaseRats.doc(rat.id).update({
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
              FirebaseRats.doc(rat.id).update({
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
          title: title,
          actions: actions,
          content: content,
        );
      },
    );
  }

  MyInfoCard ratNotes() {
    return MyInfoCard(
      title: "Notes",
      child: Column(
        children: [
          rat.notes!.isNotEmpty
              ? SizedBox(
                  height: rat.notes!.length > 10 ? 200 : rat.notes!.length * 20,
                  child: ListView.builder(
                    itemCount: rat.notes!.length,
                    itemBuilder: (context, index) => Text(
                        "- ${rat.notes![index]["title"]}: ${rat.notes![index]["note"]}"),
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
                            itemCount: rat.notes!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: ListTile(
                                  onTap: () => addNote(
                                      index: index,
                                      note: rat.notes![index]["note"],
                                      noteTitle: rat.notes![index]["title"]),
                                  title: Text(rat.notes![index]['title']),
                                  trailing: IconButton(
                                      onPressed: () {
                                        FirebaseRats.doc(rat.id).update({
                                          "notes": FieldValue.arrayRemove(
                                            [rat.notes![index]],
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
