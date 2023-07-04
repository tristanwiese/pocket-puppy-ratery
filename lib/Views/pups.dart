import 'package:flutter/material.dart';

class Pups extends StatefulWidget {
  const Pups({super.key});

  @override
  State<Pups> createState() => _PupsState();
}

class _PupsState extends State<Pups> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pups"),
      ),
      body: body(),
    );
  }

  Widget body() {
    return const Center(
      child: Text("Pups"),
    );
  }
}
