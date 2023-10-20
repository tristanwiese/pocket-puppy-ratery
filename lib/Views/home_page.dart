// ignore_for_file: use_build_context_synchronously, unused_import

import 'dart:async';
import 'dart:developer';
import 'package:age_calculator/age_calculator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/main.dart';
import 'package:pocket_puppy_rattery/Functions/nav.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';
import 'package:pocket_puppy_rattery/Models/breeding_scheme_model.dart';
import 'package:pocket_puppy_rattery/Models/genes.dart';
import 'package:pocket_puppy_rattery/Models/rat.dart';
import 'package:pocket_puppy_rattery/Services/breeding_scheme_provider.dart';
import 'package:pocket_puppy_rattery/Services/constants.dart';
import 'package:pocket_puppy_rattery/Services/controller_provider.dart';
import 'package:pocket_puppy_rattery/Services/card_controller.dart';
import 'package:pocket_puppy_rattery/Services/custom_widgets.dart';
import 'package:pocket_puppy_rattery/Services/filter_provider.dart';
import 'package:pocket_puppy_rattery/Services/rats_provider.dart';
import 'package:pocket_puppy_rattery/Views/add_rat.dart';
import 'package:pocket_puppy_rattery/Views/Breeding%20Scheme/breeding_sheme_info_page.dart';
import 'package:pocket_puppy_rattery/Views/profile_page.dart';
import 'package:pocket_puppy_rattery/Views/rat_info.dart';
import 'package:pocket_puppy_rattery/Views/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Dev/dev_page.dart';
import 'package:provider/provider.dart';
import 'Breeding Scheme/breeding_scheme.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PageController _pageController = PageController();
  late ControllerProvider controllerProvider;

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

  String appBarTitle = "Your Rats";

  bool showLoad = false;

  late SharedPreferences prefs;

  late Timer timer;

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    getPrefs();

    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    controllerProvider =
        Provider.of<ControllerProvider>(context, listen: false);
    return showLoad
        ? const LoadScreen()
        : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection("rats")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                rats = snapshot.data!.docs;
                return myBody(rats, ctx);
              }

              return const LoadScreen();
            });
  }

  myBody(List<QueryDocumentSnapshot<Object?>> rats, BuildContext ctx) =>
      Scaffold(
          key: _key,
          appBar: myAppBar(context),
          drawer: myDrawer(),
          endDrawer: myEndDrawer(),
          bottomNavigationBar: myBottomNavBar(),
          body: PageView(
            controller: _pageController,
            onPageChanged: (value) {
              switch (value) {
                case 0:
                  appBarTitle = "Your Rats";
                  break;
                case 1:
                  appBarTitle = "Gene Calculator";
                  break;
                default:
                  appBarTitle = "Breeding Tracker";
              }
              controllerProvider.changeBottomNavIndex(index: value);
            },
            children: [ratPage(ctx), geneCal(rats), breedTracker()],
          ));

  Widget ratPage(BuildContext ctx) {
    return Center(
      child: Consumer<FilterProvider>(builder: (context, value, child) {
        return Column(
          children: [
            rats.isEmpty
                ? const Expanded(child: NoRatScreen())
                : (value.activeFilters.isNotEmpty && value.filteredRats.isEmpty)
                    ? const Expanded(
                        child: Center(
                          child: Text("No rats match current filters..."),
                        ),
                      )
                    : Expanded(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: getSize()),
                          child: ListView.builder(
                              itemCount: value.activeFilters.isEmpty
                                  ? rats.length
                                  : value.filteredRats.length,
                              itemBuilder: (BuildContext context, i) {
                                final QueryDocumentSnapshot buildItem =
                                    !value.activeFilters.isEmpty ||
                                            !value.activeSort.isEmpty
                                        ? value.filteredRats[i]
                                        : rats[i];
                                final Rat rat = Rat.fromDB(dbRat: buildItem);
                                DateTime birthdate = rat.birthday;
                                Color? colorCode;
                                switch (rat.colorCode) {
                                  case "green":
                                    colorCode = Colors.green[300];
                                  case "blue":
                                    colorCode = Colors.blue[300];
                                  case "red":
                                    colorCode = Colors.red[300];
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
                                      rat.id = buildItem.id;
                                      context.read<RatsProvider>().setRats(rat);
                                      navPush(context, Consumer<RatsProvider>(
                                        builder: (context, value, child) {
                                          return RatInfo(
                                              rat: value.rat, rats: rats);
                                        },
                                      ));
                                    },
                                    child: Consumer<CardController>(
                                        builder: (context, value, child) {
                                      value.setRat = rat;
                                      return Card(
                                        elevation: 3,
                                        shadowColor:
                                            (AgeCalculator.age(birthdate)
                                                        .years >=
                                                    3)
                                                ? value.state
                                                    ? Color(value.color)
                                                    : Colors.black
                                                : Colors.black,
                                        shape: const BeveledRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        color: (AgeCalculator.age(birthdate)
                                                    .years >=
                                                3)
                                            ? value.state
                                                ? Color(value.color)
                                                : null
                                            : null,
                                        child: ListTile(
                                          isThreeLine: true,
                                          leading: SizedBox(
                                            width: 70,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Icon(
                                                  Icons.square_rounded,
                                                  color: colorCode,
                                                ),
                                                Image.asset(
                                                  "asstes/images/logo.png",
                                                  width: 30,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      const Icon(Icons.image),
                                                )
                                              ],
                                            ),
                                          ),
                                          trailing: myIconButton(
                                              item: buildItem, itemType: "rat"),
                                          title: Text(rat.name),
                                          subtitle: Text("${rat.gender}"
                                              "\n"
                                              "Age: ${defaultAgeCalculator(birthdate)}"),
                                          contentPadding:
                                              const EdgeInsets.all(10),
                                        ),
                                      );
                                    }),
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
                          icon: Icon(Icons.filter_list,
                              color: secondaryThemeColor),
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
        );
      }),
    );
  }

  colorCodePicker(int i) {
    return AlertDialog(
      title: const Text("Organise"),
      actions: [
        Center(
          child: SizedBox(
            width: 80,
            height: 30,
            child: ElevatedButton(
                style: MyElevatedButtonStyle.buttonStyle,
                onPressed: () => navPop(context),
                child: const Text("Done")),
          ),
        )
      ],
      content: Consumer<FilterProvider>(builder: (context, value, child) {
        return SizedBox(
          height: 300,
          child: Column(
            children: [
              ListTile(
                title: const Text("Red"),
                leading: const Icon(
                  Icons.square,
                  color: Colors.red,
                ),
                onTap: () {
                  QueryDocumentSnapshot rat = value.activeFilters.isEmpty
                      ? rats[i]
                      : value.filteredRats[i];
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
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
                  QueryDocumentSnapshot rat = value.activeFilters.isEmpty
                      ? rats[i]
                      : value.filteredRats[i];
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
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
                  QueryDocumentSnapshot rat = value.activeFilters.isEmpty
                      ? rats[i]
                      : value.filteredRats[i];
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
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
                  QueryDocumentSnapshot rat = value.activeFilters.isEmpty
                      ? rats[i]
                      : value.filteredRats[i];
                  FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
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
      }),
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
            "Select 2 Rats to see the possible outcomes of their babies",
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
                            alert(text: "Choose 2 rats to match!", duration: 4);
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

  // Widget test() {
  //   return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
  //       stream: FirebaseFirestore.instance
  //           .collection("users")
  //           .doc(FirebaseAuth.instance.currentUser!.uid)
  //           // .collection("breedingSchemes")
  //           .snapshots(),
  //       builder: (context, snapshot) {
  //         if (!snapshot.hasData) {
  //           return const Center(
  //             child: Text(
  //               "Fethcing Schemes..",
  //               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //             ),
  //           );
  //         } else {
  //           print(snapshot.data!.data());
  //           return Container();
  //         }
  //       });
  // }

  Widget breedTracker() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("breedingSchemes")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: Text(
              "Fethcing Schemes..",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          );
        } else {
          final schemes = snapshot.data!.docs;
          return Column(
            children: [
              schemes.isEmpty
                  ? const Expanded(
                      child: Center(
                        child: Text("No Shemes"),
                      ),
                    )
                  : Expanded(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: getSize()),
                        child: ListView.builder(
                          itemCount: schemes.length,
                          itemBuilder: (context, index) {
                            final scheme = schemes[index];
                            dynamic male;
                            dynamic female;
                            if (!scheme['isCustomRats']) {
                              male = List.from(rats.where(
                                  (element) => element.id == scheme['male']));
                              male = male[0].data()['name'];
                              female = List.from(rats.where(
                                  (element) => element.id == scheme['female']));
                              female = female[0].data()['name'];
                            } else {
                              male = scheme["male"];
                              female = scheme["female"];
                            }
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 3,
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  // side: BorderSide(color: secondaryThemeColor),
                                ),
                                child: ListTile(
                                  title: Text(scheme['isCustomRats']
                                      ? scheme['name'] + " (custom rats)"
                                      : scheme["name"]),
                                  isThreeLine: true,
                                  subtitle:
                                      Text("Male: $male \nFemale: $female"),
                                  trailing: myIconButton(
                                      item: scheme, itemType: "scheme"),
                                  onTap: () {
                                    context
                                        .read<BreedingSchemeProvider>()
                                        .updateScheme(
                                            BreedingSchemeModel.fromDb(
                                                dbScheme: scheme));
                                    // if (!scheme['isCustomRats']) {
                                    //   context
                                    //       .read<BreedingSchemeProvider>()
                                    //       .editBreedPair(
                                    //           name: male, gender: 'male');
                                    //   context
                                    //       .read<BreedingSchemeProvider>()
                                    //       .editBreedPair(
                                    //           name: female, gender: 'female');
                                    // }
                                    navPush(
                                      context,
                                      BreedingShcemeInfoPage(
                                        rats: rats,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 35,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: ElevatedButton.icon(
                        label: const Text("Add Scheme",
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
                        onPressed: () {
                          navPush(
                              context,
                              BreedingScheme(
                                schemeCount: schemes.length,
                                rats: rats,
                              ));
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        }
      },
    );
  }

  Widget myBottomNavBar() {
    return Consumer<ControllerProvider>(builder: (context, value, child) {
      return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: value.bottomNavIndex,
          onTap: (index) {
            controllerProvider.changeBottomNavIndex(index: index);
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 700),
                curve: Curves.decelerate);
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.line_style_outlined), label: 'Rats'),
            BottomNavigationBarItem(
                icon: Icon(Icons.calculate_outlined), label: 'Gene Calculator'),
            BottomNavigationBarItem(
                icon: Icon(Icons.bed_rounded), label: "Breeding Tracker")
          ]);
    });
  }

  IconButton myIconButton(
          {required QueryDocumentSnapshot item, required String itemType}) =>
      IconButton(
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
                        Text("Are you sure you want to remove this $itemType?"),
                        const SizedBox(height: 30),
                        Text(
                          item["name"],
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
                      style: MyElevatedButtonStyle.cancelButtonStyle,
                    ),
                    ElevatedButton(
                      onPressed: () => deleteRat(item.id, itemType),
                      style: MyElevatedButtonStyle.deleteButtonStyle,
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
          icon: const DeleteIcon());

  myAppBar(BuildContext context) {
    AppBar appBar = AppBar();

    return PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Consumer<ControllerProvider>(
          builder: (context, value, child) {
            switch (value.bottomNavIndex) {
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
          },
        ));
  }

  ratScreenAppBar() {
    return AppBar(
      actions: [Container()],
      centerTitle: true,
      title: Center(
          child:
              Text((rats.isEmpty) ? "Your Rats" : "Your Rats: ${rats.length}")),
    );
  }

  breedTrackerAppBar() {
    return AppBar(
      actions: [Container()],
      centerTitle: true,
      title: const Center(child: Text("Breed Tracker")),
    );
  }

  geneCalAppBar() {
    return AppBar(
      actions: [Container()],
      centerTitle: true,
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

  myEndDrawer() {
    return Drawer(
      width: 200,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Consumer<FilterProvider>(builder: (context, value, child) {
          return Column(
            children: [
              const DrawerTitle(text: "Filters"),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      child: ElevatedButton(
                        onPressed: () {
                          if (value.activeFilters == "Female") {
                            value.setActiveFilters(filter: "");
                            return;
                          }
                          value.setActiveFilters(filter: "Female");
                          filterRats(filter: "Female");
                        },
                        style: (value.activeFilters != "Female")
                            ? MyElevatedButtonStyle.buttonStyle
                            : MyElevatedButtonStyle.activeButtonStyle,
                        child: const Text(
                          "Female",
                          style: MyElevatedButtonStyle.textStyle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 80,
                      child: ElevatedButton(
                        onPressed: () {
                          if (value.activeFilters == "Male") {
                            value.setActiveFilters(filter: "");
                            return;
                          }
                          value.setActiveFilters(filter: "Male");
                          filterRats(filter: "Male");
                        },
                        style: (value.activeFilters != "Male")
                            ? MyElevatedButtonStyle.buttonStyle
                            : MyElevatedButtonStyle.activeButtonStyle,
                        child: const Text(
                          "Male",
                          style: MyElevatedButtonStyle.textStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              DrawerTitle(
                text: "Sort by",
                reversed: value.reversed,
                onPressReverse: () {
                  final List<QueryDocumentSnapshot<Object?>> list =
                      value.reversed ? rats : List.from(rats.reversed);

                  value.setFilteredRats(rats: list);
                  value.setReversed();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MyDrawerButton(
                      onPressed: () {
                        rats.sort((a, b) {
                          value.setActiveSort(sort: 'Age');
                          final Rat ratA = Rat.fromDB(dbRat: a);
                          final Rat ratB = Rat.fromDB(dbRat: b);

                          return ageCalculatorDay(ratA.birthday)
                              .compareTo(ageCalculatorDay(ratB.birthday));
                        });

                        final List<QueryDocumentSnapshot<Object?>> list =
                            value.reversed ? List.from(rats.reversed) : rats;

                        value.setFilteredRats(rats: list);
                      },
                      text: "Age",
                      style: value.activeSort == "Age"
                          ? MyElevatedButtonStyle.activeButtonStyle
                          : MyElevatedButtonStyle.buttonStyle,
                    ),
                    MyDrawerButton(
                      onPressed: () {
                        value.setActiveSort(sort: 'Alphabetical');

                        rats.sort(
                          (a, b) {
                            final Rat ratA = Rat.fromDB(dbRat: a);
                            final Rat ratB = Rat.fromDB(dbRat: b);

                            return ratA.name.compareTo(ratB.name);
                          },
                        );

                        final List<QueryDocumentSnapshot<Object?>> list =
                            value.reversed ? List.from(rats.reversed) : rats;

                        value.setFilteredRats(rats: list);
                      },
                      text: "Alphabetical",
                      style: value.activeSort == "Alphabetical"
                          ? MyElevatedButtonStyle.activeButtonStyle
                          : MyElevatedButtonStyle.buttonStyle,
                    ),
                  ],
                ),
              )
            ],
          );
        }),
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
    final prov = Provider.of<FilterProvider>(context, listen: false);
    final filteredRats = rats.where((rat) => rat["gender"] == filter).toList();
    prov.setFilteredRats(rats: filteredRats);
  }

  double getSize() {
    if (MediaQuery.of(context).size.width < 435) {
      return MediaQuery.of(context).size.width / 1;
    } else {
      return MediaQuery.of(context).size.width / 1.3;
    }
  }

  deleteRat(String name, String itemType) async {
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    itemType == "rat"
        ? await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("rats")
            .doc(name)
            .delete()
        : await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("breedingSchemes")
            .doc(name)
            .delete();
    navPop(context);
    navPop(context);
  }

  myDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: BorderDirectional(
                      bottom: BorderSide(color: secondaryThemeColor)),
                ),
                child: Column(
                  children: [
                    DrawerCard(
                      iconData: Icons.person,
                      title: "Profile",
                      onTap: () {
                        navPush(context, const ProfilePage());
                        _key.currentState!.closeDrawer();
                      },
                    ),
                    DrawerCard(
                      onTap: () {
                        navPush(context, const SettingsPage());
                      },
                      title: "Settings",
                      iconData: Icons.settings,
                    ),
                    DrawerCard(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Report Bug/Improvement"),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => navPop(context),
                                  style: MyElevatedButtonStyle.buttonStyle,
                                  child: const Text("Cancel"),
                                )
                              ],
                              content: SizedBox(
                                height: 150,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 40,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                navPop(context);
                                                bugReport();
                                              },
                                              style: MyElevatedButtonStyle
                                                  .buttonStyle,
                                              child: const Text("Report Bug"),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 40,
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  navPop(context);
                                                  bugReport(bugs: false);
                                                },
                                                style: MyElevatedButtonStyle
                                                    .buttonStyle,
                                                child: const Text(
                                                    "Report Improvement Idea")),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      title: "Bug Reports/Improvements",
                      iconData: Icons.bug_report,
                    )
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(width: 1.5, color: secondaryThemeColor)),
                  elevation: 10,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: const Text(
                      "SignOut",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    trailing: Icon(Icons.logout, color: Colors.red[300]),
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> bugReport({bool bugs = true}) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final TextEditingController titleController =
                TextEditingController();
            final TextEditingController descriptionController =
                TextEditingController();
            final TextEditingController areaController =
                TextEditingController();

            Widget title = Text(bugs ? "Bug Report" : "Improvements");

            final List<Widget> actions = [
              ElevatedButton(
                onPressed: () {
                  navPop(context);
                },
                style: MyElevatedButtonStyle.cancelButtonStyle,
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  showDialog(
                      context: context,
                      builder: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ));
                  bugs
                      ? await FirebaseFirestore.instance
                          .collection("bugReports")
                          .doc()
                          .set({
                          "user": FirebaseAuth.instance.currentUser!.email,
                          "title": titleController.text.trim(),
                          "area": areaController.text.trim(),
                          "description": descriptionController.text.trim(),
                          "state": "new",
                          "date": DateTime.now()
                        })
                      : await FirebaseFirestore.instance
                          .collection("improvements")
                          .doc()
                          .set({
                          "user": FirebaseAuth.instance.currentUser!.email,
                          "title": titleController.text.trim(),
                          "area": areaController.text.trim(),
                          "description": descriptionController.text.trim(),
                          "state": "new",
                          "date": DateTime.now()
                        });
                  navPop(context);
                  navPop(context);
                  alert(text: "Report sent. Thank you for the feedback!");
                },
                style: MyElevatedButtonStyle.doneButtonStyle,
                child: const Text("Send Report"),
              ),
            ];

            final Widget content = SizedBox(
              height: 500,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    DirectiveText(
                        text: bugs
                            ? "Short title about problem:"
                            : "Short title for improvement"),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        hintText: "Title",
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 10),
                    DirectiveText(
                        text: bugs
                            ? "In what area of the\napp did it occur?"
                            : "In what area of the\napp is the improvement?"),
                    TextField(
                      controller: areaController,
                      decoration: const InputDecoration(
                        hintText: "Area",
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 10),
                    DirectiveText(
                        text: bugs
                            ? "Describe in detail what\nhappened and how to\nrecreate it:"
                            : "Describe in detail the\nImprovement idea"),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45),
                          borderRadius: BorderRadius.circular(5)),
                      child: TextField(
                          decoration: const InputDecoration(
                              hintText: "Description",
                              border: InputBorder.none,
                              constraints: BoxConstraints.expand(height: 200)),
                          controller: descriptionController,
                          maxLines: null,
                          textInputAction: TextInputAction.go),
                    ),
                  ],
                ),
              ),
            );

            return AlertDialog(
              title: title,
              actions: actions,
              content: content,
            );
          },
        );
      },
    );
  }
}
