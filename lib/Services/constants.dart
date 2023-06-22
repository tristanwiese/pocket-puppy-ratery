// ignore_for_file: constant_identifier_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Models/rat.dart';

const List<Text> toggleMarkings = <Text>[Text('C-Locus'), Text('H-Locus')];
const List<Text> toggleGender = <Text>[Text("Male"), Text("Female")];

List<String> cMarkingList = Rat.cLocusToList();
List<String> hMarkingsList = Rat.hLocusToList();
List<String> colorsList = Rat.colorsToList();
List<String> earsList = Rat.earsToList();
List<String> coatsList = Rat.coatsToList();
List<String> genderList = Rat.genderToList();

enum Gender { Male, Female }

enum Ears { Dumbo, Standard }

enum H_Locus {
  Unmarked,
  English_Irish,
  Irish_American,
  Variegated,
  Hooded,
  Bareback,
  Capped,
  Essex,
  Variegated_Essex,
  Baldie,
  Black_Eyed_White_Spotted,
  Essex_Dalmation,
  Blazed,
  Roan_Husky,
  Down_Under,
}

enum C_Locus {
  French_Siamese,
  Black_Eyed_Siamese,
  Sable_Siamese,
  Burmese,
  Pink_Eyed_White
}

enum Colours {
  Agouti,
  Amber,
  Fawn,
  Black,
  Champagne,
  Beige,
  Russian_Blue,
  Russian_Blue_Agouti,
  Slate_Blue,
  Slate_Blue_Agouti,
  Russian_Silver,
  Cinnamon,
  Mink,
  Mink_Pearl,
  Cinnamon_Pearl,
  Chocolate_Agouti,
  Chocolate,
}

enum Coats {
  Hairless,
  Harley,
  Standard,
}
