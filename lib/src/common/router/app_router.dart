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
    initialLocation: AppRoutes.LOGIN,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final path = state.uri.path;
      final isLoggedIn = authRepository.currentUser != null;

      if (isLoggedIn) {
        if (path == AppRoutes.LOGIN) {
          return AppRoutes.HOME;
        } else {
          if (path == AppRoutes.HOME ||
              path == AppRoutes.FORMROUTE ||
              path.startsWith(AppRoutes.DETAIL)) {
            return AppRoutes.LOGIN;
          }
        }
      }

      return null;
    },
    refreshListenable:
        GoRouterRefreshStream(authRepository.onAuthStateChanged()),
    routes: [
      GoRoute(
        path: AppRoutes.LOGIN,
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: LoginPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.SIGNUP,
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: SignUpPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.HOME,
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: PlacesListPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.FORMROUTE,
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: PlaceFormPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.DETAIL,
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: PlaceDetailPage(),
          );
        },
      ),
    ],
  );
}
