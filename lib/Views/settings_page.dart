import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pocket_puppy_rattery/Functions/nav.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';
import 'package:pocket_puppy_rattery/providers/card_controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Services/custom_widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Color seniorColour;

  late final SharedPreferences prefs;

  bool loading = true;

  late bool seniorColorBool;

  changeColour(Color color) {
    setState(() {
      seniorColour = color;
    });
  }

  getSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
    int? prefsSeniorColour = prefs.getInt("seniorColor");
    if (prefsSeniorColour == null) {
      seniorColour = const Color(0xff78E0C7);
    } else {
      seniorColour = Color(prefsSeniorColour);
    }
    bool? prefsSeniorColorBool = prefs.getBool("seniorColorBool");
    if (prefsSeniorColour == null || prefsSeniorColorBool == true) {
      seniorColorBool = true;
    } else {
      seniorColorBool = false;
    }
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getSharedPrefs();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: loading
          ? const LoadScreen()
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Pick a Colour"),
                                    content: ColorPicker(
                                        pickerColor: seniorColour,
                                        onColorChanged: changeColour),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          prefs.setInt("seniorColor",
                                              seniorColour.value);
                                          context
                                              .read<CardController>()
                                              .changeColor(seniorColour.value);
                                          navPop(context);
                                        },
                                        style:
                                            MyElevatedButtonStyle.buttonStyle,
                                        child: const Text("Done"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: MyInfoCard(
                                title: "Senior Colour",
                                child: Column(
                                  children: [
                                    const Text(
                                        "Change the rat card colour for rats over 3 years old"),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          children: [
                                            const Text("Current colour: "),
                                            Icon(
                                              Icons.circle,
                                              color: seniorColour,
                                            ),
                                          ],
                                        ),
                                        Switch(
                                          value: seniorColorBool,
                                          onChanged: (value) {
                                            seniorColorBool = value;
                                            prefs.setBool(
                                                "seniorColorBool", value);
                                            context
                                                .read<CardController>()
                                                .changeState(value);
                                            setState(() {});
                                          },
                                        )
                                      ],
                                    )
                                  ],
                                )),
                          )),
                        ],
                      ),
                    ],
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side:
                            BorderSide(width: 1.5, color: secondaryThemeColor)),
                    elevation: 10,
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: const Text(
                        "Delete Account",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      trailing: Icon(Icons.delete_forever_outlined,
                          color: Colors.red[300]),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final actions = [
                              ElevatedButton(
                                onPressed: () {
                                  navPop(context);
                                },
                                style: MyElevatedButtonStyle.buttonStyle,
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  navPop(context);
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  );
                                  final user =
                                      FirebaseAuth.instance.currentUser!;
                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(user.uid)
                                      .delete();
                                  user.delete();

                                  navPop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: const BorderSide())),
                                child: const Text("Delete"),
                              ),
                            ];

                            return AlertDialog(
                              actions: actions,
                              title: const Text("Warning!"),
                              content: const Text(
                                  "If you proceed you will loose all your data and account!"),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
