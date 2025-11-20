import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      String uid = '';
      if (state is AuthAuthenticated) uid = state.uid;
      // If you want user details (name/email) pull from Firestore user doc or auth repo.

      return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User ID: $uid'),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Sign out'),
                onPressed: () {
                  context.read<AuthBloc>().add(SignOutRequested());
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
