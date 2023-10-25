import 'package:flutter/material.dart';

class ControllerProvider extends ChangeNotifier {
  int _bottomNavIndex = 0;

  get bottomNavIndex => _bottomNavIndex;

  changeBottomNavIndex({required int index}) {
    _bottomNavIndex = index;
    notifyListeners();
  }
}
