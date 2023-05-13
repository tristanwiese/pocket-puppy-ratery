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