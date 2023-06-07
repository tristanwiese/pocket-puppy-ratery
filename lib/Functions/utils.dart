
import 'dart:developer' as dev;

import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/material.dart';


var primaryThemeColor = const Color.fromARGB(255, 120, 224, 199);

var secondaryThemeColor = const Color.fromARGB(255, 181, 144, 185);

final GlobalKey<ScaffoldMessengerState> scaffoldKey = GlobalKey<ScaffoldMessengerState>();


defaultAgeCalculator(DateTime birthdate){
  if (ageCalculatorYear(birthdate) < 0){
    return("Date incompatable");
  }
  if (ageCalculatorYear(birthdate) == 0) {
    if (ageCalculatorMoth(birthdate) == 0) {
      return("${ageCalculatorDay(birthdate)} days");
    } else {
      if (ageCalculatorDay(birthdate) == 0){
        return("${ageCalculatorMoth(birthdate)} months.");
      } else{
        return("${ageCalculatorMoth(birthdate)} months, ${ageCalculatorDay(birthdate)} days");
      }
    }
  } else {
    if (AgeCalculator.age(birthdate).months == 0){
      return("${ageCalculatorYear(birthdate)} years");
    } else{
      return("${ageCalculatorYear(birthdate)} years, ${AgeCalculator.age(birthdate).months} months");
    }
  }
}

int ageCalculatorDay(DateTime birthdate) {
  int yearsOld = AgeCalculator.age(birthdate).years;
  int monthsOld = AgeCalculator.age(birthdate).months;
  int daysOld = AgeCalculator.age(birthdate).days;

  return daysOld;
}

int ageCalculatorWeek(DateTime birthdate) {
  int yearsOld = AgeCalculator.age(birthdate).years;
  int monthsOld = AgeCalculator.age(birthdate).months;
  int daysOld = AgeCalculator.age(birthdate).days;

  double months = monthsOld * 4.345;
  double years = yearsOld * 52.1429;
  double days = daysOld / 7;
  double weeksOld = days + months + years;
  print(weeksOld);
  return weeksOld.floor();
}

int ageCalculatorMoth(DateTime birthdate) {
  int yearsOld = AgeCalculator.age(birthdate).years;
  int monthsOld = AgeCalculator.age(birthdate).months;
  int daysOld = AgeCalculator.age(birthdate).days;

  if (yearsOld > 0) {
    return (yearsOld * 12) + monthsOld;
  }
  return monthsOld;
}

int ageCalculatorYear(DateTime birthdate) {
  int yearsOld = AgeCalculator.age(birthdate).years;
  int monthsOld = AgeCalculator.age(birthdate).months;
  int daysOld = AgeCalculator.age(birthdate).days;

  return yearsOld;
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