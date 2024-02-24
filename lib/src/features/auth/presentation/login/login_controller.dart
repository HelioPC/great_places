import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:great_places/src/common/widgets/adaptive_widgets.dart';
import 'package:great_places/src/features/auth/data/firebase_auth_repository.dart';

final loginControllerProvider = Provider<LoginController>((ref) {
  return LoginController(ref: ref);
});

class LoginController {
  final ProviderRef ref;

  LoginController({required this.ref});

  Future<void> login(
      {required BuildContext context,
      required String email,
      required String password}) async {
    final result = await ref
        .read(authRepositoryProvider)
        .signInWithEmailAndPassword(email: email, password: password);

    result.fold(
      (exception) {
        if (context.mounted) {
          showAdaptiveDialog(
            context: context,
            builder: (context) {
              return AlertDialog.adaptive(
                title: const Text('An error occur'),
                content: Text(exception.toString()),
                actions: [
                  AdaptiveWidgets.adaptiveAction(
                    context: context,
                    onPressed: () {
                      if (context.canPop()) context.pop();
                    },
                    child: const Text('Ok')
                  ),
                ],
              );
            },
          );
        }
      },
      (success) => null,
    );
  }
}
