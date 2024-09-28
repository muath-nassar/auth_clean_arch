import 'package:auth_clean_arch/core/common.dart';
import 'package:auth_clean_arch/di.dart';
import 'package:auth_clean_arch/features/registration/presentation/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:auth_clean_arch/features/registration/presentation/pages/home.dart';
import 'package:auth_clean_arch/features/registration/presentation/pages/sign_up_page.dart';
import 'package:auth_clean_arch/features/registration/presentation/pages/verify_email_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/email_text_field.dart';
import '../widgets/password_text_field.dart';
import 'forget_password_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final SignInBloc _signInBloc;

  @override
  void initState() {
    _signInBloc = getIt<SignInBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Use Scaffold for the page structure
    return BlocProvider(
      create: (context) => _signInBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign In'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            height: MediaQuery.sizeOf(context).height / 1.5,
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
                BlocListener<SignInBloc, SignInState>(
                    listener: (context, state) {
                  if (state is Success) {

                    navigateWithFade(context, HomePage(user: state.user,));
                  }
                },
                child: BlocBuilder<SignInBloc, SignInState>(
                  builder: (context, state) {
                    if (state is ValidationError) {
                      return failureMessagesColumn(state.failure);
                    }
                    if (state is LoginError) {
                      return failureMessagesColumn(state.failure);
                    }
                    if (state is Loading) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }

                    return Container();
                  },
                ),),

                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    _signInBloc.add(SignInRequest(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim()));
                  },
                  child: const Text('Sign In'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VerifyEmailPage()));
                  },
                  child: const Text('Verify your email'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChangePasswordPage()));
                  },
                  child: const Text('Forgot Password?'),
                ),
                // const Spacer(),
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
      ),
    );
  }
}
