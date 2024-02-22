import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_places/src/common/router/app_router.dart';
import 'package:great_places/src/common/themes/dark_theme.dart';

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(goRouterProvider);
    
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Great Places',
      routerConfig: appRouter,
      theme: darkTheme(),
    );
  }
}
