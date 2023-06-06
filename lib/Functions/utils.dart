import 'package:flutter/material.dart';


var primaryThemeColor = const Color.fromARGB(255, 120, 224, 199);

var secondaryThemeColor = const Color.fromARGB(255, 181, 144, 185);

final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();


ageCalculator(int year, int month){
  int years = DateTime.now().year - year;
  int months = DateTime.now().month - month;

  return (years * 12) + months;
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