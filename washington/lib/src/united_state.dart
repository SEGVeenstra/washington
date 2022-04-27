part of 'washington.dart';

typedef StateHandler = void Function(Object event);

/// A State object that will receive events dispatched by [Washington].
class UnitedState<T extends Object> extends ChangeNotifier implements State<T> {
  final _handlers = <Type, StateHandler>{};
  T _value;

  /// The current value of this state.
  @override
  T get value => _value;

  Object? _error;

  /// Used to indicate that something is wrong with this state.
  @override
  Object? get error => _error;
  @override
  bool get hasError => _error != null;

  bool _isLoading;

  /// Used to indicate if this state is currently loading.
  @override
  bool get isLoading => _isLoading;

  UnitedState(
    T initialValue, {
    bool isLoading = false,
  })  : _value = initialValue,
        _isLoading = isLoading {
    Washington.instance.addListener(_dispatchEvent);
  }

  void _dispatchEvent(Object event) {
    final handler = _handlers[event.runtimeType];
    handler?.call(event);
  }

  /// Make [Washington] dispatch an event globally.
  ///
  /// Similar to calling `Washington.instance.dispatch(Event)`.
  @protected
  void dispatch(Object event) {
    Washington.instance.dispatch(event);
  }

  /// Update the state.
  ///
  /// Use `value` to set the new value for this state.
  /// Use `isLoading` to indicate that this state is still busy.
  /// Use `error` to indicate that something is wrong.
  @protected
  void setState(
    T value, {
    bool isLoading = false,
    Object? error,
  }) {
    // TODO: Experimental
    if (value == _value && error == _error && isLoading == _isLoading) {
      debugPrint(
          'UPDATE STATE $runtimeType has been ignored, state was equal!\nThis is an experimental feature.');
      return;
    }

    debugPrint('UPDATE STATE $runtimeType:');
    debugPrint('  value:    $_value -> $value');
    debugPrint('  isLoading $_isLoading -> $isLoading');
    debugPrint('  error     $_error -> $error');

    _value = value;
    _isLoading = isLoading;
    _error = error;

    notifyListeners();
  }

  /// Add a handler to handle a specific event.
  @protected
  void addHandler<Tevent>(void Function(Tevent event) handler) {
    _handlers[Tevent] = (Object e) => handler(e as Tevent);
  }

  /// Clean up this state after use.
  @override
  void dispose() {
    _handlers.clear();
    Washington.instance.removeListener(_dispatchEvent);
    super.dispose();
  }
}
