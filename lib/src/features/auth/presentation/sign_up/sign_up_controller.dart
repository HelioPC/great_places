import 'dart:io';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:great_places/src/common/widgets/adaptive_widgets.dart';
import 'package:great_places/src/features/auth/data/firebase_auth_repository.dart';
import 'package:great_places/src/features/auth/presentation/sign_up/sign_up_page.dart';
import 'package:image_picker/image_picker.dart';

final signupControllerProvider = Provider<SignupController>(
  (ref) {
    return SignupController(
      ref: ref,
    );
  },
);

final signupStateNotifier = NotifierProvider<SignupStateNotifier, SignupState>(
  () {
    return SignupStateNotifier();
  },
);

class SignupController {
  final ProviderRef ref;

  SignupController({required this.ref});

  Future<void> signUp(BuildContext context) async {
    final state = ref.watch(signupStateNotifier);

    if (!ref.read(signupStateNotifier.notifier).isDataValid()) return;

    final result = await ref.read(authRepositoryProvider).signUp(
          name: state.name,
          email: state.email,
          password: state.password,
          image: state.image,
        );

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

class SignupStateNotifier extends Notifier<SignupState> {
  @override
  SignupState build() {
    return SignupState(
      name: '',
      email: '',
      password: '',
      image: null,
    );
  }

  bool isValidForm() {
    return state.name.isNotEmpty &&
        state.email.isNotEmpty &&
        state.password.isNotEmpty;
  }

  set name(String value) {
    state = state.copyWith(name: value);
  }

  set email(String value) {
    state = state.copyWith(email: value);
  }

  set password(String value) {
    state = state.copyWith(password: value);
  }

  bool isDataValid() {
    return state.name.isNotEmpty &&
        state.email.isNotEmpty &&
        state.password.isNotEmpty;
  }

  void setData({
    required String name,
    required String email,
    required String password,
  }) {
    state = state.copyWith(name: name, email: email, password: password);
  }

  Future<void> pickImage(BuildContext context) async {
    PhotoSource? source = await showAdaptiveActionSheet<PhotoSource>(
      context: context,
      actions: [
        BottomSheetAction(
          title: Text(
            PhotoSource.camera.name.toUpperCase(),
            style: const TextStyle(fontSize: 16),
          ),
          onPressed: (context) {
            context.pop(PhotoSource.camera);
          },
        ),
        BottomSheetAction(
          title: Text(
            PhotoSource.gallery.name.toUpperCase(),
            style: const TextStyle(fontSize: 16),
          ),
          onPressed: (context) {
            context.pop(PhotoSource.gallery);
          },
        ),
      ],
      cancelAction: CancelAction(
        title: const Text(
          'Cancel',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );

    if (source != null) {
      final ImagePicker picker = ImagePicker();
      XFile? imageFile = await picker.pickImage(
        source: source == PhotoSource.gallery
            ? ImageSource.gallery
            : ImageSource.camera,
        maxWidth: 2600,
      );

      if (imageFile != null) {
        final image = File(imageFile.path);
        state = state.copyWith(image: image);
      }
    } else {
      return;
    }
  }
}

class SignupState {
  final String name;
  final String email;
  final String password;
  final File? image;

  SignupState({
    required this.name,
    required this.email,
    required this.password,
    required this.image,
  });

  SignupState copyWith({
    String? name,
    String? email,
    String? password,
    File? image,
  }) {
    return SignupState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      image: image ?? this.image,
    );
  }
}
