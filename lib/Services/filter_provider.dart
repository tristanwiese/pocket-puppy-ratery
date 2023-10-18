import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FilterProvider extends ChangeNotifier {
  List<String> _filters = ["Gender", "Age"];
  List<QueryDocumentSnapshot> _filteredRats = [];
  String _activeFilters = "";
  String _activeSort = "";
  bool _reversed = false;

  get filters => _filters;
  get filteredRats => _filteredRats;
  get activeFilters => _activeFilters;
  get activeSort => _activeSort;
  get reversed => _reversed;

  setActiveFilters({required String filter}) {
    _activeFilters = filter;
    notifyListeners();
  }

  setActiveSort({required String sort}) {
    _activeSort = sort;
    notifyListeners();
  }

  setFilteredRats({required List<QueryDocumentSnapshot> rats}) {
    _filteredRats = rats;
    notifyListeners();
  }

  setReversed() {
    _reversed = !_reversed;
    notifyListeners();
  }
}
