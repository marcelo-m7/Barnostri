import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Base [StateNotifier] with a `guard` utility for async actions.
///
/// Subclasses must implement [setLoading] and [setError] to update the
/// state accordingly.
abstract class GuardedStateNotifier<S> extends StateNotifier<S> {
  GuardedStateNotifier(super.state);

  S setLoading(S state, bool isLoading);
  S setError(S state, String? error);

  /// Runs [action] while updating the `isLoading` and `error` fields on the
  /// state. If an exception occurs it will be converted to a string via
  /// [onError] if provided.
  Future<T?> guard<T>(Future<T> Function() action,
      {String Function(Object error)? onError}) async {
    state = setLoading(state, true);
    state = setError(state, null);
    try {
      return await action();
    } catch (e) {
      state = setError(state, onError != null ? onError(e) : e.toString());
      return null;
    } finally {
      state = setLoading(state, false);
    }
  }
}
