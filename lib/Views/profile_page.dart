// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocket_puppy_rattery/Models/user.dart';
import 'package:pocket_puppy_rattery/Services/profile_provider.dart';
import 'package:provider/provider.dart';
import '../Services/custom_widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadScreen();
            }
            return myBody(snapshot);
          },
        ));
  }

  myBody(AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
    final UserModel user = UserModel.fromDB(dbUser: snapshot.data!);
    return Center(
      child: Consumer<ProfileProvider>(builder: (context, value, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
                radius: 70,
                backgroundColor: const Color.fromARGB(255, 211, 211, 211),
                backgroundImage: value.profilePicture != null
                    ? kIsWeb
                        ? Image.network(
                            File(value.profilePicture.path).path,
                            fit: BoxFit.contain,
                          ).image
                        : Image.file(
                            File(value.profilePicture.path),
                            fit: BoxFit.contain,
                          ).image
                    : value.user.profilePicUrl != ''
                        ? Image.network(value.user.profilePicUrl).image
                        : null,
                child: value.profilePicture == null &&
                        value.user.profilePicUrl == ''
                    ? const Icon(
                        Icons.person_outline_rounded,
                        size: 100,
                        color: Colors.black,
                      )
                    : null),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                final XFile? image =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (image != null) {
                  value.updateProfilePicture(profilePic: image);
                  await storeProfilePic(image: image);
                }
              },
              style: MyElevatedButtonStyle.buttonStyle,
              child: const Text("Upload Image"),
            ),
            const SizedBox(height: 30),
            Text("Username: ${user.userName}"),
            Text("Email: ${user.email}")
          ],
        );
      }),
    );
  }

  getProfilePic() async {
    final store = FirebaseStorage.instance.ref();
    final imageUrl = await store
        .child("${FirebaseAuth.instance.currentUser!.uid}/profile.jpg")
        .getDownloadURL();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'profilePicUrl': imageUrl});
  }

  storeProfilePic({required XFile image}) async {
    final store = FirebaseStorage.instance.ref();
    final storeChild =
        store.child("${FirebaseAuth.instance.currentUser!.uid}/profile.jpg");
    try {
      await storeChild.putFile(File(image.path));
      getProfilePic();
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
