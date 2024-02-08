import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/src/features/home/data/great_place_repository.dart';
import 'package:great_places/src/common/models/place.dart';

class GreatPlaceController extends ChangeNotifier {
  GreatPlaceController({required this.repository});

  final GreatPlaceRepository repository;

  Future<List<Place>> loadPlaces() async {
    return await repository.loadPlaces();
  }

  Future<bool> addPlace(String title, File image, LatLng position) async {
    final result = await repository.addPlace(title, image, position);

    notifyListeners();

    return result;
  }

  Future<bool> removePlace(String id) async {
      final result = await repository.removePlace(id);

      notifyListeners();

      return result;
  }
}