import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_test/flutter_test.dart';

const List<String> keys = [
  'GOOGLE_MAPS_API_KEY',
];

const String value = '1234567890';

void main() async {
  group('Testing app environment keys', () {
    FlutterConfig.loadValueForTesting({ for (var k in keys) k: value });

    test('Check google maps API key existence', () {
      final googleMapsString = keys[0];

      expect(FlutterConfig.get(googleMapsString) is String, true);
    });

    test('Check google maps API key value', () {
      final googleMapsString = keys[0];

      expect(FlutterConfig.get(googleMapsString), value);
    });
  });
}