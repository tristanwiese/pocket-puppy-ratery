import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';
import 'package:pocket_puppy_rattery/Models/rat.dart';

class CardController extends ChangeNotifier {
  bool _seniorColorBool = prefs.getBool("seniorColorBool") ?? true;
  int _seniorColour = prefs.getInt("seniorColor") ?? 0xff78E0C7;
  Rat? _rat;

  get color => _seniorColour;
  get state => _seniorColorBool;
  Rat get rat => _rat!;

  set setRat(Rat rat) => _rat = rat;

  changeState(bool state) {
    _seniorColorBool = state;
    notifyListeners();
  }

  changeColor(int color) {
    _seniorColour = color;
    notifyListeners();
  }
}
