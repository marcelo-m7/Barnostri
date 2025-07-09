import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barnostri_app/src/features/menu/presentation/pages/menu_page.dart';
import 'package:barnostri_app/src/features/menu/presentation/controllers/menu_service.dart';
import 'package:barnostri_app/src/features/menu/data/repositories/supabase_menu_repository.dart';
import 'package:barnostri_app/src/features/menu/data/usecases/load_menu_usecase.dart';

Future<ProviderContainer> _createContainer() async {
  final repo = SupabaseMenuRepository(null);
  final service = MenuService(repo, LoadMenuUseCase(repo));
  await service.loadAll();
  final container = ProviderContainer(overrides: [
    menuServiceProvider.overrideWith((ref) => service),
  ]);
  addTearDown(container.dispose);
  return container;
}

void main() {
  testWidgets('Menu grid adapts to screen width', (tester) async {
    final container = await _createContainer();

    await tester.binding.setSurfaceSize(const Size(1200, 800));
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: MenuPage()),
      ),
    );
    await tester.pumpAndSettle();

    final grid = tester.widget<GridView>(find.byType(GridView).first);
    final delegate = grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegate.crossAxisCount, greaterThan(1));

    await tester.binding.setSurfaceSize(const Size(400, 800));
    await tester.pumpAndSettle();

    final gridSmall = tester.widget<GridView>(find.byType(GridView).first);
    final delegateSmall = gridSmall.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegateSmall.crossAxisCount, 1);
  });
}
