import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Functions/nav.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';
class BreedingShcemeInfoPage extends StatefulWidget {
  const BreedingShcemeInfoPage(
      {super.key, required this.scheme, required this.rats});

  final QueryDocumentSnapshot<Object?> scheme;
  final List<QueryDocumentSnapshot<Object?>> rats;

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
        title: const Text("Breeding Scheme Info"),
      ),
      body: breedingSchemeInfoBody(),
    );
  }

  Widget breedingSchemeInfoBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: secondaryThemeColor),
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                InkWell(
                  mouseCursor: MaterialStateMouseCursor.clickable,
                  onTap: () {
                    setState(() {
                      editAble = !editAble;
                    });
                  },
                  child: editAble
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: 200,
                              child: TextField(
                                controller: name,
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () async{
                                  showDialog(
                                    context: context,
                                    builder: (context) => const Center(
                                        child: CircularProgressIndicator()),
                                  );
                                  
                                  await schemes.doc(scheme.id).update({"name": name.text.trim()});
                                  setState(() {
                                    editAble = !editAble;
                                  });
                                  // ignore: use_build_context_synchronously
                                  navPop(context);
                                },
                                style: MyElevatedButtonStyle.buttonStyle,
                                child: const Text("Done"))
                          ],
                        )
                      : Text(
                          "Name: ${name.text}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Male: ${scheme["male"]}"),
                    Text("Female: ${scheme["female"]}")
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: 150,
          height: 40,
          child: ElevatedButton(
            onPressed: () {},
            style: MyElevatedButtonStyle.buttonStyle,
            child: const Text('Edit'),
          ),
        )
      ],
    );
  }
}
