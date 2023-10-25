import 'package:cloud_firestore/cloud_firestore.dart';

class BreedingSchemeModel {
  BreedingSchemeModel({
    required this.male,
    required this.female,
    required this.name,
    required this.isCustomRats,
    required this.date,
    this.weightTracker = const [],
    this.notes = const [],
    this.id = '',
    this.numberOfPups,
    this.dateOfLabour,
  });

  String id;
  String male;
  String female;
  String name;
  DateTime date;
  bool isCustomRats;
  List<dynamic> notes;
  List<dynamic> weightTracker;
  int? numberOfPups;
  Timestamp? dateOfLabour;

  toDB() {
    Map<String, dynamic> scheme = {
      "male": male,
      "female": female,
      "name": name,
      "dateOfMating": [date.year, date.month, date.day],
      "isCustomRats": isCustomRats,
      "notes": notes,
      "weightTracker": weightTracker,
      "numberOfPups": numberOfPups,
      "dateOfLabour": dateOfLabour
    };

    return scheme;
  }

  static fromDb({required QueryDocumentSnapshot dbScheme}) {
    return BreedingSchemeModel(
      male: dbScheme["male"],
      female: dbScheme["female"],
      name: dbScheme["name"],
      isCustomRats: dbScheme["isCustomRats"],
      date: DateTime(dbScheme["dateOfMating"][0], dbScheme["dateOfMating"][1],
          dbScheme["dateOfMating"][2]),
      notes: dbScheme["notes"],
      weightTracker: dbScheme["weightTracker"],
      id: dbScheme.id,
      numberOfPups: dbScheme["numberOfPups"],
      dateOfLabour: dbScheme["dateOfLabour"],
    );
  }
}
