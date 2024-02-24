import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:great_places/src/common/exceptions/auth_exception.dart';
import 'package:great_places/src/common/models/user_model.dart';

abstract class AuthRepository {
  Future<UserModel?> getCurrentUserInfo();

  Future<Either<AuthException, void>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<AuthException, void>> signUp({
    required String name,
    required String email,
    required String password,
    required File? image,
});

  Future<void> signOut();

  Stream<UserModel?> onAuthStateChanged();
}
