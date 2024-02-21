import 'dart:io';

import 'package:great_places/src/common/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> getCurrentUserInfo();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required File? image,
});

  Future<void> signOut();

  Stream<UserModel?> onAuthStateChanged();
}
