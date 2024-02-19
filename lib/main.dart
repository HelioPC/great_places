import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_places/src/common/themes/dark_theme.dart';
import 'package:great_places/src/common/utils/app_routes.dart';
import 'package:great_places/src/features/home/presentation/place_detail_page.dart';
import 'package:great_places/src/features/home/presentation/place_form_page.dart';
import 'package:great_places/src/features/home/presentation/places_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterConfig.loadEnvVariables();

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkTheme(),
      routes: {
        AppRoutes.HOME: (context) => const PlacesListPage(),
        AppRoutes.FORMROUTE: (context) => const PlaceFormPage(),
        AppRoutes.DETAIL: (context) => const PlaceDetailPage(),
      },
    );
  }
}
