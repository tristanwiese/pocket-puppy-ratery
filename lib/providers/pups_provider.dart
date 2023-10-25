import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Models/pup_model.dart';

class PupsProvider extends ChangeNotifier {
  List<Pup>? _pups;
  Pup? _pup;

  List<Pup> get pups => _pups!;
  Pup get pup => _pup!;

  setPups({required List<Pup>? pups}) {
    _pups = pups;
  }

  setPup({required Pup pup}) {
    _pup = pup;
  }

  updatePups({required List<Pup>? pups}) {
    _pups = pups;
    notifyListeners();
  }

  addPup({required Pup pup}) {
    _pups!.add(pup);
    notifyListeners();
  }

  updatePup({required Pup pup}) {
    _pup = pup;
    notifyListeners();
  }
}
