import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateUserModel extends StatefulWidget {
  const UpdateUserModel({super.key});

  @override
  State<UpdateUserModel> createState() => _UpdateUserModelState();
}

class _UpdateUserModelState extends State<UpdateUserModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              FirebaseFirestore store = FirebaseFirestore.instance;

              store.collection('users').get().then((users) => {
                    users.docs.forEach((user) {
                      store
                          .collection('users')
                          .doc(user.id)
                          .update({'role': 'user'});
                    }),
                    print('done')
                  });
            },
            child: const Text('Update')),
      ),
    );
  }
}
