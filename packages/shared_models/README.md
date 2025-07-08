# Shared Models

This package contains common data models and services used by the Barnostri Flutter application. It prevents duplication between customer and admin features.

## Models

The `lib/src/models` directory defines the data structures that mirror the Supabase tables:

- `TableModel` – represents a restaurant table identified by a QR code token.
- `CategoryModel` – menu category used to group `MenuItem` entries.
- `MenuItem` – individual menu item belonging to a category.
- `Order` and `OrderItem` – an order placed for a table and its items.
- `Payment` – payment information for an order.
- `UserModel` – user record with an `isAdmin` helper.
- `CartItem` – local cart item used before sending an order.
- Enums `OrderStatus` and `PaymentMethod` describe possible statuses and payment methods.

## Services

### supabase_config.dart

The `supabase_config.dart` service centralizes access to Supabase. It initializes the `SupabaseClient`, provides authentication helpers, and includes methods to fetch tables, categories, menu items and orders. It also exposes functions to create orders, update order status and stream order changes in real time.
