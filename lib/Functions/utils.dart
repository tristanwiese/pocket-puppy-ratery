import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

var primaryThemeColor = const Color.fromARGB(255, 120, 224, 199);

var secondaryThemeColor = const Color.fromARGB(255, 181, 144, 185);

late SharedPreferences prefs;

class MyElevatedButtonStyle {

  static final buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: secondaryThemeColor),
    ),
  );

  static final activeButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: secondaryThemeColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: secondaryThemeColor),
    ),
  );
  static final doneButtonStyle = ElevatedButton.styleFrom(
    fixedSize: const Size(100, 40),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20))));

  static const textStyle = TextStyle(color: Colors.black87);
}

final GlobalKey<ScaffoldMessengerState> scaffoldKey =
    GlobalKey<ScaffoldMessengerState>();

defaultAgeCalculator(DateTime birthdate) {
  if (ageCalculatorYear(birthdate) < 0) {
    return ("Date incompatable");
  }
  if (ageCalculatorYear(birthdate) == 0) {
    if (ageCalculatorMonth(birthdate) == 0) {
      return ("${ageCalculatorDay(birthdate)} days");
    } else {
      if (ageCalculatorDay(birthdate) == 0) {
        return ("${ageCalculatorMonth(birthdate)} months");
      } else {
        return ("${ageCalculatorMonth(birthdate)} months, ${ageCalculatorDay(birthdate)} days");
      }
    }
  } else {
    if (AgeCalculator.age(birthdate).months == 0) {
      return ("${ageCalculatorYear(birthdate)} years");
    } else {
      return ("${ageCalculatorYear(birthdate)} years, ${AgeCalculator.age(birthdate).months} months");
    }
  }
}

int ageCalculatorDay(DateTime birthdate) {
  int yearsOld = AgeCalculator.age(birthdate).years;
  int monthsOld = AgeCalculator.age(birthdate).months;
  int daysOld = AgeCalculator.age(birthdate).days;

  double monthsToDays = monthsOld * 30.4167 + (monthsOld / 2);
  double yearsToDays = yearsOld * 365.2425;
  int ageInDaysOnly =
      (monthsToDays.floor() + yearsToDays.floor() + daysOld).round();

  return ageInDaysOnly;
}

int ageCalculatorWeek(DateTime birthdate) {
  int yearsOld = AgeCalculator.age(birthdate).years;
  int monthsOld = AgeCalculator.age(birthdate).months;
  int daysOld = AgeCalculator.age(birthdate).days;

  double months = monthsOld * 4.345;
  double years = yearsOld * 52.1429;
  double days = daysOld / 7;
  double weeksOld = days + months + years;

  return weeksOld.floor();
}

int ageCalculatorMonth(DateTime birthdate) {
  int yearsOld = AgeCalculator.age(birthdate).years;
  int monthsOld = AgeCalculator.age(birthdate).months;

  if (yearsOld > 0) {
    return (yearsOld * 12) + monthsOld;
  }
  return monthsOld;
}

int ageCalculatorYear(DateTime birthdate) {
  int yearsOld = AgeCalculator.age(birthdate).years;

  return yearsOld;
}

stringReplace(
    {required String string,
    required List<String> searchElement,
    required String replacementElement,
    int currentIndex = 0}) {
  String? newString;
  for (var i = 0; i < searchElement.length; i++) {
    if (!string.contains(searchElement[i])) {
      if (i == searchElement.length - 1) {
        return string;
      }
    } else {
      int index = string.indexOf(searchElement[i]);
      newString = string.substring(0, index) +
          replacementElement +
          string.substring(index + 1);
      return stringReplace(
          string: newString,
          searchElement: searchElement,
          replacementElement: replacementElement,
          currentIndex: 1);
    }
  }
}
