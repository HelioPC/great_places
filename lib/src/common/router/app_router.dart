import 'package:flutter/material.dart';
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

CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

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
          final routes = GoRouter.of(context).routerDelegate.currentConfiguration.routes;
          late TextDirection textDirection;

          if (routes.isEmpty || routes.length == 1) {
            textDirection = TextDirection.rtl;
          } else {
            textDirection = TextDirection.ltr;
          }

          return CustomTransitionPage(
            child: const LoginPage(),
            transitionsBuilder: (context, animation1, animation2, child) {
              return SlideTransition(
                position: animation1.drive(
                  Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).chain(
                    CurveTween(curve: Curves.easeInCubic),
                  ),
                ),
                textDirection: textDirection,
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: AppRoutes.signup.routeAsString(),
        name: AppRoutes.signup.name,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            child: const SignUpPage(),
            transitionsBuilder: (context, animation1, animation2, child) {
              return SlideTransition(
                position: animation1.drive(
                  Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).chain(
                    CurveTween(curve: Curves.easeInCubic),
                  ),
                ),
                textDirection: TextDirection.ltr,
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        path: AppRoutes.home.routeAsString(),
        name: AppRoutes.home.name,
        pageBuilder: (context, state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const PlacesListPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.form.routeAsString(),
        name: AppRoutes.form.name,
        pageBuilder: (context, state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const PlaceFormPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.detail.routeAsString(),
        name: AppRoutes.detail.name,
        pageBuilder: (context, state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const PlaceDetailPage(),
          );
        },
      ),
    ],
  );
}
