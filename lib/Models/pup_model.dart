import 'package:pocket_puppy_rattery/Models/rat.dart';

import '../Services/constants.dart';

class Pup {
  Pup(
      {required this.name,
      required this.registeredName,
      required this.colours,
      required this.ears,
      required this.gender,
      required this.markings,
      required this.parents,
      required this.coat,
      this.notes = const []});
  final String name;
  final String registeredName;
  final Gender gender;
  final Ears ears;
  final List colours;
  final List markings;
  final Parents parents;
  final Coats coat;
  List notes;

  toDb() {
    final Map<String, dynamic> rat = {
      "name": name,
      "registeredName": registeredName,
      "gender": gender.name.toString(),
      "ears": ears.name.toString(),
      "colours": colours,
      "markings": markings,
      "mother": parents.mom,
      "father": parents.dad,
      "coat": coat.name.toString(),
    };
    return rat;
  }
}
