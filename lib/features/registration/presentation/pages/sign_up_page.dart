import 'package:auth_clean_arch/core/common.dart';
import 'package:auth_clean_arch/features/registration/presentation/pages/forget_password_page.dart';
import 'package:auth_clean_arch/features/registration/presentation/pages/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/sign_up_bloc/sign_up_bloc.dart';
import '../widgets/email_text_field.dart';
import '../widgets/password_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final SignUpBloc _signUpBloc;

  @override
  void initState() {
    // _signUpBloc = getIt<SignUpBloc>();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => _signUpBloc,
  child: Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          height: MediaQuery.sizeOf(context).height / 1.1,
          width: MediaQuery.sizeOf(context).width / 1.2,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Create an Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // First Name and Last Name Fields
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Email Field
              EmailTextField(emailController: _emailController),
              const SizedBox(height: 16),
              // Password Field
              PasswordTextField(passwordController: _passwordController),
              BlocBuilder<SignUpBloc, SignUpState>(
                builder: (context, state) {
                  if (state is Error) {
                    return failureMessagesColumn(state.failure);
                  }
                  if (state is Success) {

                    return const Text('User created successfully');
                  }
                  if (state is Loading) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  newUserRequest();
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const ChangePasswordPage()));
                },
                child: const Text('Forgot Password?'),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInPage()),
                    (Route<dynamic> route) =>
                        false, // This will remove all previous routes
                  );
                },
                child: const Text("Already have an account? Sign In"),
              ),
            ],
          ),
        ),
      ),
    ),
);
  }

  void newUserRequest() {
    _signUpBloc.add(SignUpRequest(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim()));
  }
}
