import 'package:flutter/material.dart';
import 'package:great_places/src/features/home/presentation/great_place_controller.dart';
import 'package:provider/provider.dart';
import 'package:great_places/src/common/models/place.dart';

import 'package:great_places/src/common/utils/app_routes.dart';

class PlacesListPage extends StatelessWidget {
  const PlacesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final greatPlaceControllerProvider = context.watch<GreatPlaceController>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('My places'),
      ),
      body: FutureBuilder<List<Place>>(
        future: greatPlaceControllerProvider.loadPlaces(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (snap.hasError) {
            debugPrint(snap.error.toString());
            return const Center(
              child: Text('Unexpected error occur'),
            );
          }

          final greatPlaces = snap.data!;

          return Visibility(
            visible: greatPlaces.isNotEmpty,
            replacement: const Center(
              child: Text('Store new places on your device'),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: greatPlaces.length,
              itemBuilder: (context, index) {
                final place = greatPlaces[index];

                return ListTile(
                  onTap: () async {
                    Navigator.of(context)
                        .pushNamed(AppRoutes.DETAIL, arguments: place);
                  },
                  leading: CircleAvatar(
                    backgroundImage: FileImage(place.image),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      place.title,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(place.location.address),
                  ),
                  trailing: IconButton(
                    onPressed: () async {
                      greatPlaceControllerProvider.removePlace(place.id);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.FORMROUTE);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
