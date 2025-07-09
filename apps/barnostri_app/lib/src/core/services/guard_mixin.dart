import "package:flutter_riverpod/flutter_riverpod.dart";
mixin GuardMixin<S> on StateNotifier<S> {
  S get state;
  set state(S value);

  S copyWithGuard(S state, {bool? isLoading, String? error});

  Future<T?> guard<T>(Future<T> Function() action,
      {String Function(Object)? onError}) async {
    state = copyWithGuard(state, isLoading: true, error: null);
    try {
      return await action();
    } catch (e) {
      state =
          copyWithGuard(state, error: onError != null ? onError(e) : e.toString());
      return null;
    } finally {
      state = copyWithGuard(state, isLoading: false);
    }
  }
}
