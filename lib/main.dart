import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:infyapp_test/ui/screens/login_screen.dart';
import 'package:infyapp_test/ui/screens/main/main_screen.dart';
import 'blocs/video/video.bloc.dart';
import 'di.dart';
import 'firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'blocs/auth/auth_state.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initDi();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) => getIt<AuthBloc>()..add(AuthCheckRequested()),
          ),
          BlocProvider<VideoBloc>(
            create: (_) => getIt<VideoBloc>(),
          ),
        ],
      child: MaterialApp(
        title: 'infyaap',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const EntryPoint(),
      ),
    );
  }
}

class EntryPoint extends StatelessWidget {
  const EntryPoint({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthInitial || state is AuthLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
      if (state is AuthAuthenticated) return const MainScreen();
      return const LoginScreen();
    });
  }
}
