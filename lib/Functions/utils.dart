import 'package:flutter/material.dart';

import '../Models/gene.dart';

var primaryThemeColor = const Color.fromARGB(255, 120, 224, 199);

var secondaryThemeColor = const Color.fromARGB(255, 181, 144, 185);

final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();


ageCalculator(int year, int month){
  int age = DateTime.now().year - year;
  if (DateTime.now().month < month){
    age = age - 1;
  }
  return age;
}

stringreplace({required String string, required List<String> searchElement, required String replacementElement, int currentIndex = 0}) {
  String? newString;
  for (var i = 0; i < searchElement.length; i++){
    if (!string.contains(searchElement[i])) {
      if (i == searchElement.length - 1){
        return string;
      }
  } else {
    int index = string.indexOf(searchElement[i]);
    newString = string.substring(0, index) + replacementElement + string.substring(index + 1);
    return stringreplace(string: newString, searchElement: searchElement, replacementElement: replacementElement, currentIndex: 1);
  }
  }
}

geneCalculator({required Gene gene1, required Gene gene2}){
  gene1;
}