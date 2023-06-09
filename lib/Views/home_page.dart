// ignore_for_file: use_build_context_synchronously, unused_import

import 'dart:developer';

import 'package:age_calculator/age_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/main.dart';
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
  final PageController _pageController = PageController(initialPage: 0);

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  late List<QueryDocumentSnapshot<Object?>> rats;

  int bottomVanIndex = 0;

  List<String>? result;
  Map<String, int>? resultPercentage;
  String geneCalChosenRat1Name = "Rat 1";
  String geneCalChosenRat2Name = "Rat 2";
  List<Map<String, dynamic>> chosenRats = [
    {"Rat": null, "Position": ""},
    {"Rat": null, "Position": ""}
  ];

  List<String> filters = ["Gender"];
  List<QueryDocumentSnapshot> filteredRats = [];
  String activeFilters = "";

  String appBarTitle = "Your Rats";

  mySetState() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("asstes/images/Paws.jpg"))),
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('rats').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              rats = snapshot.data!.docs;
              return myBody(rats);
            }

            return const LoadScreen();
          }),
    );
  }

  myBody(List<QueryDocumentSnapshot<Object?>> rats) => Scaffold(
      key: _key,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      appBar: myAppBar(context),
      endDrawer: SafeArea(
        child: myDrawer(),
      ),
      floatingActionButton: null, //myFloatingActionButton(),
      bottomNavigationBar: myBottomNavBar(),
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) => setState(() {
          bottomVanIndex = value;
          switch (value) {
            case 0:
              appBarTitle = "Your Rats";
              break;
            case 1:
              appBarTitle = "Gene Callculator";
              break;
            default:
              appBarTitle = "Breeding Tracker";
          }
        }),
        children: [ratPage(), geneCal(rats), breedTracker()],
      ));

  Widget ratPage() {
    return Center(
      child: Column(
        children: [
          rats.isEmpty
              ? const Expanded(child: NoRatScreen())
              : Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: getSize()),
                    child: ListView.builder(
                        itemCount: activeFilters.isEmpty
                            ? rats.length
                            : filteredRats.length,
                        itemBuilder: (BuildContext context, i) {
                          final buildItem =
                              activeFilters.isEmpty ? rats : filteredRats;
                          DateTime birthdate = DateTime(
                              buildItem[i]["birthday"][0],
                              buildItem[i]["birthday"][1],
                              buildItem[i]["birthday"][2]);
                          Color? colorCode;
                          switch (buildItem[i]["colorCode"]) {
                            case "green":
                              colorCode = Colors.green;
                            case "blue":
                              colorCode = Colors.blue;
                            case "red":
                              colorCode = Colors.red;
                          }
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return colorCodePicker(i);
                                  },
                                );
                              },
                              onTap: () {
                                QueryDocumentSnapshot rat =
                                    activeFilters.isEmpty
                                        ? rats[i]
                                        : filteredRats[i];
                                navPush(context, RatInfo(info: rat));
                              },
                              child: Card(
                                elevation: 10,
                                shadowColor: Colors.black,
                                shape: BeveledRectangleBorder(
                                    side: BorderSide(
                                        width: 1, color: secondaryThemeColor),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15))),
                                color: (AgeCalculator.age(birthdate).years >= 3)
                                    ? primaryThemeColor
                                    : null,
                                child: ListTile(
                                  leading: Icon(
                                    Icons.square,
                                    color: colorCode,
                                  ),
                                  trailing: myIconButton(rat: buildItem[i]),
                                  title: Text(buildItem[i]['name']),
                                  subtitle: Text(buildItem[i]['gender']),
                                  contentPadding: const EdgeInsets.all(10),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [ 
              Container(
                height: 35,
                margin: const EdgeInsets.only(bottom: 10),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: ElevatedButton.icon(
                    label: const Text("Add Rat",
                        style: TextStyle(color: Colors.black87)),
                    icon: Icon(
                      Icons.add,
                      color: secondaryThemeColor,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: secondaryThemeColor),
                      ),
                    ),
                    onPressed: () => navPush(context, const AddRat()),
                  ),
                ),
              ),
              Container(
                  height: 35,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                        label: const Text("Filter",
                            style: TextStyle(color: Colors.black87)),
                        icon:
                            Icon(Icons.filter_list, color: secondaryThemeColor),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: secondaryThemeColor),
                          ),
                        ),
                        onPressed: () {
                          _key.currentState!.openEndDrawer();
                        }),
                  )),
            ],
          )
        ],
      ),
    );
  }

  AlertDialog colorCodePicker(int i) {
    return AlertDialog(
      title: const Text("Organise"),
      actions: [
        Center(
          child: ElevatedButton(
              style: MyElevatedButtonStyle.doneButtonStyle,
              onPressed: () => navPop(context),
              child: const Text("Done")),
        )
      ],
      content: Column(
        children: [
          ListTile(
            title: const Text("Red"),
            leading: const Icon(
              Icons.square,
              color: Colors.red,
            ),
            onTap: () {
              QueryDocumentSnapshot rat =
                  activeFilters.isEmpty ? rats[i] : filteredRats[i];
              FirebaseFirestore.instance
                  .collection("rats")
                  .doc(rat.id)
                  .update({"colorCode": "red"});
              setState(() {});
              navPop(context);
            },
            shape: RoundedRectangleBorder(
                side: const BorderSide(),
                borderRadius: BorderRadius.circular(10)),
          ),
          const SizedBox(height: 10),
          ListTile(
            title: const Text("Blue"),
            leading: const Icon(
              Icons.square,
              color: Colors.blue,
            ),
            onTap: () {
              QueryDocumentSnapshot rat =
                  activeFilters.isEmpty ? rats[i] : filteredRats[i];
              FirebaseFirestore.instance
                  .collection("rats")
                  .doc(rat.id)
                  .update({"colorCode": "blue"});
              setState(() {});
              navPop(context);
            },
            shape: RoundedRectangleBorder(
                side: const BorderSide(),
                borderRadius: BorderRadius.circular(10)),
          ),
          const SizedBox(height: 10),
          ListTile(
            title: const Text("Green"),
            leading: const Icon(
              Icons.square,
              color: Colors.green,
            ),
            onTap: () {
              QueryDocumentSnapshot rat =
                  activeFilters.isEmpty ? rats[i] : filteredRats[i];
              FirebaseFirestore.instance
                  .collection("rats")
                  .doc(rat.id)
                  .update({"colorCode": "green"});
              setState(() {});
              navPop(context);
            },
            shape: RoundedRectangleBorder(
                side: const BorderSide(),
                borderRadius: BorderRadius.circular(10)),
          ),
          const SizedBox(height: 10),
          ListTile(
            title: const Text("None"),
            leading: const Icon(
              Icons.square,
            ),
            onTap: () {
              QueryDocumentSnapshot rat =
                  activeFilters.isEmpty ? rats[i] : filteredRats[i];
              FirebaseFirestore.instance
                  .collection("rats")
                  .doc(rat.id)
                  .update({"colorCode": "none"});
              setState(() {});
              navPop(context);
            },
            shape: RoundedRectangleBorder(
                side: const BorderSide(),
                borderRadius: BorderRadius.circular(10)),
          )
        ],
      ),
    );
  }

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
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 40,
                  child: ElevatedButton(
                    style: MyElevatedButtonStyle.buttonStyle,
                    onPressed: () {
                      availableRatList(
                          title: "Choose Rat 1",
                          buildList: ratsWithGenes,
                          activeListPosition: 0);
                    },
                    child: Text(
                      geneCalChosenRat1Name,
                      style: MyElevatedButtonStyle.textStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      style: MyElevatedButtonStyle.buttonStyle,
                      onPressed: () {
                        availableRatList(
                            title: "Choose Rat 2",
                            buildList: ratsWithGenes,
                            activeListPosition: 1);
                      },
                      child: Text(
                        geneCalChosenRat2Name,
                        style: MyElevatedButtonStyle.textStyle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 40,
                  child: ElevatedButton(
                      style: MyElevatedButtonStyle.buttonStyle,
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
                              rat1: chosenRats[0]["Rat"],
                              rat2: chosenRats[1]["Rat"]);
                          resultPercentage =
                              getPercentage(pairResults: result!);
                        });
                      },
                      child: const Text(
                        "Match",
                        style: MyElevatedButtonStyle.textStyle,
                      )),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text("Outcome: ${result ?? ""}"),
          Text("Percentage: ${resultPercentage ?? ""}")
        ],
      ),
    );
  }

  Widget breedTracker() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text("Breed Tracker")],
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
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 700),
                curve: Curves.decelerate);
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.line_style_outlined), label: 'Rats'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calculate_outlined), label: 'Gene Calculator'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bed_rounded), label: "Breeding Tracker")
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
                height: 150,
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

  AppBar myAppBar(BuildContext context) {
    AppBar appBar = AppBar();

    switch (bottomVanIndex) {
      case 0:
        appBar = ratScreenAppBar();
        break;
      case 1:
        appBar = geneCalAppBar();
        break;
      case 2:
        appBar = breedTrackerAppBar();
        break;
    }
    return appBar;
  }

  ratScreenAppBar() {
    return AppBar(
      actions: [Container()],
      title: Center(
          child:
              Text((rats.isEmpty) ? "Your Rats" : "Your Rats: ${rats.length}")),
    );
  }

  breedTrackerAppBar() {
    return AppBar(
      actions: [Container()],
      title: const Center(child: Text("Breed Tracker")),
    );
  }

  geneCalAppBar() {
    return AppBar(
      actions: [Container()],
      title: const Center(child: Text("Gene Calculator")),
    );
  }

  FloatingActionButton myFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () => navPush(context, const AddRat()),
      tooltip: "Add Rat",
      backgroundColor: secondaryThemeColor,
      child: const Icon(Icons.add),
    );
  }

  myDrawer() {
    return Drawer(
      width: 200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text("Gender"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (activeFilters == "Female") {
                      activeFilters = "";
                      setState(() {
                        activeFilters = "";
                      });
                      return;
                    }
                    activeFilters = "Female";
                    filterRats(filter: "Female");
                    setState(() {});
                  },
                  style: (activeFilters != "Female")
                      ? MyElevatedButtonStyle.buttonStyle
                      : MyElevatedButtonStyle.activeButtonStyle,
                  child: const Text(
                    "Female",
                    style: MyElevatedButtonStyle.textStyle,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (activeFilters == "Male") {
                      setState(() {
                        activeFilters = "";
                      });
                      return;
                    }
                    activeFilters = "Male";
                    filterRats(filter: "Male");
                    setState(() {});
                  },
                  style: (activeFilters != "Male")
                      ? MyElevatedButtonStyle.buttonStyle
                      : MyElevatedButtonStyle.activeButtonStyle,
                  child: const Text(
                    "Male",
                    style: MyElevatedButtonStyle.textStyle,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
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
                  style: MyElevatedButtonStyle.doneButtonStyle,
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

  filterRats({required String filter}) {
    filteredRats = rats.where((rat) => rat["gender"] == filter).toList();
  }

  double getSize() {
    if (MediaQuery.of(context).size.width < 435) {
      return MediaQuery.of(context).size.width / 1.5;
    } else {
      return MediaQuery.of(context).size.width / 2;
    }
  }

  deleteRat(String name) async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    await FirebaseFirestore.instance.collection('rats').doc(name).delete();
    navPop(context);
    navPop(context);
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
              child: Image.asset('asstes/images/Image.png', height: 500)),
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
