import 'package:flutter/material.dart';
import 'package:pocket_puppy_rattery/Functions/utils.dart';
import 'package:pocket_puppy_rattery/Services/breeding_scheme_provider.dart';
import 'package:pocket_puppy_rattery/Services/custom_widgets.dart';
import 'package:pocket_puppy_rattery/Services/rats_provider.dart';
import 'package:pocket_puppy_rattery/Views/Breeding%20Scheme/add_pup.dart';
import 'package:pocket_puppy_rattery/Views/Breeding%20Scheme/pup_gallery.dart';
import 'package:provider/provider.dart';

class PupInfo extends StatefulWidget {
  const PupInfo({super.key});

  @override
  State<PupInfo> createState() => _PupInfoState();
}

class _PupInfoState extends State<PupInfo> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BreedingSchemeProvider>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Pup: ${value.pup!.name}"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              details(value),
              age(value),
              parents(value: value),
              coat(value: value),
              markings(value: value),
              colors(value: value),
              buttonRow(value: value),
            ],
          ),
        ),
      );
    });
  }

  Row markings({required BreedingSchemeProvider value}) {
    return Row(
      children: [
        Expanded(
          child: MyInfoCard(
            title: "Markings",
            child: SizedBox(
              height:
                  listContainerHeight(itemLenght: value.pup!.markings.length),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.pup!.markings.length,
                itemBuilder: (context, index) {
                  return Text("- ${value.pup!.markings[index]}");
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row age(BreedingSchemeProvider value) {
    return Row(
      children: [
        Expanded(
          child: MyInfoCard(
              title: "Age",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                      "Birthday: ${birthdayView(data: value.getScheme.dateOfLabour!.toDate())}"),
                  Text(
                      "Age: ${defaultAgeCalculator(value.getScheme.dateOfLabour!.toDate())}"),
                ],
              )),
        ),
      ],
    );
  }

  Row coat({required BreedingSchemeProvider value}) {
    return Row(
      children: [
        Expanded(
          child: MyInfoCard(
            title: "Coat",
            child: Text("Coat: ${value.pup!.coat.name}"),
          ),
        ),
        Expanded(
            child: MyInfoCard(
                title: "Ears", child: Text("Ears: ${value.pup!.ears.name}")))
      ],
    );
  }

  Row details(BreedingSchemeProvider value) {
    return Row(
      children: [
        Expanded(
          child: MyInfoCard(
              title: "Details",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name: ${value.pup!.name}"),
                  Text("Registered Name: ${value.pup!.registeredName}"),
                  Text("Gender: ${value.pup!.gender}"),
                ],
              )),
        ),
      ],
    );
  }

  parents({required BreedingSchemeProvider value}) {
    final RatsProvider prov = Provider.of<RatsProvider>(context, listen: false);
    dynamic mom = value.getScheme.isCustomRats
        ? value.pup!.parents.mom
        : List.from(prov.rats!
                .where((element) => element.id == value.pup!.parents.mom))[0]
            ['name'];
    dynamic dad = value.getScheme.isCustomRats
        ? value.pup!.parents.dad
        : List.from(prov.rats!
                .where((element) => element.id == value.pup!.parents.dad))[0]
            ['name'];
    return Row(
      children: [
        Expanded(
          child: MyInfoCard(
            title: "Parents",
            child: Row(
              children: [
                Expanded(
                  child: MyInfoCard(
                    title: "Mother",
                    child: Text(mom),
                  ),
                ),
                Expanded(
                  child: MyInfoCard(
                    title: "Father",
                    child: Text(dad),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Row colors({required BreedingSchemeProvider value}) {
    return Row(
      children: [
        Expanded(
          child: MyInfoCard(
            title: "Colours",
            child: SizedBox(
              height:
                  listContainerHeight(itemLenght: value.pup!.colours.length),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.pup!.colours.length,
                itemBuilder: (context, index) {
                  return Text("- ${value.pup!.colours[index]}");
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buttonRow({required BreedingSchemeProvider value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 40,
          width: 100,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      AddPup(
                    scheme: value.getScheme,
                    pup: value.pup,
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    final tween = Tween(begin: begin, end: end);
                    final offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
            },
            style: MyElevatedButtonStyle.buttonStyle,
            child: const Text("Edit"),
          ),
        ),
        SizedBox(
          height: 40,
          width: 100,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const PupGallery(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    final tween = Tween(begin: begin, end: end);
                    final offsetAnimation = animation.drive(tween);
                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
            },
            style: MyElevatedButtonStyle.buttonStyle,
            child: const Text("Images"),
          ),
        ),
      ],
    );
  }
}
