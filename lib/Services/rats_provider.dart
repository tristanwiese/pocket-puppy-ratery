import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Models/rat.dart';

class RatsProvider extends ChangeNotifier {
  Rat? _rat;

  List<dynamic>? _rats;

  List<dynamic>? get rats => _rats;
  Rat get rat => _rat!;

  setRat(Rat rat) {
    _rat = rat;
  }

  setRats({required List<dynamic> rats}) {
    _rats = rats;
  }

  updateRat(Rat rat) {
    _rat = rat;
    notifyListeners();
  }
}
