import 'package:flutter/material.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:great_places/utils/app_routes.dart';
import 'package:provider/provider.dart';

class PlacesListPage extends StatelessWidget {
  const PlacesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('My places'),
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false).loadPlaces(),
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

          return Consumer<GreatPlaces>(
            builder: (context, value, child) {
              return Visibility(
                visible: value.count > 0,
                replacement: child!,
                child: ListView.builder(
                  itemCount: value.count,
                  itemBuilder: (context, index) {
                    final place = value.list[index];

                    return ListTile(
                      onTap: () async {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.DETAIL, arguments: place);
                      },
                      leading: CircleAvatar(
                        backgroundImage: FileImage(place.image),
                      ),
                      title: Text(place.title),
                      subtitle: Text(place.location.address),
                      trailing: IconButton(
                        onPressed: () async {
                          Provider.of<GreatPlaces>(context, listen: false)
                              .removePlace(place.id);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    );
                  },
                ),
              );
            },
            child: const Center(
              child: Text('Store new places on your device'),
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
