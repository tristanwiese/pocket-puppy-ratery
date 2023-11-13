import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

Future<bool> deletePupMedia({required String reference}) async {
  final ref = FirebaseStorage.instance.ref();
  final deleteRef =
      ref.child('${FirebaseAuth.instance.currentUser!.uid}/pups/$reference');
  try {
    await deleteRef.delete();
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> deleteRatMedia({required String reference}) async {
  final ref = FirebaseStorage.instance.ref();
  final deleteRef =
      ref.child('${FirebaseAuth.instance.currentUser!.uid}/rats/$reference');
  try {
    await deleteRef.delete();
    return true;
  } catch (e) {
    return false;
  }
}
