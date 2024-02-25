import 'package:flutter/material.dart';
import 'package:great_places/src/common/models/place.dart';
import 'package:great_places/src/features/home/presentation/map_page.dart';

class PlaceDetailPage extends StatelessWidget {
  final Place? place;

  const PlaceDetailPage({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    bool isPlaceNull = place == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isPlaceNull ? 'No details available' : place!.title),
      ),
      body: isPlaceNull
          ? const Center(
              child: Text('Internal error'),
            )
          : Column(
              children: [
                SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: Image.file(place!.image, fit: BoxFit.cover),
                ),
                const SizedBox(height: 10),
                Text(
                  place!.location.address,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (ctx) {
                          return MapPage(
                            isReadonly: true,
                            location: place!.location,
                          );
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.map),
                  label: const Text('See on map'),
                ),
              ],
            ),
    );
  }
}
