import 'package:auth_clean_arch/core/common.dart';
import 'package:auth_clean_arch/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/change_password_bloc/change_password_bloc.dart';
import '../bloc/sign_in_bloc/sign_in_bloc.dart'; // Import your ChangePasswordBloc

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationCodeController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  late final ChangePasswordBloc _changePasswordBloc;

  @override
  void initState() {
    // _changePasswordBloc = getIt<ChangePasswordBloc>();
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
                  'Change Your Password',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _verificationCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Verification Code',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

            BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
              builder: (context, state) {
                if (state is Loading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (state is ChangePasswordSuccessState) {
                  return const Text('Password changed successfully!');
                }
                if (state is ChangePasswordErrorState) {
                  return failureMessagesColumn(state.failure);
                }
                if (state is InvalidEmailState) {
                  return failureMessagesColumn(state.failure);
                }
                if (state is InvalidPasswordState) {
                  return failureMessagesColumn(state.failure);
                }
                if (state is SendErrorState) {
                  return failureMessagesColumn(state.failure);
                }
                if (state is SendSuccessState) {
                  return const Text('Password reset email sent successfully!');
                }
                // Initial or default state
                return Container();
              },
            )


            ,
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Trigger the event to send the verification code
                    _changePasswordBloc.add(SendEmail(
                      _emailController.text.trim(),
                    ));
                  },
                  child: const Text('Send Code'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Trigger the event to change the password
                    _changePasswordBloc.add(ChangePasswordRequest(
                      _newPasswordController.text.trim(),
                      _verificationCodeController.text.trim(),
                    ));
                  },
                  child: const Text('Change Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
