// ignore_for_file: avoid_print, constant_identifier_names

import 'dart:developer';

import 'package:age_calculator/age_calculator.dart';

class Gene {
  Gene({required this.alleleA, required this.alleleB});

  final String alleleA;
  final String alleleB;
}

enum Dominant { B }

enum Recesive { b }

class RatGenes {
  RatGenes({
    required this.genes,
    required this.name,
  });

  final String name;
  final Gene genes;

  List<String> geneList() {
    return [genes.alleleA, genes.alleleB];
  }
}

enum TimeTypes {
  Day,
  Week,
  Month,
  Year,
}

enum Campies{
  Tristan,
  Carla,
  Andrika,
  VanZyl,
  Tinus,
  Kyle,
  Yonecia,
}

void main() {

  DateDuration birthdate = AgeCalculator.age(DateTime(2016,06,16));
  
  int ageInMonths = birthdate.months;
  int ageInYears = birthdate.years;
  int ageInDays = birthdate.days;


  double monthsToDays = ageInMonths*30.4167 + (ageInMonths/2);
  double yearsToDays = ageInYears*365.2425;
  int ageInDaysOnly = (monthsToDays.floor() + yearsToDays.floor() + ageInDays).floor();

  print(ageInDaysOnly);

}

defaultAgeCalculator(DateTime birthdate){
  if (ageCalculatorYear(birthdate) < 0){
    print("Date incompatable");
    return;
  }
  if (ageCalculatorYear(birthdate) == 0) {
    if (ageCalculatorMoth(birthdate) == 0) {
      print("${ageCalculatorDay(birthdate)} days.");
    } else {
      if (ageCalculatorDay(birthdate) == 0){
        print("${ageCalculatorMoth(birthdate)} months.");
      } else{
        print("${ageCalculatorMoth(birthdate)} months, ${ageCalculatorDay(birthdate)} days.");
      }
    }
  } else {
    if (AgeCalculator.age(birthdate).months == 0){
      print("${ageCalculatorYear(birthdate)} years");
    } else{
      print("${ageCalculatorYear(birthdate)} years, ${AgeCalculator.age(birthdate).months} months");
    }
  }
}

int ageCalculatorDay(DateTime birthdate) {
  int yearsOld = AgeCalculator.age(birthdate).years;
  int monthsOld = AgeCalculator.age(birthdate).months;
  int daysOld = AgeCalculator.age(birthdate).days;

  return daysOld;
}

int ageCalculatorWeek(DateTime birthdate) {
  int yearsOld = AgeCalculator.age(birthdate).years;
  int monthsOld = AgeCalculator.age(birthdate).months;
  int daysOld = AgeCalculator.age(birthdate).days;

  double months = monthsOld * 4.345;
  double years = yearsOld * 52.1429;
  double days = daysOld / 7;
  double weeksOld = days + months + years;
  print(weeksOld);
  return weeksOld.floor();
}

int ageCalculatorMoth(DateTime birthdate) {
  int yearsOld = AgeCalculator.age(birthdate).years;
  int monthsOld = AgeCalculator.age(birthdate).months;
  int daysOld = AgeCalculator.age(birthdate).days;

  if (yearsOld > 0) {
    return (yearsOld * 12) + monthsOld;
  }
  return monthsOld;
}

int ageCalculatorYear(DateTime birthdate) {
  int yearsOld = AgeCalculator.age(birthdate).years;
  int monthsOld = AgeCalculator.age(birthdate).months;
  int daysOld = AgeCalculator.age(birthdate).days;

  return yearsOld;
}

List<String> matchRats({required RatGenes rat1, required RatGenes rat2}) {
  List<String> pairs = [];

  for (String geneRat1 in rat1.geneList()) {
    for (String geneRat2 in rat2.geneList()) {
      if (isUppercase(geneRat1) || geneRat2 == "-") {
        pairs.add(geneRat1 + geneRat2);
      } else if (isUppercase(geneRat2) || geneRat2 == "-") {
        pairs.add(geneRat2 + geneRat1);
      } else {
        pairs.add(geneRat2 + geneRat1);
      }
    }
  }

  return pairs;
}

getPercentage({required List<String> pairResults}) {
  var seen = <String>{};
  Map<String, int> percentages = {};
  int counter = 0;
  List<String> uniquelist =
      pairResults.where((country) => seen.add(country)).toList();

  for (String uniqueGene in seen) {
    counter = 0;
    percentages.addAll({uniqueGene: counter});
    for (String gene in pairResults) {
      if (uniqueGene == gene) {
        counter += 1;
        percentages.update(uniqueGene,
            (value) => ((counter / pairResults.length) * 100).ceil());
      }
    }
  }

  return percentages;
}

bool isUppercase(String character) {
  if (character == "-") {
    return false;
  }
  return character.toUpperCase() == character;
}
