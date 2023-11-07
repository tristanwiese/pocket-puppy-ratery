// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Functions/nav.dart';
import 'package:pocket_puppy_rattery/Models/breeding_scheme_model.dart';
import 'package:pocket_puppy_rattery/Models/pup_model.dart';
import 'package:pocket_puppy_rattery/providers/pups_provider.dart';
import 'package:provider/provider.dart';

import '../../Functions/utils.dart';
import '../../Models/rat.dart';
import '../../Services/constants.dart';
import '../../Services/custom_widgets.dart';

const List<Text> toggleMarkings = <Text>[Text('C-Locus'), Text('H-Locus')];
const List<Text> toggleGender = <Text>[Text("Male"), Text("Female")];

List<String> cMarkingList = Rat.cLocusToList();
List<String> hMarkingsList = Rat.hLocusToList();
List<String> colorsList = Rat.colorsToList();
List<String> earsList = Rat.earsToList();
List<String> coatsList = Rat.coatsToList();
List<String> genderList = Rat.genderToList();

class AddPup extends StatefulWidget {
  const AddPup({
    super.key,
    required this.scheme,
    this.pup,
  });
  final BreedingSchemeModel scheme;

  final Pup? pup;

  @override
  State<AddPup> createState() => _AddPupState();
}

class _AddPupState extends State<AddPup> {
  //TextEditControllers
  TextEditingController nameController = TextEditingController();
  TextEditingController registeredNameController = TextEditingController();

  //dropdown list values
  String? colourController;
  String? earController;
  String? coatController;
  String? genderValue;
  List actvieMarkingsList = [];
  List activeColorsList = [];

  Gender? _pickedGender;

  List<String> markingList = cMarkingList;

