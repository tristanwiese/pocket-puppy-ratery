import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pocket_puppy_rattery/Functions/nav.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';
import 'package:pocket_puppy_rattery/Views/home_page.dart';
import 'package:pocket_puppy_rattery/Views/rat_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  late Color seniorColour;

  late final SharedPreferences prefs;

  bool loading = true;

  changeColour(Color color){
    setState(() {
      seniorColour = color;
    });
  }

  getSharedPrefs() async{
    prefs = await SharedPreferences.getInstance();
    int? prefsSeniorColour = prefs.getInt("seniorColor");
    if (prefsSeniorColour == null){
      seniorColour = const Color(0xff78E0C7);
    } else{
      seniorColour = Color(prefsSeniorColour);
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
                            onColorChanged: changeColour
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                prefs.setInt("seniorColor", seniorColour.value);
                                navPop(context);
                              },
                              style: MyElevatedButtonStyle.buttonStyle,
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
                              "Change the rat cards for rats over 3 years colour"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Current colour: "),
                              Icon(
                                Icons.circle,
                                color: seniorColour,
                              ),
                            ],
                          )
                        ],
                      )),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
