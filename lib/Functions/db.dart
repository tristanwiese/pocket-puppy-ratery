import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

bool checkDBScheme({required String db, required String key}) {
  return db.contains(key);
}

void createFieldRats(
    {required bool boolean,
    required String key,
    required dynamic data,
    required buildItem}) {
  if (!boolean) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("rats")
        .doc(buildItem.id)
        .update({key: data});
  }
}

void createFieldPups(
    {required bool boolean,
    required String key,
    required dynamic data,
    required String breedID,
    required buildItem}) {
  if (!boolean) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("breedingSchemes")
        .doc(breedID)
        .collection('pups')
        .doc(buildItem.id)
        .update({key: data});
  }
}
