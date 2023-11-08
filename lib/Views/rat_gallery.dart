// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocket_puppy_rattery/Models/rat.dart';
import 'package:pocket_puppy_rattery/Services/custom_widgets.dart';
import 'package:pocket_puppy_rattery/providers/rats_provider.dart';
import 'package:provider/provider.dart';

class RatGallery extends StatefulWidget {
  const RatGallery({super.key});

  @override
  State<RatGallery> createState() => _RatGalleryState();
}

class _RatGalleryState extends State<RatGallery> {
  bool showload = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<RatsProvider>(builder: (context, value, child) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Gallery : ${value.rat.name}'),
          ),
          body: showload
              ? const Center(child: CircularProgressIndicator())
              : value.rat.photos == null || value.rat.photos!.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('No images'),
                          ElevatedButton(
                            onPressed: () async {
                              getImage(value);
                            },
                            style: MyElevatedButtonStyle.buttonStyle,
                            child: const Text('Add Image'),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            itemCount: value.rat.photos!.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        actions: [
                                          PopupMenuItem(
                                            child: const Text('Delete photo'),
                                            onTap: () async {
                                              final Rat rat = value.rat;

                                              final String name =
                                                  value.rat.photos![index];

                                              rat.photos!.removeAt(index);
                                              value.updateRat(rat);

                                              final deleteRef = FirebaseStorage
                                                  .instance
                                                  .refFromURL(name);

                                              deleteRef.delete();
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .collection('rats')
                                                  .doc(value.rat.id)
                                                  .update({
                                                'photos':
                                                    FieldValue.arrayRemove(
                                                        [name])
                                              });
                                            },
                                          ),
                                          PopupMenuItem(
                                            child: const Text(
                                                'Set as profile photo'),
                                            onTap: () {
                                              final Rat rat = value.rat;
                                              rat.profilePic =
                                                  value.rat.photos![index];
                                              value.updateRat(rat);

                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .collection('rats')
                                                  .doc(rat.id)
                                                  .update({
                                                'profilePic':
                                                    value.rat.photos![index]
                                              });
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: value.rat.photos![index] is String
                                    ? Image.network(
                                        value.rat.photos![index],
                                        fit: BoxFit.contain,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return const Center(
                                            child: Icon(Icons.image),
                                          );
                                        },
                                      )
                                    : const Icon(Icons.image),
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                getImage(value);
                              },
                              style: MyElevatedButtonStyle.buttonStyle,
                              child: const Text('Add Image'),
                            ),
                          ],
                        )
                      ],
                    ));
    });
  }

  void getImage(value) async {
    setState(() {
      showload = true;
    });
    final List<XFile> images = await ImagePicker().pickMultiImage();

    if (images.isNotEmpty) {
      final Rat rat = value.rat;
      storeImage(rat: rat, images: images, value: value);
    }
  }

  void storeImage(
      {required Rat rat,
      required List<XFile> images,
      required RatsProvider value}) async {
    final store = FirebaseStorage.instance.ref();

    images.forEach((image) async {
      final storeChild = store.child(
          "${FirebaseAuth.instance.currentUser!.uid}/rats/${rat.id}/${image.name}");
      try {
        await storeChild.putFile(File(image.path));
        final String url = await storeChild.getDownloadURL();
        rat.photos!.add(url);
        value.updateRat(rat);
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('rats')
            .doc(rat.id)
            .update({
          'photos': FieldValue.arrayUnion([url])
        });
        setState(() {
          showload = false;
        });
      } on FirebaseException catch (e) {
        print(e);
      }
    });
  }
}
