import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';
import 'package:pocket_puppy_rattery/Models/rat.dart';

class CardController extends ChangeNotifier {
  bool _seniorColorBool = prefs.getBool("seniorColorBool") ?? true;
  int _seniorColour = prefs.getInt("seniorColor") ?? 0xff78E0C7;
  Rat? _rat;
  int _seniorAge = prefs.getInt('seniorAge') ?? 3;

  get color => _seniorColour;
  get state => _seniorColorBool;
  Rat get rat => _rat!;
  int get seniorAge => _seniorAge;

  set setRat(Rat rat) => _rat = rat;

  changeState(bool state) {
    _seniorColorBool = state;
    notifyListeners();
  }

  updateSeniorAge({required int age}) {
    _seniorAge = age;
    notifyListeners();
  }

  changeColor(int color) {
    _seniorColour = color;
    notifyListeners();
  }
}
