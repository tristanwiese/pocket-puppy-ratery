import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Views/home_page.dart';

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
        stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            return const LoadScreen();
          }
          return myBody(snapshot);
        },
      )
    );
  }
  myBody(AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot){
    final userData = snapshot.data!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Username: ${userData["userName"]}"),
          Text("Email: ${userData["email"]}")
        ],
      ),
    );
  }
}