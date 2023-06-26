import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';

class BreedingShcemeInfoPage extends StatefulWidget {
  const BreedingShcemeInfoPage({super.key, required this.scheme});

  final QueryDocumentSnapshot<Object?> scheme;

  @override
  State<BreedingShcemeInfoPage> createState() => _BreedingShcemeInfoPageState();
}

class _BreedingShcemeInfoPageState extends State<BreedingShcemeInfoPage> {

  late final QueryDocumentSnapshot<Object?> scheme;

  @override
  void initState() {
    
    scheme = widget.scheme;

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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: secondaryThemeColor
            ),
          ),
          child:  Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Male: ${scheme["male"]}"),
                Text("Female: ${scheme["female"]}")
              ],
            ),
          ),
        )
      ],
    );
  }
}