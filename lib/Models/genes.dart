import 'dart:developer';

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
