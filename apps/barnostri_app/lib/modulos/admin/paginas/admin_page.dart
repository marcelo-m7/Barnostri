import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/modelos/app_models.dart';
import '../../core/servicos/order_service.dart';
import '../../core/servicos/menu_service.dart';
import '../../core/servicos/supabase/supabase_config.dart';
import '../../widgets/order_status_widget.dart';
import '../../core/tema/theme.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isAuthenticated = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _checkAuthentication();
  }

  void _checkAuthentication() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final user = SupabaseConfig.getCurrentUser();
    setState(() {
      _isAuthenticated = user != null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_isAuthenticated) {
      return _buildLoginScreen();
    }

    return _buildAdminDashboard();
  }

  Widget _buildLoginScreen() {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    bool isLogging = false;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo/Title
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.admin_panel_settings,
                  size: 64,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),

              const SizedBox(height: 32),

              Text(
                'Barnostri Admin',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Acesso restrito para funcionários',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 48),

              // Email field
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(
                    Icons.email,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Password field
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Login button
              StatefulBuilder(
                builder: (context, setState) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          isLogging
                              ? null
                              : () async {
                                setState(() => isLogging = true);

                                try {
                                  await SupabaseConfig.signInWithEmail(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  );

                                  this.setState(() {
                                    _isAuthenticated = true;
                                  });
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Erro no login: $e'),
                                      backgroundColor:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  );
                                } finally {
                                  setState(() => isLogging = false);
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child:
                          isLogging
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : Text(
                                'Entrar',
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Demo credentials
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'Credenciais de demonstração:',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Email: admin@barnostri.com',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                    ),
                    Text(
                      'Senha: admin123',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminDashboard() {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Painel Administrativo'),
        actions: [
          IconButton(
            onPressed: () async {
              await SupabaseConfig.signOut();
              setState(() {
                _isAuthenticated = false;
              });
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.onPrimary,
          unselectedLabelColor: Theme.of(
            context,
          ).colorScheme.onPrimary.withOpacity(0.7),
          indicatorColor: Theme.of(context).colorScheme.onPrimary,
          tabs: const [
            Tab(text: 'Pedidos', icon: Icon(Icons.restaurant_menu)),
            Tab(text: 'Cardápio', icon: Icon(Icons.menu_book)),
            Tab(text: 'Mesas', icon: Icon(Icons.table_restaurant)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildOrdersTab(), _buildMenuTab(), _buildTablesTab()],
      ),
    );
  }

  Widget _buildOrdersTab() {
    return Consumer<OrderService>(
      builder: (context, orderService, child) {
        return StreamBuilder<List<Pedido>>(
          stream: orderService.streamOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Erro ao carregar pedidos',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              );
            }

            final pedidos = snapshot.data ?? [];
            final activePedidos =
                pedidos
                    .where(
                      (p) => p.status != 'Entregue' && p.status != 'Cancelado',
                    )
                    .toList();

            if (activePedidos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 64,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhum pedido ativo',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Novos pedidos aparecerão aqui',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: activePedidos.length,
              itemBuilder: (context, index) {
                final pedido = activePedidos[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: OrderStatusWidget(pedido: pedido, isAdminView: true),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildMenuTab() {
    return Consumer<MenuService>(
      builder: (context, menuService, child) {
        return FutureBuilder(
          future: menuService.loadAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [Tab(text: 'Itens'), Tab(text: 'Categorias')],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildMenuItemsList(menuService),
                        _buildCategoriesList(menuService),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMenuItemsList(MenuService menuService) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: menuService.itensCardapio.length,
        itemBuilder: (context, index) {
          final item = menuService.itensCardapio[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    item.disponivel
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                child: Icon(
                  item.disponivel ? Icons.check : Icons.close,
                  color: item.disponivel ? Colors.green : Colors.red,
                ),
              ),
              title: Text(item.nome),
              subtitle: Text(OrderService().formatPrice(item.preco)),
              trailing: Switch(
                value: item.disponivel,
                onChanged: (value) {
                  menuService.toggleItemDisponibilidade(item.id);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(context, menuService),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoriesList(MenuService menuService) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: menuService.categorias.length,
        itemBuilder: (context, index) {
          final categoria = menuService.categorias[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.secondary.withOpacity(0.1),
                child: Text(categoria.ordem.toString()),
              ),
              title: Text(categoria.nome),
              subtitle: Text(
                '${menuService.getItensByCategoria(categoria.id).length} itens',
              ),
              trailing: Icon(
                categoria.ativo ? Icons.visibility : Icons.visibility_off,
                color:
                    categoria.ativo
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(context, menuService),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTablesTab() {
    return Consumer<MenuService>(
      builder: (context, menuService, child) {
        return FutureBuilder(
          future: menuService.loadMesas(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return Scaffold(
              body: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: menuService.mesas.length,
                itemBuilder: (context, index) {
                  final mesa = menuService.mesas[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            mesa.ativo
                                ? Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.1)
                                : Colors.grey.withOpacity(0.1),
                        child: Icon(
                          Icons.table_restaurant,
                          color:
                              mesa.ativo
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                        ),
                      ),
                      title: Text('Mesa ${mesa.numero}'),
                      subtitle: Text('QR: ${mesa.qrToken}'),
                      trailing: Icon(
                        mesa.ativo ? Icons.check_circle : Icons.cancel,
                        color: mesa.ativo ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => _showAddTableDialog(context, menuService),
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                foregroundColor: Theme.of(context).colorScheme.onTertiary,
                child: const Icon(Icons.add),
              ),
            );
          },
        );
      },
    );
  }

  void _showAddItemDialog(BuildContext context, MenuService menuService) {
    final nomeController = TextEditingController();
    final descricaoController = TextEditingController();
    final precoController = TextEditingController();
    String? selectedCategoryId;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Adicionar Item'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nomeController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                  ),
                  TextField(
                    controller: descricaoController,
                    decoration: const InputDecoration(labelText: 'Descrição'),
                    maxLines: 3,
                  ),
                  TextField(
                    controller: precoController,
                    decoration: const InputDecoration(labelText: 'Preço'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCategoryId,
                    decoration: const InputDecoration(labelText: 'Categoria'),
                    items:
                        menuService.categorias
                            .map(
                              (cat) => DropdownMenuItem(
                                value: cat.id,
                                child: Text(cat.nome),
                              ),
                            )
                            .toList(),
                    onChanged: (value) => selectedCategoryId = value,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (selectedCategoryId != null) {
                    await menuService.addItemCardapio(
                      nome: nomeController.text,
                      descricao: descricaoController.text,
                      preco: double.tryParse(precoController.text) ?? 0.0,
                      categoriaId: selectedCategoryId!,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Adicionar'),
              ),
            ],
          ),
    );
  }

  void _showAddCategoryDialog(BuildContext context, MenuService menuService) {
    final nomeController = TextEditingController();
    final ordemController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Adicionar Categoria'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                TextField(
                  controller: ordemController,
                  decoration: const InputDecoration(labelText: 'Ordem'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await menuService.addCategoria(
                    nome: nomeController.text,
                    ordem: int.tryParse(ordemController.text) ?? 0,
                  );
                  Navigator.pop(context);
                },
                child: const Text('Adicionar'),
              ),
            ],
          ),
    );
  }

  void _showAddTableDialog(BuildContext context, MenuService menuService) {
    final numeroController = TextEditingController();
    final qrTokenController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Adicionar Mesa'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: numeroController,
                  decoration: const InputDecoration(
                    labelText: 'Número da Mesa',
                  ),
                ),
                TextField(
                  controller: qrTokenController,
                  decoration: const InputDecoration(labelText: 'Token QR'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await menuService.addMesa(
                    numero: numeroController.text,
                    qrToken: qrTokenController.text,
                  );
                  Navigator.pop(context);
                },
                child: const Text('Adicionar'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
