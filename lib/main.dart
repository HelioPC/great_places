import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:great_places/src/common/utils/app_routes.dart';
import 'package:great_places/src/features/home/data/great_place_repository.dart';
import 'package:great_places/src/features/home/data/local_great_place_repository.dart';
import 'package:great_places/src/features/home/presentation/place_detail_page.dart';
import 'package:great_places/src/features/home/presentation/place_form_page.dart';
import 'package:great_places/src/features/home/presentation/places_list_page.dart';
import 'package:great_places/src/features/home/presentation/great_place_controller.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterConfig.loadEnvVariables();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<GreatPlaceRepository>(
          create: (_) => LocalGreatPlaceRepository(),
        ),
        ChangeNotifierProvider<GreatPlaceController>(
            create: (context) => GreatPlaceController(
                repository: context.read<GreatPlaceRepository>()
            ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.dark,
          ),
          fontFamily: 'Poppins',
          appBarTheme: const AppBarTheme(
            elevation: 0,
            titleTextStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        routes: {
          AppRoutes.HOME: (context) => const PlacesListPage(),
          AppRoutes.FORMROUTE: (context) => const PlaceFormPage(),
          AppRoutes.DETAIL: (context) => const PlaceDetailPage(),
        },
      ),
    );
  }
}
