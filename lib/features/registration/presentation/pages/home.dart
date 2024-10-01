import 'package:auth_clean_arch/core/common.dart';
import 'package:auth_clean_arch/di.dart';
import 'package:auth_clean_arch/features/registration/presentation/bloc/home_bloc/home_bloc.dart';
import 'package:auth_clean_arch/features/registration/presentation/pages/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeBloc _homeBloc;

  @override
  void initState() {
    _homeBloc = getIt<HomeBloc>();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => getIt<HomeBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name: ${widget.user.firstName} ${widget.user.lastName}',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Email: ${widget.user.email}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              BlocListener<HomeBloc, HomeState>(
                bloc: _homeBloc, // Pass your HomeBloc instance
                listener: (context, state) {
                  if (state is UserDeleted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("User deleted"),
                        duration: Duration(seconds: 3),
                      ),
                    );
                    navigateWithFade(context, const SignInPage());
                  } else if (state is UserDeleteError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: failureMessagesColumn(state.failure),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  } else if (state is SignedOut) {
                    navigateWithFade(context, const SignInPage());
                  }
                },
                child: Container(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  _showSignOutDialog(context);
                },
                child: const Text('Sign Out'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Red button for delete
                ),
                onPressed: () {
                  _showDeleteDialog(context);
                },
                child: const Text('Delete Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Are you sure you want to proceed?"),
          actions: <Widget>[
            // Dismiss Button
            TextButton(
              child: const Text("Dismiss"),
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
            ),
            // Confirm Button
            TextButton(
              child: const Text("Sig Out"),
              onPressed: () {
                Navigator.of(context).pop();
                _homeBloc.add(SignOutRequest());
                debugPrint("Sign Out Confirmed!");
              },
            ),
          ],
        );
      },
    );
  }


  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Are you sure you want to proceed?"),
          actions: <Widget>[
            // Dismiss Button
            TextButton(
              child: const Text("Dismiss"),
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
            ),
            // Confirm Button
            TextButton(
              child: const Text("Delete user"),
              onPressed: () {
                Navigator.of(context).pop();
                _homeBloc.add(DeleteUserRequest(widget.user.id!));
                debugPrint("Delete Confirmed!");
              },
            ),
          ],
        );
      },
    );
  }

}

