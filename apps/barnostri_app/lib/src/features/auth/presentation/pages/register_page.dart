import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_models/shared_models.dart';
import 'package:barnostri_app/src/features/auth/presentation/controllers/auth_service.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _storeNameController = TextEditingController();
  UserType _selectedType = UserType.cliente;

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Telefone'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<UserType>(
              value: _selectedType,
              decoration: const InputDecoration(labelText: 'Tipo de usuário'),
              items: UserType.values
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.value)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedType = val ?? UserType.cliente),
            ),
            if (_selectedType == UserType.lojista) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _storeNameController,
                decoration: const InputDecoration(labelText: 'Nome da loja'),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: authState.isLoading
                  ? null
                  : () async {
                      await ref.read(authServiceProvider.notifier).register(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                            name: _nameController.text.trim(),
                            userType: _selectedType,
                            phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
                            storeName: _storeNameController.text.trim().isEmpty ? null : _storeNameController.text.trim(),
                          );
                      if (!context.mounted) return;
                      final error = ref.read(authServiceProvider).error;
                      if (error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro: \$error')),
                        );
                      } else {
                        context.pop();
                      }
                    },
              child: authState.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}

