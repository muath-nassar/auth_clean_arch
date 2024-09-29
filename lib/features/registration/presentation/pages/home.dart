import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';

class HomePage extends StatelessWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${user.firstName} ${user.lastName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${user.email}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            // Text(
            //   'Created At: ${formatDateTime(user.createTime)}',
            //   style: const TextStyle(fontSize: 16),
            // ),
            const SizedBox(height: 8),
            // Text(
            //   'Last Login:  ${formatDateTime(user.lastLogin!)}',
            //   style: const TextStyle(fontSize: 16),
            // ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Handle sign out logic
              },
              child: const Text('Sign Out'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Red button for delete
              ),
              onPressed: () {
                // Handle delete account logic
              },
              child: const Text('Delete Account'),
            ),
          ],
        ),
      ),
    );
  }
}

