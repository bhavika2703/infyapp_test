import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infyapp_test/ui/screens/signup_screen.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_event.dart';
import '../../../blocs/auth/auth_state.dart';
import '../../../core/validators.dart';
import '../widgets/auth_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(SignInRequested(_email.text.trim(), _password.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = 460.0;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AuthBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // small intro block aligned left over wave
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 12, top: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Sign in', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black87)),
                        SizedBox(height: 6),
                        Text('Welcome back — please login to continue', style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Card with form
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Email
                            TextFormField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.email,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.mail_outline),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Password
                            TextFormField(
                              controller: _password,
                              obscureText: true,
                              validator: Validators.password,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock_outline),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Login button
                            SizedBox(
                              width: double.infinity,
                              child: BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  final loading = state is AuthLoading;
                                  return ElevatedButton(
                                    onPressed: loading ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: loading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Login', style: TextStyle(fontSize: 16)),
                                  );
                                },
                              ),
                            ),

                            const SizedBox(height: 12),
                            // Signup link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have an account?"),
                                TextButton(
                                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignupScreen())),
                                  child: const Text('Sign up'),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
                  const Text('By signing in you agree to our Terms & Privacy', style: TextStyle(color: Colors.black45, fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
