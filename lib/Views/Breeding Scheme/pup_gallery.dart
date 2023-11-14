import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pocket_puppy_rattery/Models/pup_model.dart';
import 'package:pocket_puppy_rattery/Services/custom_widgets.dart';
import 'package:pocket_puppy_rattery/providers/breeding_scheme_provider.dart';
import 'package:pocket_puppy_rattery/providers/pups_provider.dart';
import 'package:provider/provider.dart';

class PupGallery extends StatefulWidget {
  const PupGallery({super.key});

  @override
  State<PupGallery> createState() => _PupGalleryState();
}

class _PupGalleryState extends State<PupGallery> {
  bool showload = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<PupsProvider>(builder: (context, value, child) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Gallery : ${value.pup.name}'),
          ),
          body: showload
              ? const Center(child: CircularProgressIndicator())
              : value.pup.photos.isEmpty
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
                            itemCount: value.pup.photos.length,
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
                                              final Pup pup = value.pup;

                                              final String name =
                                                  value.pup.photos[index];

                                              pup.photos.removeAt(index);
                                              value.updatePup(pup: pup);

                                              final deleteRef = FirebaseStorage
                                                  .instance
                                                  .refFromURL(name);

                                              deleteRef.delete();

                                              final BreedingSchemeProvider
                                                  breedProv = Provider.of<
                                                          BreedingSchemeProvider>(
                                                      context,
                                                      listen: false);

                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .collection('breedingSchemes')
                                                  .doc(breedProv.getScheme.id)
                                                  .collection('pups')
                                                  .doc(pup.id)
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
                                              final String name =
                                                  value.pup.photos[index];

                                              final Pup pup = value.pup;

                                              pup.profilePic = name;

                                              value.updatePup(pup: pup);

                                              final BreedingSchemeProvider
                                                  breedProv = Provider.of<
                                                          BreedingSchemeProvider>(
                                                      context,
                                                      listen: false);

                                              FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser!.uid)
                                                  .collection('breedingSchemes')
                                                  .doc(breedProv.getScheme.id)
                                                  .collection('pups')
                                                  .doc(pup.id)
                                                  .update(
                                                      {'profilePicture': name});
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: value.pup.photos[index] is String
                                    ? Image.network(
                                        value.pup.photos[index],
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
      final Pup pup = value.pup!;
      storeImage(pup: pup, images: images, value: value);
    }
  }

  void storeImage({
    required Pup pup,
    required List<XFile> images,
    required PupsProvider value,
  }) async {
    final BreedingSchemeProvider breedProv =
        Provider.of<BreedingSchemeProvider>(context, listen: false);
    final store = FirebaseStorage.instance.ref();

    // ignore: avoid_function_literals_in_foreach_calls
    images.forEach((image) async {
      final storeChild = store.child(
          "${FirebaseAuth.instance.currentUser!.uid}/pups/${pup.id}/${image.name}");
      try {
        final data = await image.readAsBytes();
        kIsWeb
            ? await storeChild.putData(data)
            : await storeChild.putFile(File(image.path));
        final String url = await storeChild.getDownloadURL();
        pup.photos.add(url);
        value.updatePup(pup: pup);

        setState(() {
          showload = false;
        });
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('breedingSchemes')
            .doc(breedProv.getScheme.id)
            .collection('pups')
            .doc(pup.id)
            .update({
          "photos": FieldValue.arrayUnion([url])
        });
      } on FirebaseException catch (e) {
        // ignore: avoid_print
        print(e);
      }
    });
  }
}
