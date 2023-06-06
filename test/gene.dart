// ignore_for_file: avoid_print

import 'dart:ffi';

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

void main() {
  final rat1 = RatGenes(genes: Gene(alleleA: "L", alleleB: "-"), name: "Alice");
  final rat2 = RatGenes(genes: Gene(alleleA: "l", alleleB: "l"), name: "Bob");

  final rat3 =
      RatGenes(genes: Gene(alleleA: "B", alleleB: "B"), name: "Charlie");

  print(ageCalculator(2023, 4, 24, TimeTypes.Day));
}

int ageCalculator(int year, int month, int day, TimeTypes returnType) {

  DateTime birthdate = DateTime(year, month, day);
  int yearsOld = AgeCalculator.age(birthdate).years;
  int monthsOld = AgeCalculator.age(birthdate).months;
  int daysOld = AgeCalculator.age(birthdate).days;

  print(daysOld);
 
  switch(returnType){
    case TimeTypes.Day: return daysOld;
    case TimeTypes.Month: if (yearsOld > 0){
      return (yearsOld * 12) + monthsOld;
    } else{
      return monthsOld;
    }
    case TimeTypes.Week: 
    double months = monthsOld * 4.345;
    double years = yearsOld * 52.1429;
    double days = daysOld / 7;
    double weeksOld = days + months + years;
    print(weeksOld);
    return weeksOld.floor();
    case TimeTypes.Year: return yearsOld;
  }
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
