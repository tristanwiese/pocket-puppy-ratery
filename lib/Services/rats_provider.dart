import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RatsProvider extends ChangeNotifier {
  RatsProvider({
    required List<QueryDocumentSnapshot> rats,
  }) : _rats = rats;

  final List<QueryDocumentSnapshot> _rats;

  List<QueryDocumentSnapshot> get getRats => _rats;
}
