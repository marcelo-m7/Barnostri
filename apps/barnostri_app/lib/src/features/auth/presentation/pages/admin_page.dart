import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_models/shared_models.dart';
import 'package:barnostri_app/src/features/order/presentation/controllers/order_service.dart';
import 'package:barnostri_app/src/features/auth/presentation/controllers/auth_service.dart';
import 'package:barnostri_app/src/features/menu/presentation/controllers/menu_service.dart';
import 'package:barnostri_app/src/widgets/order_status_widget.dart';
import 'package:barnostri_app/l10n/generated/app_localizations.dart';

class AdminPage extends ConsumerStatefulWidget {
  const AdminPage({super.key});

  @override
  ConsumerState<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends ConsumerState<AdminPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authServiceProvider);
    if (authState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!authState.isAuthenticated) {
      return _buildLoginScreen();
    }

    return _buildAdminDashboard();
  }

  Widget _buildLoginScreen() {
    final l10n = AppLocalizations.of(context);
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final authState = ref.watch(authServiceProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
                l10n.adminTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                l10n.adminRestricted,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                ),
              ),

              const SizedBox(height: 48),

              // Email field
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: l10n.emailLabel,
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
                      ).colorScheme.outline.withAlpha((0.3 * 255).round()),
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
                  labelText: l10n.passwordLabel,
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
                      ).colorScheme.outline.withAlpha((0.3 * 255).round()),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Login button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: authState.isLoading
                      ? null
                      : () async {
                          await ref
                              .read(authServiceProvider.notifier)
                              .login(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                          if (!context.mounted) return;
                          final error = ref.read(authServiceProvider).error;
                          if (error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Erro no login: $error'),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.error,
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: authState.isLoading
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
              ),
              const SizedBox(height: 24),

              // Demo credentials
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      l10n.demoCredentialsTitle,
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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(l10n.adminPanel),
        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(authServiceProvider.notifier).logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.onPrimary,
          unselectedLabelColor: Theme.of(
            context,
          ).colorScheme.onPrimary.withAlpha((0.7 * 255).round()),
          indicatorColor: Theme.of(context).colorScheme.onPrimary,
          tabs: [
            Tab(text: l10n.orders, icon: const Icon(Icons.restaurant_menu)),
            Tab(text: l10n.menu, icon: const Icon(Icons.menu_book)),
            Tab(text: l10n.tables, icon: const Icon(Icons.table_restaurant)),
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
    return Builder(
      builder: (context) {
        final orderService = ref.watch(orderServiceProvider.notifier);
        final l10n = AppLocalizations.of(context);
        return StreamBuilder<List<Order>>(
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
                      l10n.errorLoadingOrders,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
              );
            }

            final orders = snapshot.data ?? [];
            final activeOrders = orders
                .where((p) => p.status != 'Entregue' && p.status != 'Cancelado')
                .toList();

            if (activeOrders.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 64,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha((0.3 * 255).round()),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noActiveOrders,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.newOrdersAppearHere,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha((0.7 * 255).round()),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: activeOrders.length,
              itemBuilder: (context, index) {
                final order = activeOrders[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: OrderStatusWidget(order: order, isAdminView: true),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildMenuTab() {
    return Builder(
      builder: (context) {
        final menuService = ref.watch(menuServiceProvider.notifier);
        final l10n = AppLocalizations.of(context);
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
                  TabBar(
                    tabs: [
                      Tab(text: l10n.items),
                      Tab(text: l10n.categories),
                    ],
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
    final menuState = ref.watch(menuServiceProvider);
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: menuState.menuItems.length,
        itemBuilder: (context, index) {
          final item = menuState.menuItems[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: item.available
                    ? Colors.green.withAlpha((0.1 * 255).round())
                    : Colors.red.withAlpha((0.1 * 255).round()),
                child: Icon(
                  item.available ? Icons.check : Icons.close,
                  color: item.available ? Colors.green : Colors.red,
                ),
              ),
              title: Text(item.name),
              subtitle: Text(formatCurrency(item.price)),
              trailing: Switch(
                value: item.available,
                onChanged: (value) {
                  menuService.toggleItemAvailability(item.id);
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
    final menuState = ref.watch(menuServiceProvider);
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: menuState.categories.length,
        itemBuilder: (context, index) {
          final category = menuState.categories[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.secondary.withAlpha((0.1 * 255).round()),
                child: Text(category.sortOrder.toString()),
              ),
              title: Text(category.name),
              subtitle: Text(
                '${menuService.getItemsByCategory(category.id).length} itens',
              ),
              trailing: Icon(
                category.active ? Icons.visibility : Icons.visibility_off,
                color: category.active
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha((0.5 * 255).round()),
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
    return Builder(
      builder: (context) {
        final menuService = ref.watch(menuServiceProvider.notifier);
        final menuState = ref.watch(menuServiceProvider);
        return FutureBuilder(
          future: menuService.loadTables(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return Scaffold(
              body: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: menuState.tables.length,
                itemBuilder: (context, index) {
                  final table = menuState.tables[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: table.active
                            ? Theme.of(context).colorScheme.primary.withAlpha(
                                (0.1 * 255).round(),
                              )
                            : Colors.grey.withAlpha((0.1 * 255).round()),
                        child: Icon(
                          Icons.table_restaurant,
                          color: table.active
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                        ),
                      ),
                      title: Text(
                        AppLocalizations.of(context).tableNumber(table.number),
                      ),
                      subtitle: Text('QR: ${table.qrToken}'),
                      trailing: Icon(
                        table.active ? Icons.check_circle : Icons.cancel,
                        color: table.active ? Colors.green : Colors.red,
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
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).addItem),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).name,
                ),
              ),
              TextField(
                controller: descricaoController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).description,
                ),
                maxLines: 3,
              ),
              TextField(
                controller: precoController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).price,
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategoryId,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).category,
                ),
                items: ref
                    .read(menuServiceProvider)
                    .categories
                    .map(
                      (cat) => DropdownMenuItem(
                        value: cat.id,
                        child: Text(cat.name),
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
            child: Text(AppLocalizations.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              if (selectedCategoryId != null) {
                await menuService.addMenuItem(
                  name: nomeController.text,
                  description: descricaoController.text,
                  price: double.tryParse(precoController.text) ?? 0.0,
                  categoryId: selectedCategoryId!,
                );
                if (!context.mounted) return;
                Navigator.pop(context);
              }
            },
            child: Text(AppLocalizations.of(context).add),
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
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).addCategory),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).name,
              ),
            ),
            TextField(
              controller: ordemController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).orderField,
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              await menuService.addCategory(
                name: nomeController.text,
                sortOrder: int.tryParse(ordemController.text) ?? 0,
              );
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).add),
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
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).addTable),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: numeroController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).tableNumberLabel,
              ),
            ),
            TextField(
              controller: qrTokenController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).qrToken,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              await menuService.addTable(
                number: numeroController.text,
                qrToken: qrTokenController.text,
              );

              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).add),
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
