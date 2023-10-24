import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Models/breeding_scheme_model.dart';
import 'package:pocket_puppy_rattery/Models/pup_model.dart';

class BreedingSchemeProvider extends ChangeNotifier {
  BreedingSchemeProvider({
    BreedingSchemeModel? scheme,
  }) : _scheme = scheme;

  late BreedingSchemeModel? _scheme;
  Pup? _pup;

  BreedingSchemeModel get getScheme => _scheme!;
  Pup? get pup => _pup;

  updateScheme(BreedingSchemeModel scheme) {
    _scheme = scheme;
    notifyListeners();
  }

  updatePup({required pup}) {
    _pup = pup;
    notifyListeners();
  }

  editBreedPair({required String name, required String gender}) {
    gender == "male" ? _scheme!.male = name : _scheme!.female = name;
    notifyListeners();
  }

  editNotes({required String action, int? index, Map? note}) {
    switch (action) {
      case "add":
        _scheme!.notes.add(note);
        break;
      case "update":
        _scheme!.notes[index!] = note;
        break;
      case "remove":
        _scheme!.notes.removeAt(index!);
    }
    notifyListeners();
  }

  editweights({required String action, int? index, Map? weight}) {
    switch (action) {
      case "add":
        _scheme!.weightTracker.add(weight);
        break;
      case "update":
        _scheme!.weightTracker[index!] = weight;
        break;
      case "remove":
        _scheme!.weightTracker.removeAt(index!);
    }
    notifyListeners();
  }

  editPups({required String action, int? index, Map? pup}) {
    switch (action) {
      case "add":
        _scheme!.pups.add(pup);
        break;
      case "remove":
        _scheme!.pups.removeAt(index!);
        break;
    }
    notifyListeners();
  }

  setPup({required Pup pup}) {
    _pup = pup;
  }
}
