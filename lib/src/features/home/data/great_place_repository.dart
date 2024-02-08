import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/src/common/models/place.dart';

abstract class GreatPlaceRepository {

  Future<List<Place>> loadPlaces();

  Future<bool> addPlace(String title, File image, LatLng position);

  Future<bool> removePlace(String id);
}
