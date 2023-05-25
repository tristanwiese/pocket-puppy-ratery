import 'package:flutter/material.dart';

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

stringreplace({required String string, required String searchElement, required String replacementElement}) {
  String? newString;
  if (!string.contains(searchElement)) {
    return string;
  } else {
    int index = string.indexOf(searchElement);
    newString = string.substring(0, index) + replacementElement + string.substring(index + 1);
    return stringreplace(string: newString, searchElement: searchElement, replacementElement: replacementElement);
  }
}