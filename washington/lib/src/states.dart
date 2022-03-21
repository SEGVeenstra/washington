class SuccessState<TValue> {
  final TValue value;

  const SuccessState({required this.value});
}

class LoadingState<TValue> {
  final TValue value;

  const LoadingState({required this.value});
}

class ErrorState<TValue> {
  final TValue value;
  final Object error;
  final bool isLoading;

  const ErrorState({
    required this.error,
    required this.value,
    required this.isLoading,
  });
}

class BasicState<TValue> {
  final TValue value;
  final Object? error;
  final bool isLoading;

  bool get hasError => error != null;

  const BasicState({
    required this.error,
    required this.value,
    required this.isLoading,
  });
}
