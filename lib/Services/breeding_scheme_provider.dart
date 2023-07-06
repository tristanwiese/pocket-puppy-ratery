import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Models/breeding_scheme_model.dart';

class BreedingSchemeProvider extends ChangeNotifier {
  BreedingSchemeProvider({
    required BreedingSchemeModel scheme,
  }) : _scheme = scheme;

  BreedingSchemeModel _scheme;

  BreedingSchemeModel get getScheme => _scheme;

  updateScheme(BreedingSchemeModel scheme) {
    _scheme = scheme;
    notifyListeners();
  }

  editBreedPair({required String name, required String gender}) {
    gender == "male" ? _scheme.male = name : _scheme.female = name;
    notifyListeners();
  }

  editNotes({required String action, int? index, Map? note}) {
    switch (action) {
      case "add":
        _scheme.notes.add(note);
        break;
      case "update":
        _scheme.notes[index!] = note;
        break;
      case "remove":
        _scheme.notes.removeAt(index!);
    }
    notifyListeners();
  }

  editweights({required String action, int? index, Map? weight}) {
    switch (action) {
      case "add":
        _scheme.weightTracker.add(weight);
        break;
      case "update":
        _scheme.weightTracker[index!] = weight;
        break;
      case "remove":
        _scheme.weightTracker.removeAt(index!);
    }
    notifyListeners();
  }
}
