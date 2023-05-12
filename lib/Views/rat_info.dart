// ignore_for_file: no_logic_in_create_state

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';

class RatInfo extends StatefulWidget {
  const RatInfo({
    super.key,
    required this.info,
  });

  final dynamic info;

  @override
  State<RatInfo> createState() => _RatInfoState(info: info);
}

class _RatInfoState extends State<RatInfo> {
  _RatInfoState({required this.info});

  final dynamic info;

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: myAppBar(), body: myBody());
  }

  Widget myBody() {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection("rats")
          .doc(widget.info)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text("Catching the ${widget.info}"),
          );
        }
        if (!snapshot.hasData) {
          return Center(
            child: Text(
                'Sorry, something went wrong while fetching ${widget.info}!'),
          );
        }
        final info = snapshot.data!.data();
        return 
        Center(
          child: Container(
            height: 500,
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(20),
              color: secondaryThemeColor
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Name: ${info!["name"]}"
                ),
                const SizedBox(height: 10),
                Text(
                  "Registered Name: ${info["registeredName"]}"
                ),
                const SizedBox(height: 10),
                Text(
                  "Color: ${info["colours"]}"
                ),
                const SizedBox(height: 10),
                Text(
                  "Coat: ${info["coat"]}"
                ),
                const SizedBox(height: 10),
                Text(
                  "Markings: ${info["markings"]}"
                ),
                const SizedBox(height: 10),
                Text(
                  "Ears: ${info["ears"]}"
                ),
                const SizedBox(height: 10),
                Text(
                  "Gender: ${info["gender"]}"
                ),
                const SizedBox(height: 10),
                Text(
                  "Birthday: ${info["birthday"][0]}-${info["birthday"][1]}-${info["birthday"][2]}"
                ),
                const SizedBox(height: 10),
                Text(
                  "Mother: ${info["mother"]}"
                ),
                const SizedBox(height: 10),
                Text(
                  "Father: ${info["father"]}"
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  AppBar myAppBar() => AppBar();
}
