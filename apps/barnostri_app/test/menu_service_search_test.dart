import 'package:flutter_test/flutter_test.dart';
import 'package:barnostri_app/src/features/menu/presentation/controllers/menu_service.dart';
import 'package:barnostri_app/src/features/menu/data/repositories/supabase_menu_repository.dart';
import 'package:shared_models/shared_models.dart';

void main() {
  group('MenuService.searchItems', () {
    late MenuService service;

    setUp(() {
      final repo = SupabaseMenuRepository(null);
      final loadUseCase = LoadMenuUseCase(repo);
      service = MenuService(repo, loadUseCase);

      final items = [
        MenuItem(
          id: '1',
          name: 'Pizza Margherita',
          description: 'Classic Italian pizza',
          price: 10.0,
          categoryId: 'c1',
          available: true,
          imageUrl: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        MenuItem(
          id: '2',
          name: 'Cheeseburger',
          description: 'Juicy beef burger with cheese',
          price: 8.0,
          categoryId: 'c1',
          available: true,
          imageUrl: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        MenuItem(
          id: '3',
          name: 'Pasta Carbonara',
          description: 'Creamy pasta dish',
          price: 12.0,
          categoryId: 'c2',
          available: true,
          imageUrl: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        MenuItem(
          id: '4',
          name: 'Moqueca de Camarão',
          description: 'Moqueca típica com camarão fresco',
          price: 25.0,
          categoryId: 'c2',
          available: true,
          imageUrl: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        MenuItem(
          id: '5',
          name: 'Pão de Queijo',
          description: 'Delicioso pão mineiro',
          price: 6.0,
          categoryId: 'c2',
          available: true,
          imageUrl: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
      service.state = service.state.copyWith(menuItems: items);
    });

    test('returns all items when query is empty', () {
      final results = service.searchItems('');
      expect(results.length, 5);
    });

    test('matches name case-insensitively', () {
      final results = service.searchItems('pIzZa');
      expect(results.length, 1);
      expect(results.first.name, 'Pizza Margherita');
    });

    test('matches description text', () {
      final results = service.searchItems('creamy');
      expect(results.length, 1);
      expect(results.first.name, 'Pasta Carbonara');
    });

    test('matches ignoring diacritics in query', () {
      final results = service.searchItems('pao');
      expect(results.length, 1);
      expect(results.first.name, 'Pão de Queijo');
    });

    test('matches regardless of accents in data', () {
      final results = service.searchItems('Moqueca');
      expect(results.length, 1);
      expect(results.first.name, 'Moqueca de Camarão');
    });

    test('matches when query contains accents', () {
      final results = service.searchItems('Moquéca');
      expect(results.length, 1);
      expect(results.first.name, 'Moqueca de Camarão');
    });

    test('returns empty list when no match', () {
      final results = service.searchItems('sushi');
      expect(results, isEmpty);
    });
  });
}
