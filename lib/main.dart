import 'dart:io';
import 'package:csv/csv.dart';

void main() {
  // Read input file name from stdin
  final inputFileName = stdin.readLineSync();

  // Read input CSV file
  final inputCsvString = File(inputFileName!).readAsStringSync();
  final inputCsv = CsvToListConverter().convert(inputCsvString);

  // Process input data
  final products = <String>{};
  final productQuantities = <String, List<int>>{};
  final productBrands = <String, Map<String, int>>{};
  for (final row in inputCsv) {
    final product = row[2] as String;
    products.add(product);

    final quantity = row[3] as int;
    productQuantities.putIfAbsent(product, () => []).add(quantity);

    final brand = row[4] as String;
    productBrands.putIfAbsent(product, () => {}).update(brand, (count) => count + 1, ifAbsent: () => 1);
  }

  // Compute output data
  final outputQuantities = <List<dynamic>>[];
  final outputBrands = <List<dynamic>>[];
  for (final product in products) {
    final quantities = productQuantities[product]!;
    final averageQuantity = quantities.reduce((a, b) => a + b) / quantities.length;
    outputQuantities.add([product, averageQuantity]);

    final brands = productBrands[product]!;
    final maxCount = brands.values.reduce((a, b) => a > b ? a : b);
    final popularBrand = brands.entries.firstWhere((entry) => entry.value == maxCount).key;
    outputBrands.add([product, popularBrand]);
  }

  // Write output CSV files
  final outputQuantitiesCsv = ListToCsvConverter().convert(outputQuantities);
  final outputBrandsCsv = ListToCsvConverter().convert(outputBrands);
  final outputQuantitiesFileName = '0_$inputFileName';
  final outputBrandsFileName = '1_$inputFileName';
  File(outputQuantitiesFileName).writeAsStringSync(outputQuantitiesCsv);
  File(outputBrandsFileName).writeAsStringSync(outputBrandsCsv);
}
