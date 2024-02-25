import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:great_places/src/common/widgets/custom_drawer.dart';
import 'package:great_places/src/features/home/presentation/great_place_controller.dart';

import 'package:great_places/src/common/router/app_routes.dart';

class PlacesListPage extends ConsumerWidget {
  const PlacesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final greatPlaceController = ref.watch(greatPlaceControllerProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('My places'),
      ),
      drawer: const CustomDrawer(),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          await ref.read(greatPlaceControllerProvider.notifier).refresh();
        },
        child: greatPlaceController.when(
          data: (data) {
            return Visibility(
              visible: data.isNotEmpty,
              replacement: const Center(
                child: Text('Store new places on your device'),
              ),
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: data.length,
                separatorBuilder: (_, __) {
                  return const SizedBox(height: 20);
                },
                itemBuilder: (context, index) {
                  final place = data[index];

                  return ListTile(
                    onTap: () async {
                      context.pushNamed(AppRoutes.detail.name, extra: place);
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
                        final result = await showAdaptiveDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog.adaptive(
                                title: const Text('Remove place'),
                                content: Text(
                                    'Place \'${place.title}\' will be removed'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: const Text('Confirm'),
                                  ),
                                ],
                              );
                            }).then((value) async {
                          if (value ?? false) {
                            final result = await ref.read(greatPlaceControllerProvider.notifier)
                                .removePlace(place.id);

                            return result;
                          }

                          return false;
                        });

                        debugPrint('dialog result = $result');

                        if (context.mounted) {
                          if (result) {
                            final snackBar = SnackBar(
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Deleted!',
                                message:
                                'The great place \'${place.title}\' was deleted successfully.',
                                contentType: ContentType.success,
                              ),
                            );

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
                          }
                        }
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  );
                },
              ),
            );
          },
          error: (err, trace) {
            return Column(
              children: [
                const Text('An error occur while fetching your places'),
                const SizedBox(height: 80),
                Text(err.toString()),
                const SizedBox(height: 80),
                Text(trace.toString()),
              ],
            );
          },
          loading: () {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(AppRoutes.form.name);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
