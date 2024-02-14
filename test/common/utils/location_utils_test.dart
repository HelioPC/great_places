import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/src/common/utils/location_utils.dart';

void main() async {
  const String apiKey = 'GOOGLE_MAPS_API_KEY';
  const String apiValue = 'PUT_YOUR_REAL_API_KEY_HERE';

  FlutterConfig.loadValueForTesting({
    apiKey: apiValue,
  });

  const location = LatLng(-8.8276992, 13.238272);

  group('Testing preview map image', () {
    final previewImage = LocationUtils.getMapPreviewImage(
      latitude: location.latitude,
      longitude: location.longitude,
    );

    test('Check google maps API key existence', () {
      expect(FlutterConfig.get(apiKey) is String, true);
      expect(FlutterConfig.get(apiKey), apiValue);
    });
    
    test('Preview image string format', () {
      final substring1 = '?center=${location.latitude},${location.longitude}';
      final substring2 = '&markers=color:red%7Clabel:P%7C${location.latitude},${location.longitude}';

      expect(previewImage.contains(substring1), true);
      expect(previewImage.contains(substring2), true);
    });
  });

  group('Testing address name from location', () {
    test('Check google maps API key existence', () {
      expect(FlutterConfig.get(apiKey) is String, true);
      expect(FlutterConfig.get(apiKey), apiValue);
    });

    test('Testing address name existence', () async {
      var addressName = await LocationUtils.getAddressFrom(location);

      expect(addressName is String, true);
    });
  });
}