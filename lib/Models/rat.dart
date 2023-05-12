enum Gender { male, female }

enum Ears {
  // TODO: add ear types
  placeholder
}

enum Colours {
  // TODO: add colours
  placeholder
}

enum Markings {
  // TODO: add markings
  placeholder
}

enum Coats {
  // TODO: add coats
  placeholder
}

class Rat {
  Rat({
    required this.name,
    required this.registeredName,
    required this.colours,
    required this.ears,
    required this.gender,
    required this.markings,
    required this.parents,
    required this.coat,
    required this.birthday,
  });
  final String name;
  final String registeredName;
  final Gender gender;
  final String ears;
  final String colours;
  final String markings;
  final Parents parents;
  final String coat;
  final DateTime birthday;

  toDb(){
    final Map<String,dynamic> rat = {
      "name":name,
      "registeredName":registeredName,
      "gender":gender.name.toString(),
      "ears":ears,
      "colours":colours,
      "markings":markings,
      "mother":parents.mom,
      "father":parents.dad,
      "coat":coat,
      "birthday":[birthday.year.toInt(),birthday.month.toInt(), birthday.day.toInt()],
    };
    return rat;
  }
}

class Parents {
  Parents({required this.dad, required this.mom});

  final String mom;
  final String dad;
}

// Name
// Registered name
// Gender
// Ears
// Colour
// Markings
// Coat type
// Parents
//Birthday and if it can generate age
//And weights that can generate a chart
//And heat cycles for the females
//Oh and description