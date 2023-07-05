import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Models/breeding_scheme_model.dart';

class BreedingSchemeProvider extends ChangeNotifier {
  BreedingSchemeProvider({
    required BreedingSchemeModel scheme,
  }) : _scheme = scheme;

  final BreedingSchemeModel _scheme;

  BreedingSchemeModel get getScheme => _scheme;

  changeMale({required String name}) {
    _scheme.male = name;
    notifyListeners();
  }
}
