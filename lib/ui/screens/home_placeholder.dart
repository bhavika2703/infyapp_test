import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_event.dart';

class HomePlaceholder extends StatelessWidget {
  const HomePlaceholder({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(child: ElevatedButton(onPressed: () => context.read<AuthBloc>().add(SignOutRequested()), child: const Text('Sign out'))),
    );
  }
}
