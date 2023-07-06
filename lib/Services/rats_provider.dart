import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Models/rat.dart';

class RatsProvider extends ChangeNotifier {
  Rat? _rat;

  Rat get rat => _rat!;

  setRats(Rat rat) {
    _rat = rat;
    print(rat.name);
  }

  updateRat(Rat rat) {
    _rat = rat;
    print(rat.name);
    notifyListeners();
  }
}