  List<bool> selectedMarkings = <bool>[true, false];
  List<bool> selectedGender = <bool>[false, false];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.pup != null) {
      nameController = TextEditingController(text: widget.pup!.name);
      registeredNameController =
          TextEditingController(text: widget.pup!.registeredName);
      earController = widget.pup!.ears.name;
      coatController = widget.pup!.coat.name;
      _pickedGender = widget.pup!.gender;
      genderValue = widget.pup!.gender.name;
      widget.pup!.gender.name == "Male"
          ? selectedGender = [true, false]
          : [false, true];

      activeColorsList = widget.pup!.colours;
      if (getMarkingtype(widget.pup!.markings) == "hLocus") {
        selectedMarkings = [false, true];
      } else {
        selectedMarkings = [true, false];
      }
      actvieMarkingsList = widget.pup!.markings;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    registeredNameController.dispose();

    super.dispose();
  }

  getMarkingtype(List markings) {
    for (int i = 0; i < cMarkingList.length; i++) {
      if (markings.contains(cMarkingList[i])) {
        return "cLocus";
      }
    }
    return "hLocus";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: 500,
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "Enter Pup Details",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      MyInputText(
                        controller: nameController,
                        hintText: 'Name',
                        validatorMessage: 'Name required',
                        textInputAction: TextInputAction.next,
                      ),
                      MyInputText(
                        controller: registeredNameController,
                        hintText: 'Registered Name',
                        validatorMessage: 'Registered Name Required',
                        textInputAction: TextInputAction.next,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: CoatSelect()),
                          const SizedBox(width: 10),
                          Expanded(child: EarSelect()),
                          const SizedBox(width: 10),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ColorSelect(),
                      const SizedBox(height: 10),
                      LocusSelect(),
                      const SizedBox(height: 10),
                      locusDropdownButton(),
                      const SizedBox(height: 10),
                      GenderSelect(),
                      const SizedBox(height: 10),
                      SaveButton(context),
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget SaveButton(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 130,
        height: 40,
        child: ElevatedButton(
          onPressed: () async {
            final PupsProvider pupProv =
                Provider.of<PupsProvider>(context, listen: false);
            if (!_formKey.currentState!.validate()) {
              return;
            }
            showDialog(
              context: context,
              builder: (context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
            if (_pickedGender == null) {
              showError("Gender");
              navPop(context);
              return;
            }
            if (actvieMarkingsList.isEmpty) {
              showError("Markings");
              navPop(context);
              return;
            }
            if (activeColorsList.isEmpty) {
              showError("Colors");
              navPop(context);
              return;
            }
            if (earController == null) {
              showError("Ears");
              navPop(context);
              return;
            }
            if (coatController == null) {
              showError("Coat");
              navPop(context);
              return;
            }
            coatsList.sort();

            final pup = Pup(
              name: nameController.text.trim(),
              registeredName: registeredNameController.text.trim(),
              colours: activeColorsList,
              ears: Ears.values[
                  earsList.indexWhere((element) => element == earController)],
              gender: _pickedGender!,
              markings: actvieMarkingsList,
              parents:
                  Parents(dad: widget.scheme.male, mom: widget.scheme.female),
              coat: Coats.values[
                  coatsList.indexWhere((element) => element == coatController)],
            );

            if (widget.pup != null) {
              FirebaseSchemes.doc(widget.scheme.id)
                  .collection('pups')
                  .doc(widget.pup!.id)
                  .update(pup.toDb());

              pup.id = widget.pup!.id;

              pupProv.updatePup(pup: pup);
              final List<Pup> pups = pupProv.pups;
              int index = pupProv.pups.indexWhere((element) {
                return element.id == widget.pup!.id;
              });

              pups[index] = pup;

              pupProv.updatePups(pups: pups);
              navPop(context);
              navPop(context);
              return;
            }
            await FirebaseSchemes.doc(widget.scheme.id)
                .collection('pups')
                .add(pup.toDb());

            pupProv.updatePups(pups: pupProv.pups);

            navPop(context);
            navPop(context);
          },
          style: MyElevatedButtonStyle.buttonStyle,
          child: const Text('Save'),
        ),
      ),
    );
  }

  Widget GenderSelect() {
    return ToggleButtons(
      onPressed: (index) {
        for (var i = 0; i < 2; i++) {
          setState(() {
            selectedGender[i] = false;
          });
        }
        selectedGender[index] = !selectedGender[index];
        _pickedGender = Gender.values[index];
        setState(() {});
      },
      isSelected: selectedGender,
      direction: Axis.horizontal,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      selectedBorderColor: Colors.black,
      selectedColor: Colors.white,
      fillColor: secondaryThemeColor,
      color: secondaryThemeColor,
      constraints: BoxConstraints(
        minHeight: 40.0,
        minWidth: (MediaQuery.of(context).size.width <= 500)
            ? (MediaQuery.of(context).size.width / 2) - 20
            : 240,
      ),
      children: toggleGender,
    );
  }

  Widget locusDropdownButton() {
    return showListButton(
        listOf: "Markings",
        title:
            "Choose Markings: ${toggleMarkings[selectedMarkings.indexWhere((element) => element == true)].data}",
        buildList: markingList,
        activeList: actvieMarkingsList);
  }

  Widget LocusSelect() {
    return ToggleButtons(
      onPressed: (index) {
        for (var i = 0; i < 2; i++) {
          setState(() {
            selectedMarkings[i] = false;
          });
        }
        selectedMarkings[index] = !selectedMarkings[index];
        if (index == 0) {
          markingList = cMarkingList;
          actvieMarkingsList.clear();
        } else {
          markingList = hMarkingsList;
          actvieMarkingsList.clear();
        }
        setState(() {});
      },
      isSelected: selectedMarkings,
      direction: Axis.horizontal,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      selectedBorderColor: Colors.black,
      selectedColor: Colors.white,
      fillColor: secondaryThemeColor,
      color: secondaryThemeColor,
      constraints: BoxConstraints(
        minHeight: 40.0,
        minWidth: (MediaQuery.of(context).size.width <= 500)
            ? (MediaQuery.of(context).size.width / 2) - 20
            : 240,
      ),
      children: toggleMarkings,
    );
  }

  Widget CoatSelect() {
    coatsList.sort();
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: secondaryThemeColor, width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: const Center(
              child: Text('Coat',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15))),
          value: coatController,
          items: coatsList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Center(
                child: Text(
                  value,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              coatController = value!;
            });
          },
        ),
      ),
    );
  }

  Widget EarSelect() {
    earsList.sort();
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: secondaryThemeColor, width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: const Center(
              child: Text('Ears',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15))),
          value: earController,
          items: earsList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Center(
                child: Text(
                  value,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              earController = value!;
            });
          },
        ),
      ),
    );
  }

  Widget ColorSelect() {
    return showListButton(
        title: "Choose Colour",
        listOf: "Colors",
        buildList: colorsList,
        activeList: activeColorsList);
  }

  AppBar myAppBar() {
    return AppBar(
      title: const Text("Add Rat Info"),
    );
  }

  showError(String errorVal) {
    alert(text: "$errorVal not set!", duration: 5);
  }

  Widget showListButton(
      {required String title,
      required String listOf,
      required List buildList,
      required List activeList}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(60),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: secondaryThemeColor))),
      onPressed: () {
        buildList.sort();
        showList(
          title: title,
          buildList: buildList,
          activeList: activeList,
        );
      },
      child: Text(
        listOf,
        style: const TextStyle(color: Colors.black87),
      ),
    );
  }

  Future<dynamic> showList(
      {required String title,
      required List buildList,
      required List activeList}) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(title),
            actions: [
              Center(
                child: ElevatedButton(
                    style: MyElevatedButtonStyle.doneButtonStyle,
                    onPressed: () => navPop(context),
                    child: const Text("Done")),
              )
            ],
            content: SizedBox(
              height: 400,
              width: MediaQuery.of(context).size.width / 1.2,
              child: ListView.builder(
                itemCount: buildList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(7),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                          color: activeList.contains(buildList[index])
                              ? primaryThemeColor
                              : null),
                      child: ListTile(
                        title: Text(buildList[index]),
                        trailing: SizedBox(
                          height: 10,
                          width: 10,
                          child: activeList.contains(buildList[index])
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                              : Container(),
                        ),
                        onTap: () {
                          if (activeList.contains(buildList[index])) {
                            activeList.remove(buildList[index]);
                            setState(() {});
                          } else {
                            setState(() {
                              activeList.add(buildList[index]);
                            });
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
