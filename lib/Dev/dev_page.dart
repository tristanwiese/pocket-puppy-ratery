import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';

class DevPage extends StatefulWidget {
  const DevPage({super.key});

  @override
  State<DevPage> createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: const Text("Please do not mess with things here!",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 40,
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  
                }, 
                style: MyElevatedButtonStyle.buttonStyle,
                child: const Text('Delete account'),),
            ),
              Container()
          ],
        ),
      ),
    );
  }
}