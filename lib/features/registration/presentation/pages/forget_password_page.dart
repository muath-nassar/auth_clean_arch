import 'package:auth_clean_arch/core/common.dart';
import 'package:auth_clean_arch/di.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../bloc/change_password_bloc/change_password_bloc.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final ChangePasswordBloc _changePasswordBloc;
  int? foundUserId;

  @override
  void initState() {
    _changePasswordBloc = getIt<ChangePasswordBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _changePasswordBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Change Password'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            // height: MediaQuery.sizeOf(context).height / 2,
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
                  'Change Your Password',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
                  builder: (context, state) {
                    if (state is ChangePasswordInitial) {
                      return EmailToChangePassword(
                        changePasswordBloc: _changePasswordBloc,
                        loading: false,
                        failure: null,
                        emailController: _emailController,
                      );
                    }
                    if (state is SearchEmailState) {
                      return EmailToChangePassword(
                        changePasswordBloc: _changePasswordBloc,
                        loading: true,
                        failure: null,
                        emailController: _emailController,
                      );
                    }
                    if (state is InvalidEmailState) {
                      return EmailToChangePassword(
                        changePasswordBloc: _changePasswordBloc,
                        loading: false,
                        failure: state.failure,
                        emailController: _emailController,
                      );
                    }
                    if (state is UserNotFoundState) {
                      return EmailToChangePassword(
                        changePasswordBloc: _changePasswordBloc,
                        loading: false,
                        failure: state.failure, emailController: _emailController,
                      );
                    }
                    //-----------------
                    if (state is UserFoundState) {
                      foundUserId = state.id;
                      return PasswordToChangePassword(
                        changePasswordBloc: _changePasswordBloc,
                        loading: false,
                        failure: null,
                        userId: foundUserId!, passwordController: _passwordController,
                      );
                    }
                    if (state is ChangingPasswordState) {
                      return PasswordToChangePassword(
                        changePasswordBloc: _changePasswordBloc,
                        loading: true,
                        failure: null,
                        userId: foundUserId!, passwordController: _passwordController,
                      );
                    }
                    if (state is InvalidPasswordState) {
                      return PasswordToChangePassword(
                        changePasswordBloc: _changePasswordBloc,
                        loading: false,
                        failure: state.failure,
                        userId: foundUserId!,
                        passwordController: _passwordController,
                      );
                    }
                    if (state is ChangePasswordErrorState) {
                      return PasswordToChangePassword(
                        changePasswordBloc: _changePasswordBloc,
                        loading: false,
                        failure: state.failure,
                        userId: foundUserId!,
                        passwordController: _passwordController,
                      );
                    }
                    if (state is ChangePasswordSuccessState) {
                      return const Text('Password is changed');
                    }

                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmailToChangePassword extends StatelessWidget {
  const EmailToChangePassword({
    super.key,
    required this.loading,
    required this.failure,
    required this.emailController,
    required this.changePasswordBloc,
  });

  final TextEditingController emailController;
  final ChangePasswordBloc changePasswordBloc;
  final bool loading;
  final Failure? failure;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        failure != null ? failureMessagesColumn(failure!) : const SizedBox(),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            // Trigger the event to change the password
            if (loading) return;
            changePasswordBloc
                .add(SearchEmailRequest(emailController.text.trim()));
          },
          child: SizedBox(
            height: 48.0, // Set the fixed height for the button
            child: Center(
              child: !loading
                  ? const Text('Next')
                  : const SizedBox(
                      height: 12.0,
                      width: 12.0,
                      child: CircularProgressIndicator.adaptive(),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class PasswordToChangePassword extends StatelessWidget {
  const PasswordToChangePassword({
    super.key,
    required this.loading,
    required this.failure,
    required this.userId,
    required this.passwordController,
    required this.changePasswordBloc,
  });

  final TextEditingController passwordController;
  final ChangePasswordBloc changePasswordBloc;
  final bool loading;
  final Failure? failure;
  final int userId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: passwordController,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 12),
        failure != null ? failureMessagesColumn(failure!) : const SizedBox(),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            // Trigger the event to change the password
            if (loading) return;
            changePasswordBloc.add(
                ChangePasswordRequest(userId, passwordController.text.trim()));
          },
          child: SizedBox(
            height: 48.0, // Set the fixed height for the button
            child: Center(
              child: !loading
                  ? const Text('Change Password')
                  : const SizedBox(
                      height: 12.0,
                      width: 12.0,
                      child: CircularProgressIndicator.adaptive(),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
