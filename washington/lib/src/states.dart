class SuccessState<TValue> {
  final TValue value;

  const SuccessState({required this.value});
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

class State<TValue> {
  final TValue value;
  final Object? error;
  final bool isLoading;

  bool get hasError => error != null;

  const State({
    required this.error,
    required this.value,
    required this.isLoading,
  });
}
