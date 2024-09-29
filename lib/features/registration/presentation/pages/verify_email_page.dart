import 'package:auth_clean_arch/core/common.dart';
import 'package:auth_clean_arch/di.dart';
import 'package:auth_clean_arch/features/registration/presentation/bloc/verify_email_bloc/verify_email_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmailPage extends StatefulWidget {
  final String? providedEmail;

  const VerifyEmailPage({super.key, this.providedEmail});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  late final VerifyEmailBloc _bloc;

  @override
  void initState() {
    // _bloc = getIt<VerifyEmailBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _codeController = TextEditingController();

    return BlocProvider(
      create: (context) => _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Verify Email'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(24.0),
            height: MediaQuery.sizeOf(context).height / 1.8,
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Verify Your Email',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Email Input
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Code Input
                TextField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    labelText: 'Verification Code',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                BlocBuilder<VerifyEmailBloc, VerifyEmailState>(
                  builder: (context, state) {
                    if(state is InvalidEmail){
                      return failureMessagesColumn(state.failure);
                    }
                    if(state is SendError){
                      return failureMessagesColumn(state.failure);
                    }
                    if (state is Sending) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    if(state is SendSuccess){
                      return const Text('Please check your email. You should have the code.');
                    }
                    if(state is UnverifiedEmail){
                      return const Text('Wrong code. please check your email.');
                    }
                    if(state is VerifiedEmail){
                      return const Text('your email is verified now.');

                    }


                    return Container();
                  },
                )
                ,
                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    // Handle submit action
                    // String email = _emailController.text;
                     String code = _codeController.text.trim();
                    _bloc.add( VerifyCodeEvent(code));
                    // Trigger the verification process here
                  },
                  child: const Text('Submit'),
                ),
                const SizedBox(height: 16),

                // Resend Button
                TextButton(
                  onPressed: () {
                    _bloc.add(SendEmailEvent(_emailController.text.trim()));
                  },
                  child: const Text('Send Code'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
