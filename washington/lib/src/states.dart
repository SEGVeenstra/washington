abstract class ValueState<TValue> {
  TValue get value;
}

abstract class State<TValue> implements ValueState<TValue> {
  Object? get error;
  bool get isLoading;

  bool get hasError => error != null;
}
