// ignore_for_file: constant_identifier_names, camel_case_types

import 'package:pocket_puppy_rattery/Functions/utils.dart';

import '../Services/constants.dart';

class Rat {
  Rat({
    required this.name,
    required this.registeredName,
    required this.colours,
    required this.ears,
    required this.gender,
    required this.markings,
    required this.parents,
    required this.coat,
    required this.birthday,
  });
  final String name;
  final String registeredName;
  final Gender gender;
  final Ears ears;
  final List colours;
  final List markings;
  final Parents parents;
  final Coats coat;
  final DateTime birthday;
  String colorCode = "none";

  static hLocusToList() {
    const markingsList = H_Locus.values;
    final List<String> markingsName = [];

    for (var element in markingsList) {
      markingsName.add(stringReplace(
          string: element.name.toString(),
          searchElement: ["_"],
          replacementElement: " "));
    }
    return markingsName;
  }

  static cLocusToList() {
    const markingsList = C_Locus.values;
    final List<String> markingsName = [];

    for (var element in markingsList) {
      markingsName.add(stringReplace(
          string: element.name.toString(),
          searchElement: ["_"],
          replacementElement: " "));
    }
    return markingsName;
  }

  static coatsToList() {
    const elementList = Coats.values;
    final List<String> elementsName = [];

    for (var element in elementList) {
      elementsName.add(stringReplace(
          string: element.name.toString(),
          searchElement: ["_"],
          replacementElement: " "));
    }
    return elementsName;
  }

  static colorsToList() {
    const elementList = Colours.values;
    final List<String> elementsName = [];

    for (var element in elementList) {
      elementsName.add(stringReplace(
          string: element.name.toString(),
          searchElement: ["_"],
          replacementElement: " "));
    }
    return elementsName;
  }

  static genderToList() {
    const elementList = Gender.values;
    final List<String> elementsName = [];

    for (var element in elementList) {
      elementsName.add(stringReplace(
          string: element.name.toString(),
          searchElement: ["_"],
          replacementElement: " "));
    }
    return elementsName;
  }

  static List<String> earsToList() {
    const elementList = Ears.values;
    final List<String> elementsName = [];

    for (var element in elementList) {
      elementsName.add(stringReplace(
          string: element.name.toString(),
          searchElement: ["_"],
          replacementElement: " "));
    }
    return elementsName;
  }

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
      "birthday": [
        birthday.year.toInt(),
        birthday.month.toInt(),
        birthday.day.toInt()
      ],
      "colorCode": colorCode
    };
    return rat;
  }
}

class Parents {
  Parents({required this.dad, required this.mom});

  final String mom;
  final String dad;
}

// Name
// Registered name
// Gender
// Ears
// Colour
// Markings
// Coat type
// Parents
//Birthday and if it can generate age
//And weights that can generate a chart
//And heat cycles for the females
//Oh and description