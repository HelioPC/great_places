import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_places/src/common/models/user_model.dart';
import 'package:great_places/src/features/auth/data/auth_repository.dart';
import 'package:path_provider/path_provider.dart';

final authRepositoryProvider = Provider<FirebaseAuthRepository>((ref) {
  return FirebaseAuthRepository(
    auth: FirebaseAuth.instance,
    fireStore: FirebaseFirestore.instance,
    firebaseStorage: FirebaseStorage.instance,
  );
});

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore fireStore;
  final FirebaseStorage firebaseStorage;

  FirebaseAuthRepository({
    required this.auth,
    required this.fireStore,
    required this.firebaseStorage,
  });

  UserModel? get currentUser => _userToUserModel(auth.currentUser);

  UserModel? _userToUserModel(User? user) {
    if (user == null) return null;

    return UserModel(
      uid: user.uid,
      name: user.displayName!,
      email: user.email!,
      profileImage: user.photoURL,
    );
  }

  @override
  Future<UserModel?> getCurrentUserInfo() async {
    if (auth.currentUser == null) return null;

    final userInfo =
        await fireStore.collection('users').doc(auth.currentUser!.uid).get();

    if (userInfo.data() == null) return null;

    return UserModel.fromMap(userInfo.data()!);
  }

  @override
  Stream<UserModel?> onAuthStateChanged() {
    return auth.authStateChanges().map((user) => _userToUserModel(user));
  }

  @override
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required File? image,
  }) async {
    final credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (credential.user != null) {
      late String imageUrl;

      if (image != null) {
        imageUrl = await _saveImageFile(
          image,
          'profileImage/${credential.user!.uid}',
        );
      } else {
        imageUrl = await _saveImageFile(
          await _getDefaultImage(),
          'profileImage/${credential.user!.uid}',
        );
      }

      await credential.user?.updateDisplayName(name);
      await credential.user?.updatePhotoURL(imageUrl);

      await _saveUserInfo(
        uid: credential.user!.uid,
        email: email,
        name: name,
        imageUrl: imageUrl,
      );
    }
  }

  Future<void> _saveUserInfo({
    required String uid,
    required String email,
    required String name,
    required String imageUrl,
  }) async {
    final user = UserModel(
      uid: uid,
      name: name,
      email: email,
      profileImage: imageUrl,
    );

    await fireStore.collection('users').doc(uid).set(user.toMap());
  }

  Future<String> _saveImageFile(File image, String path) async {
    late UploadTask uploadTask;

    uploadTask = firebaseStorage.ref().child(path).putFile(image);

    TaskSnapshot snapshot = await uploadTask;

    String imageUrl = await snapshot.ref.getDownloadURL();

    return imageUrl;
  }

  Future<File> _getDefaultImage() async {
    const path = 'images/profileImage.png';
    final byteData = await rootBundle.load('assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');

    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}
