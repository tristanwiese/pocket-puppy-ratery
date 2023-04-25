enum Gender{
  male,
  female
}

enum Ears{
  // TODO: add ear types
  placeholder
}

enum Colours{
  // TODO: add colours
  placeholder
}

enum Markings{
  // TODO: add markings
  placeholder
}

enum Coats{
  // TODO: add coats
  placeholder
}

class Rat{
  Rat({
    required this.name,
    required this.registeredName,
    required this.colours,
    required this.ears,
    required this.gender,
    required this.markings,
    required this.parents,
    required this.coat,
    required this.bibrthday,
  });
final String name;
final String registeredName;
final Gender gender;
final Ears ears;
final Colours colours;
final Markings markings;
final Parents parents;
final Coats coat;
final DateTime bibrthday;
}

class Parents{
  Parents({
    required this.dad,
    required this.mom
  });

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