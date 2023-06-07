// ignore_for_file: use_build_context_synchronously, unused_import

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Functions/nav.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';
import 'package:pocket_puppy_rattery/Models/genes.dart';
import 'package:pocket_puppy_rattery/Models/rat.dart';
import 'package:pocket_puppy_rattery/Views/add_rat.dart';
import 'package:pocket_puppy_rattery/Views/rat_info.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int bottomVanIndex = 1;
  List<String>? result;
  Map<String, int>? resultPercentage;
  String geneCalChosenRat1Name = "Rat 1";
  String geneCalChosenRat2Name = "Rat 2";
  List<Map<String, dynamic>> chosenRats = [
    {"Rat": null, "Position": ""},
    {"Rat": null, "Position": ""}
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("asstes/images/Paws.jpg"))),
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('rats').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<QueryDocumentSnapshot<Object?>> rats =
                  snapshot.data!.docs;
              return Center(child: myBody(rats));
            }
            return const LoadScreen();
          }),
    );
  }

  myBody(List<QueryDocumentSnapshot<Object?>> rats) => Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      appBar: myAppBar(context),
      floatingActionButton: myFloatingActionButton(),
      bottomNavigationBar: myBottomNavBar(),
      body: rats.isEmpty
          ? const NoRatScreen()
          : bottomVanIndex == 0
              ? Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: getSize()),
                    child: ListView.builder(
                        itemCount: rats.length,
                        itemBuilder: (BuildContext context, i) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                QueryDocumentSnapshot rat = rats[i];
                                navPush(context, RatInfo(info: rat));
                              },
                              child: ListTile(
                                trailing: myIconButton(rat: rats[i]),
                                title: Text(rats[i]['name']),
                                shape: BeveledRectangleBorder(
                                    side: BorderSide(
                                        width: 1, color: secondaryThemeColor),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15))),
                                contentPadding: const EdgeInsets.all(10),
                              ),
                            ),
                          );
                        }),
                  ),
                )
              : geneCal(rats));

  Widget geneCal(List<QueryDocumentSnapshot<Object?>> rats) {
    //test rat list with implementing genes
    List ratsWithGenes = [
      RatGenes(genes: Gene(alleleA: "L", alleleB: "l"), name: "Alice"),
      RatGenes(genes: Gene(alleleA: "L", alleleB: "L"), name: "Charlie"),
      RatGenes(genes: Gene(alleleA: "l", alleleB: "l"), name: "Bob"),
      RatGenes(genes: Gene(alleleA: "L", alleleB: "-"), name: "Andrew"),
    ];
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Select 2 Rats to see what the possible outcomes of their babies",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text(
            "//TEST DATA//",
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(100, 40),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)))),
            onPressed: () {
              availableRatList(
                  title: "Choose Rat 1",
                  buildList: ratsWithGenes,
                  activeListPosition: 0);
            },
            child: Text(geneCalChosenRat1Name),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(100, 40),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)))),
            onPressed: () {
              availableRatList(
                  title: "Choose Rat 2",
                  buildList: ratsWithGenes,
                  activeListPosition: 1);
            },
            child: Text(geneCalChosenRat2Name),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: const Size(100, 40),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)))),
              onPressed: () {
                for (Map map in chosenRats) {
                  if (map["Rat"] == null) {
                    scaffoldKey.currentState!.showSnackBar(SnackBar(
                      content: const Text("Choose 2 rats to match!"),
                      duration: const Duration(seconds: 4),
                      backgroundColor: primaryThemeColor,
                    ));
                    return;
                  }
                }
                setState(() {
                  result = matchRats(
                      rat1: chosenRats[0]["Rat"], rat2: chosenRats[1]["Rat"]);
                  resultPercentage = getPercentage(pairResults: result!);
                });
              },
              child: const Text("Match")),
          const SizedBox(height: 20),
          Text("Outcome: ${result ?? ""}"),
          Text("Percentage: ${resultPercentage ?? ""}")
        ],
      ),
    );
  }

  Widget myBottomNavBar() {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: bottomVanIndex,
        onTap: (index) {
          setState(() {
            bottomVanIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.line_style_outlined), label: 'Rats'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calculate_outlined), label: 'Gene Calculator')
        ]);
  }

  IconButton myIconButton({required QueryDocumentSnapshot rat}) => IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Warning"),
              content: SizedBox(
                height: 100,
                child: Column(
                  children: [
                    const Text("Are you sure you want to remove this rat?"),
                    const SizedBox(height: 30),
                    Text(
                      rat["name"],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => navPop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => deleteRat(rat.id),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Delete"),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            );
          },
        );
      },
      icon: Icon(Icons.delete, color: Colors.red[200]));

  deleteRat(String name) async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    await FirebaseFirestore.instance.collection('rats').doc(name).delete();
    navPop(context);
    navPop(context);
  }

  FloatingActionButton myFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => navPush(context, const AddRat()),
      tooltip: "Add Rat",
      backgroundColor: secondaryThemeColor,
      child: const Icon(Icons.add),
    );
  }

  AppBar myAppBar(BuildContext context) {
    return AppBar(
      title: const Center(child: Text('Your Rats')),
    );
  }

  double getSize() {
    if (MediaQuery.of(context).size.width < 435) {
      return MediaQuery.of(context).size.width / 1.5;
    } else {
      return MediaQuery.of(context).size.width / 2;
    }
  }

  availableRatList({
    required String title,
    required List buildList,
    required int activeListPosition,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(title),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    navPop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(100, 40),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)))),
                  child: const Text("Done"),
                ),
              )
            ],
            content: SizedBox(
              height: 400,
              width: MediaQuery.of(context).size.width / 1.2,
              child: ListView.builder(
                itemCount: buildList.length,
                itemBuilder: (context, index) {
                  bool isActive = false;
                  String text = '';
                  for (Map map in chosenRats) {
                    if (map["Rat"] != null) {
                      if (map["Rat"].name == buildList[index].name) {
                        isActive = true;
                        text = map["Position"];
                      }
                    }
                  }
                  return Padding(
                    padding: const EdgeInsets.all(7),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                          title: Center(
                              child: Text(
                                  "${buildList[index].name}:  ${buildList[index].geneList()}")),
                          trailing: SizedBox(
                            height: 10,
                            width: 50,
                            child: isActive
                                ? Row(
                                    children: [
                                      const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                      Text(
                                        text,
                                        style: const TextStyle(fontSize: 10),
                                      )
                                    ],
                                  )
                                : Container(),
                          ),
                          onTap: () {
                            for (Map map in chosenRats) {
                              if (map["Rat"] == buildList[index]) {
                                return;
                              }
                            }
                            changeRatName(
                                buildList[index].name, activeListPosition);
                            chosenRats[activeListPosition]["Rat"] =
                                buildList[index];
                            chosenRats[activeListPosition]["Position"] =
                                (activeListPosition == 0) ? "Rat 1" : "Rat 2";
                            setState(() {});
                          }),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void changeRatName(name, int activeListPosition) {
    (activeListPosition == 0)
        ? geneCalChosenRat1Name = name
        : geneCalChosenRat2Name = name;
    setState(() {});
  }
}

class LoadScreen extends StatefulWidget {
  const LoadScreen({super.key});

  @override
  State<LoadScreen> createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  dynamic home;

  @override
  void initState() {
    super.initState;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );

    createHome();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  createHome() {
    _controller.forward();
    home = Scaffold(
      body: Center(
          child: Column(
        children: [
          RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
              child: Image.asset('asstes/images/image.png', height: 500)),
          const SizedBox(height: 10),
          const Text(
            'Getting the Ratties out of their cages!',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return home;
  }
}

class NoRatScreen extends StatelessWidget {
  const NoRatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        // Todo: Add Image Asset
        Image.asset(
          "asstes/images/Rat.png",
          height: 400,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image),
        ),
        const Text(
          'Oh, no! We will have to get you some rats!',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ]),
    );
  }
}
