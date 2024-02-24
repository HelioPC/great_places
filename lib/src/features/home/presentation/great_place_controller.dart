import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/src/common/models/place.dart';
import 'package:great_places/src/features/home/data/local_great_place_repository.dart';

final greatPlaceControllerProvider =
    AsyncNotifierProvider<GreatPlaceController, List<Place>>(() {
  return GreatPlaceController();
});

class GreatPlaceController extends AsyncNotifier<List<Place>> {
  @override
  FutureOr<List<Place>> build() async {
    return _loadPlaces();
  }

  Future<void> refresh() async {
    state =  const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _loadPlaces();
    });
  }

  Future<List<Place>> _loadPlaces() async {
    return await ref.read(greatPlaceRepositoryProvider).loadPlaces();
  }

  Future<bool> addPlace(String title, File image, LatLng position) async {
    state = const AsyncValue.loading();
    late bool result;

    state = await AsyncValue.guard(() async {
      final value = await ref.read(greatPlaceRepositoryProvider).addPlace(
            title,
            image,
            position,
          );
      result = value;

      return _loadPlaces();
    });

    return result;
  }

  Future<bool> removePlace(String id) async {
    state = const AsyncValue.loading();
    late bool result;

    state = await AsyncValue.guard(() async {
      final value =
          await ref.read(greatPlaceRepositoryProvider).removePlace(id);
      result = value;

      return _loadPlaces();
    });

    return result;
  }
}
