import 'package:auth_clean_arch/core/common.dart';
import 'package:auth_clean_arch/features/registration/presentation/pages/sign_up_page.dart';
import 'package:flutter/material.dart';

import '../widgets/email_text_field.dart';
import '../widgets/password_text_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Use Scaffold for the page structure
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          height: MediaQuery.sizeOf(context).height / 1.5,
          width: MediaQuery.sizeOf(context).width / 3,
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
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
               EmailTextField(emailController: _emailController),
              const SizedBox(height: 16),
               PasswordTextField(passwordController: _passwordController),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Placeholder for sign-in action
                },
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Placeholder for "Forgot Password"
                },
                child: const Text('Forgot Password?'),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  navigateWithFade(context, const SignUpPage());
                },
                child: const Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


