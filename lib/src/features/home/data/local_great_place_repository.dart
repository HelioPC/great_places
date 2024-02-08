import 'dart:io';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;

import 'package:great_places/src/features/home/data/great_place_repository.dart';
import 'package:great_places/src/common/models/place.dart';
import 'package:great_places/src/common/utils/db_utils.dart';
import 'package:great_places/src/common/utils/location_utils.dart';

class LocalGreatPlaceRepository implements GreatPlaceRepository {
  List<Place> _list = [];

  @override
  Future<bool> addPlace(String title, File image, LatLng position) async {
    final address = await LocationUtils.getAddressFrom(position);

    final newPlace = Place(
      id: Random().nextDouble().toString(),
      title: title,
      location: PlaceLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      ),
      image: image,
    );

    _list.add(newPlace);

    DBUtils.insert(
      'places',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'address': address,
      },
    );

    return true;
  }

  @override
  Future<List<Place>> loadPlaces() async {
    final data = await DBUtils.getData('places');

    final appDir = await syspath.getApplicationDocumentsDirectory();

    _list = data.map((e) {
      String filename = path.basename(e['image']);

      return Place(
        id: e['id'],
        title: e['title'],
        image: File('${appDir.path}/$filename'),
        location: PlaceLocation(
          latitude: double.tryParse(e['latitude'].toString()) ?? 0,
          longitude: double.tryParse(e['longitude'].toString()) ?? 0,
          address: e['address'],
        ),
      );
    }).toList();

    return _list;
  }

  @override
  Future<bool> removePlace(String id) async {
    await DBUtils.remove('places', id);

    _list.removeWhere((p) => p.id == id);

    return true;
  }

}
