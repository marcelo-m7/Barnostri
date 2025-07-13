import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_models/shared_models.dart';

import 'package:barnostri_app/src/features/auth/presentation/controllers/auth_service.dart';
import 'package:barnostri_app/l10n/generated/app_localizations.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final storeNameController = TextEditingController();

  UserType _userType = UserType.cliente;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    storeNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: l10n.name),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: l10n.emailLabel),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: l10n.passwordLabel),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<UserType>(
                value: _userType,
                decoration: const InputDecoration(labelText: 'User Type'),
                items: const [
                  DropdownMenuItem(
                    value: UserType.cliente,
                    child: Text('Customer'),
                  ),
                  DropdownMenuItem(
                    value: UserType.lojista,
                    child: Text('Merchant'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _userType = value;
                    });
                  }
                },
              ),
              if (_userType == UserType.lojista) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: storeNameController,
                  decoration: const InputDecoration(labelText: 'Store Name'),
                ),
              ],
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: authState.isLoading
                      ? null
                      : () async {
                          await ref.read(authServiceProvider.notifier).signUp(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                profile: UserProfile(
                                  id: '',
                                  name: nameController.text.trim(),
                                  phone: phoneController.text.trim(),
                                  userType: _userType,
                                  storeName: _userType == UserType.lojista
                                      ? storeNameController.text.trim()
                                      : null,
                                  createdAt: DateTime.now(),
                                ),
                              );
                          if (!context.mounted) return;
                          final error = ref.read(authServiceProvider).error;
                          if (error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Registration error: $error'),
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Registration successful'),
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            );
                            if (_userType == UserType.lojista) {
                              context.go('/admin');
                            } else {
                              context.go('/menu');
                            }
                          }
                        },
                  child: authState.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Sign Up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
