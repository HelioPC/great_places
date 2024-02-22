import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:great_places/src/common/router/app_routes.dart';
import 'package:great_places/src/common/utils/my_colors.dart';
import 'package:validatorless/validatorless.dart';
import 'package:go_router/go_router.dart';

enum PhotoSource {
  camera,
  gallery,
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool get _isFormValid => _formKey.currentState?.validate() ?? false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Register'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(top: 40),
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(
                            Icons.add_photo_alternate_sharp,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 56),
                        TextFormField(
                          // controller: _emailController,
                          onTapOutside: (_) => FocusScope.of(context).unfocus(),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: Validatorless.multiple([
                            Validatorless.required('Required field'),
                            Validatorless.email('Invalid name'),
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
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _emailController,
                          onTapOutside: (_) => FocusScope.of(context).unfocus(),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: Validatorless.multiple([
                            Validatorless.required('Required field'),
                            Validatorless.email('Invalid email'),
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
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _passwordController,
                          onTapOutside: (_) => FocusScope.of(context).unfocus(),
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
                        const SizedBox(height: 16),
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
                              onPressed: _isFormValid ? () {} : null,
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
          ],
        ),
      ),
    );
  }
}
