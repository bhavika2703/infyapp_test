import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/auth_event.dart';
import '../../../core/validators.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../widgets/auth_background.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _agreeTerms = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You must accept Terms & Conditions')));
      return;
    }
    context.read<AuthBloc>().add(SignUpRequested(_email.text.trim(), _password.text.trim(), _name.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = 520.0;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AuthBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 12, top: 24),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                      Text('Create account', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black87)),
                      SizedBox(height: 6),
                      Text('Join us — create your account in seconds', style: TextStyle(color: Colors.black54)),
                    ]),
                  ),
                  const SizedBox(height: 22),

                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                      child: BlocListener<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is AuthFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                          } else if (state is AuthSignUpSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                            Navigator.of(context).pop(); // back to login
                          }
                        },
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Name
                              TextFormField(
                                controller: _name,
                                validator: (v) => Validators.notEmpty(v, label: 'Full name'),
                                decoration: const InputDecoration(
                                  labelText: 'Full name',
                                  prefixIcon: Icon(Icons.person_outline),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 12),
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
                              const SizedBox(height: 12),
                              TextFormField(
                                controller: _confirm,
                                obscureText: true,
                                validator: (v) {
                                  if (v == null || v.isEmpty) return 'Please confirm password';
                                  if (v.trim() != _password.text.trim()) return 'Passwords do not match';
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Confirm password',
                                  prefixIcon: Icon(Icons.lock_outline),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Checkbox(value: _agreeTerms, onChanged: (val) => setState(() => _agreeTerms = val ?? false)),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => setState(() => _agreeTerms = !_agreeTerms),
                                      child: const Text(
                                        'I agree to the Terms & Conditions',
                                        style: TextStyle(decoration: TextDecoration.underline),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
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
                                      child: loading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Create account'),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 12),
                              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                const Text('Already have an account?'),
                                TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Sign in'))
                              ]),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
