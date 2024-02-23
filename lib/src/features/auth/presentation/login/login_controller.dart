import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_places/src/features/auth/data/firebase_auth_repository.dart';

final loginControllerProvider = Provider<LoginController>((ref) {
  return LoginController(ref: ref);
});

class LoginController {
  final ProviderRef ref;

  LoginController({required this.ref});

  Future<void> login({required String email, required String password}) async {
    await ref
        .read(authRepositoryProvider)
        .signInWithEmailAndPassword(email: email, password: password);
  }
}
