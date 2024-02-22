import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:great_places/src/common/router/app_routes.dart';
import 'package:great_places/src/common/router/go_router_refresh_stream.dart';
import 'package:great_places/src/features/auth/data/firebase_auth_repository.dart';
import 'package:great_places/src/features/auth/presentation/login/login_page.dart';
import 'package:great_places/src/features/auth/presentation/sign_up/sign_up_page.dart';
import 'package:great_places/src/features/home/presentation/place_detail_page.dart';
import 'package:great_places/src/features/home/presentation/place_form_page.dart';
import 'package:great_places/src/features/home/presentation/places_list_page.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return goRouter(ref);
});

GoRouter goRouter(ProviderRef ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: AppRoutes.login.routeAsString(),
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final path = state.uri.path;
      final isLoggedIn = authRepository.currentUser != null;

      if (isLoggedIn) {
        if (path == AppRoutes.login.routeAsString()) {
          return AppRoutes.home.routeAsString();
        } else {
          if (path == AppRoutes.home.routeAsString() ||
              path == AppRoutes.form.routeAsString() ||
              path.startsWith(AppRoutes.detail.routeAsString())) {
            return AppRoutes.login.routeAsString();
          }
        }
      }

      return null;
    },
    refreshListenable:
        GoRouterRefreshStream(authRepository.onAuthStateChanged()),
    routes: [
      GoRoute(
        path: AppRoutes.login.routeAsString(),
        name: AppRoutes.login.name,
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: LoginPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.signup.routeAsString(),
        name: AppRoutes.signup.name,
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: SignUpPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.home.routeAsString(),
        name: AppRoutes.home.name,
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: PlacesListPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.form.routeAsString(),
        name: AppRoutes.form.name,
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: PlaceFormPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.detail.routeAsString(),
        name: AppRoutes.detail.name,
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: PlaceDetailPage(),
          );
        },
      ),
    ],
  );
}
