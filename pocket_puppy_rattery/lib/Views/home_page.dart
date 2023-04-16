import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      appBar: myAppBar(context),
      floatingActionButton: myFloatingActionButton(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const[BottomNavigationBarItem(icon: Icon(Icons.details_outlined), label: 'Details'), BottomNavigationBarItem(icon: Icon(Icons.logout_outlined), label: 'Logout')]),
      body: Center(child: myBody()),
    );
  }

  myBody() => ConstrainedBox(
    constraints: BoxConstraints(maxWidth:  MediaQuery.of(context).size.width / 3),
    child: ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, i) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text('Rat ${i + 1}'),
          shape: const BeveledRectangleBorder(side: BorderSide(width: 1), borderRadius: BorderRadius.all(Radius.circular(15))),
          contentPadding: const EdgeInsets.all(10),
        ),
      );
      }
      ),
  );

  FloatingActionButton myFloatingActionButton() => FloatingActionButton(
    onPressed: (){

    },
    tooltip: "Add Rat",
    child: const Icon(Icons.add),
    );
  myAppBar (BuildContext context){
    return AppBar(

    );
  }
}