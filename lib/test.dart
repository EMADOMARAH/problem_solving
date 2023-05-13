import 'dart:io';
import 'package:test/test.dart';
import 'package:csv/csv.dart';
import 'package:order_processor/order_processor.dart';

void main() {
  group('Order Processor Tests', () {
    late List<List<dynamic>> ordersData;
    late List<List<dynamic>> expectedAvgQtyData;
    late List<List<dynamic>> expectedPopularBrandData;

    setUpAll(() async {
      // Read input data from file
      final inputFileName = 'orders_test.csv';
      final inputFile = File(inputFileName);
      ordersData = CsvToListConverter().convert(await inputFile.readAsString());

      // Read expected output data for average quantity from file
      final expectedAvgQtyFileName = 'expected_avg_qty_test.csv';
      final expectedAvgQtyFile = File(expectedAvgQtyFileName);
      expectedAvgQtyData =
          CsvToListConverter().convert(await expectedAvgQtyFile.readAsString());

      // Read expected output data for popular brand from file
      final expectedPopularBrandFileName = 'expected_popular_brand_test.csv';
      final expectedPopularBrandFile =
      File(expectedPopularBrandFileName);
      expectedPopularBrandData = CsvToListConverter()
          .convert(await expectedPopularBrandFile.readAsString());
    });

    test('Calculate Average Quantity Test', () {
      final orderProcessor = OrderProcessor(ordersData);
      final avgQtyData = orderProcessor.calculateAverageQuantity();
      expect(avgQtyData, equals(expectedAvgQtyData));
    });

    test('Calculate Most Popular Brand Test', () {
      final orderProcessor = OrderProcessor(ordersData);
      final popularBrandData = orderProcessor.calculateMostPopularBrand();
      expect(popularBrandData, equals(expectedPopularBrandData));
    });
  });
}
