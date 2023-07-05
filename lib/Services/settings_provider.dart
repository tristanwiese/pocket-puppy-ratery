import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';

class SeniorRatWatcher extends ChangeNotifier{

  bool _seniorColorBool = prefs.getBool("seniorColorBool")??true;
  int _seniorColour = prefs.getInt("seniorColor")??0xff78E0C7;

  get color => _seniorColour;
  get state => _seniorColorBool;

  changeState(bool state){
    _seniorColorBool = state;
    notifyListeners();
  }
  changeColor(int color){
    _seniorColour = color;
    notifyListeners();
  }
}