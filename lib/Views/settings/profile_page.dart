// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocket_puppy_rattery/Functions/nav.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';
import 'package:pocket_puppy_rattery/Models/user.dart';
import 'package:pocket_puppy_rattery/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import '../../Services/custom_widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        radius: 50,
                        backgroundColor:
                            const Color.fromARGB(255, 211, 211, 211),
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
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width - 116,
                        maxHeight: 100,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(color: Colors.black),
                                children: [
                                  const TextSpan(
                                    text: 'Username: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(text: user.userName),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Flexible(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'Email: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: user.email,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  editUsername(context, user),
                  const SizedBox(height: 10),
                  editEmail(context),
                  const SizedBox(height: 10),
                  editProfilePic(value),
                  const SizedBox(height: 10),
                  signOut(),
                ],
              )
            ],
          ),
        );
      }),
    );
  }

  Row editProfilePic(ProfileProvider value) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final XFile? image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    value.updateProfilePicture(profilePic: image);
                    await storeProfilePic(image: image);
                  }
                },
                style: MyElevatedButtonStyle.buttonStyle,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Profile Picture',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Icon(Icons.add_a_photo_outlined),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row signOut() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  popUntil(
                    context: context,
                    callback: (Route<dynamic> route) => route.isFirst,
                  );
                },
                style: MyElevatedButtonStyle.buttonStyle,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'SignOut',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Icon(
                      Icons.logout,
                      color: Colors.red[300],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row editEmail(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final TextEditingController emailController =
                      TextEditingController();
                  showDialog(
                    context: context,
                    builder: (context) {
                      bool isDone = false;

                      return StatefulBuilder(builder: (context, setstate) {
                        return AlertDialog(
                          title: const Text("Enter new Email"),
                          content: Form(
                            key: _formKey,
                            child: !isDone
                                ? TextFormField(
                                    controller: emailController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'required';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        hintText: "Email"),
                                  )
                                : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          style: const TextStyle(fontSize: 20),
                                          children: [
                                            const TextSpan(
                                                text:
                                                    'Are you sure you want to change your email to '),
                                            TextSpan(
                                              text: emailController.text.trim(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const TextSpan(text: '?'),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                          'It will require you to login in again and verify your new email'),
                                    ],
                                  ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                navPop(context);
                              },
                              style: MyElevatedButtonStyle.doneButtonStyle,
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: isDone
                                  ? () async {
                                      try {
                                        showDialog(
                                          context: context,
                                          builder: (context) => const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                        await FirebaseAuth.instance.currentUser!
                                            .updateEmail(
                                                emailController.text.trim());

                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(FirebaseAuth
                                                .instance.currentUser!.uid)
                                            .update(
                                          {
                                            'email': emailController.text.trim()
                                          },
                                        );
                                        await FirebaseAuth.instance.signOut();
                                        popUntil(
                                          context: context,
                                          callback: (Route<dynamic> route) =>
                                              route.isFirst,
                                        );
                                      } on FirebaseAuthException catch (e) {
                                        if (e.code == 'email-already-in-use') {
                                          navPop(context);
                                          navPop(context);

                                          alert(text: 'Email already exists');
                                        }
                                        if (e.code == 'requires-recent-login') {
                                          navPop(context);
                                          navPop(context);

                                          alert(
                                            text:
                                                'Something went wrong. Please re-login to proceed',
                                          );
                                        }
                                      }
                                    }
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        setstate(() {
                                          isDone = true;
                                        });
                                      }
                                    },
                              style: MyElevatedButtonStyle.buttonStyle,
                              child: const Text('Submit'),
                            )
                          ],
                        );
                      });
                    },
                  );
                },
                style: MyElevatedButtonStyle.buttonStyle,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Email',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Icon(
                      Icons.edit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row editUsername(BuildContext context, UserModel user) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final TextEditingController usernameController =
                      TextEditingController();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Enter new Username"),
                        content: Form(
                          key: _formKey,
                          child: TextFormField(
                            controller: usernameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'required';
                              }
                              return null;
                            },
                            decoration:
                                const InputDecoration(hintText: "Username"),
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              navPop(context);
                            },
                            style: MyElevatedButtonStyle.doneButtonStyle,
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                user.userName = usernameController.text.trim();
                                setState(() {});
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .update({
                                  'userName': usernameController.text.trim()
                                });
                                navPop(context);
                              }
                            },
                            style: MyElevatedButtonStyle.buttonStyle,
                            child: const Text('Done'),
                          )
                        ],
                      );
                    },
                  );
                },
                style: MyElevatedButtonStyle.buttonStyle,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Username',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    Icon(
                      Icons.edit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
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
      kIsWeb
          ? await storeChild.putData(await image.readAsBytes())
          : await storeChild.putFile(File(image.path));
      getProfilePic();
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
