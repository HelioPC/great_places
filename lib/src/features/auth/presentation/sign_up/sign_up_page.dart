import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:great_places/src/common/router/app_routes.dart';
import 'package:great_places/src/common/utils/my_colors.dart';
import 'package:great_places/src/features/auth/presentation/sign_up/sign_up_controller.dart';
import 'package:validatorless/validatorless.dart';
import 'package:go_router/go_router.dart';

enum PhotoSource {
  camera,
  gallery,
}

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool isLoading = false;

  bool get _isFormValid => _formKey.currentState?.validate() ?? false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(signupStateNotifier);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Register',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                height: 300,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: isLoading ? null : () async {
                        await ref
                            .read(signupStateNotifier.notifier)
                            .pickImage(context);
                      },
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(200),
                        ),
                        child: signupState.image == null
                            ? const Icon(
                                Icons.add_photo_alternate_sharp,
                                color: Colors.black,
                                size: 20,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(180),
                                child: Image.file(
                                  signupState.image!,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    const Text(
                      'Profile picture',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(top: 36),
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  child: Visibility(
                    visible: !isLoading,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            onTapOutside: (_) => FocusScope.of(context).unfocus(),
                            onFieldSubmitted: (_) => setState(() {}),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            validator: Validatorless.multiple([
                              Validatorless.required('Required field'),
                              Validatorless.min(2, 'Invalid name'),
                              Validatorless.max(16, 'Invalid name'),
                            ]),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person),
                              prefixIconColor: MyColors.green,
                              isDense: true,
                              labelText: 'Username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _emailController,
                            onTapOutside: (_) => FocusScope.of(context).unfocus(),
                            onFieldSubmitted: (_) => setState(() {}),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: Validatorless.multiple([
                              Validatorless.required('Required field'),
                              Validatorless.email('Invalid name'),
                            ]),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email),
                              prefixIconColor: MyColors.green,
                              isDense: true,
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            onTapOutside: (_) => FocusScope.of(context).unfocus(),
                            onFieldSubmitted: (_) => setState(() {}),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            validator: Validatorless.multiple([
                              Validatorless.required('Required field'),
                              Validatorless.min(
                                  6, 'Password must have at least 6 characters'),
                              Validatorless.regex(
                                RegExp(
                                  r'^(?=.*?[0-9])(?=.*?[^\w\s]).{6,}$',
                                ),
                                'Password must contain 1 number and 1 special character',
                              ),
                            ]),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              prefixIconColor: MyColors.green,
                              isDense: true,
                              labelText: 'Confirm your password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                              children: [
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context.pushNamed(AppRoutes.login.name);
                                    },
                                  text: 'Login',
                                  style: const TextStyle(
                                    color: MyColors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: _isFormValid && !isLoading
                                    ? () async {
                                  setState(() => isLoading = true);
                                  ref
                                      .read(signupStateNotifier.notifier)
                                      .setData(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  );
                                  await ref
                                      .read(signupControllerProvider)
                                      .signUp();
                                  setState(() => isLoading = false);
                                }
                                    : null,
                                child: const Text(
                                  'Register',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
