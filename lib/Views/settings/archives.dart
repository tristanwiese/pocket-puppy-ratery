import 'package:age_calculator/age_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';
import 'package:pocket_puppy_rattery/Models/rat.dart';
import 'package:pocket_puppy_rattery/providers/card_controller.dart';
import 'package:provider/provider.dart';

class Archives extends StatefulWidget {
  const Archives({super.key});

  @override
  State<Archives> createState() => _ArchivesState();
}

class _ArchivesState extends State<Archives> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archives'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseRats.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                if (!snapshot.data!.docs[index]['archived']) {
                  return Container();
                }
                final Rat rat = Rat.fromDB(dbRat: snapshot.data!.docs[index]);
                DateTime birthdate = rat.birthday;
                Color? colorCode;
                switch (rat.colorCode) {
                  case "green":
                    colorCode = Colors.green[300];
                  case "blue":
                    colorCode = Colors.blue[300];
                  case "red":
                    colorCode = Colors.red[300];
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<CardController>(
                      builder: (context, value, child) {
                    value.setRat = rat;
                    final bool hasProfile =
                        (rat.profilePic != null && rat.profilePic != '');
                    return Card(
                      elevation: 3,
                      shadowColor: (AgeCalculator.age(birthdate).years >=
                              value.seniorAge)
                          ? value.state
                              ? Color(value.color)
                              : Colors.black
                          : Colors.black,
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      color: (AgeCalculator.age(birthdate).years >=
                              value.seniorAge)
                          ? value.state
                              ? Color(value.color)
                              : null
                          : null,
                      child: ListTile(
                        isThreeLine: true,
                        leading: SizedBox(
                          width: 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.square_rounded,
                                color: colorCode,
                              ),
                              hasProfile
                                  ? SizedBox(
                                      width: 45,
                                      child: Image.network(
                                        rat.profilePic!,
                                        fit: BoxFit.contain,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return const Center(
                                            child: Icon(Icons.image),
                                          );
                                        },
                                      ),
                                    )
                                  : Image.asset(
                                      "asstes/images/logo.png",
                                      width: 30,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.image),
                                    )
                            ],
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            FirebaseRats.doc(rat.id)
                                .update({'archived': false});
                          },
                          icon: const Icon(Icons.upload),
                        ),
                        title: Text(rat.name),
                        subtitle: Text("${rat.gender}"
                            "\n"
                            "Age: ${defaultAgeCalculator(birthdate)}"),
                        contentPadding: const EdgeInsets.all(10),
                      ),
                    );
                  }),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
