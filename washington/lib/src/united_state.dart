part of 'washington.dart';

typedef StateHandler = void Function(Object event);

class UnitedState<T extends Object> extends ChangeNotifier {
  final _handlers = <Type, StateHandler>{};
  T _value;
  T get value => _value;

  Object? _error;
  Object? get error => _error;
  bool get hasError => _error != null;

  bool _isLoading;
  bool get isLoading => _isLoading;

  UnitedState(
    T initialValue, {
    bool isLoading = false,
  })  : _value = initialValue,
        _isLoading = isLoading {
    Washington.instance._add(this);
  }

  void _dispatchEvent(Object event) {
    final handler = _handlers[event.runtimeType];
    handler?.call(event);
  }

  @protected
  void dispatch(Object event) {
    Washington.instance.dispatch(event);
  }

  @protected
  void setState(
    T value, {
    bool isLoading = false,
    Object? error,
  }) {
    debugPrint('UPDATE STATE $runtimeType:');
    debugPrint('  value:    $_value -> $value');
    debugPrint('  isLoading $_isLoading -> $isLoading');
    debugPrint('  error     $_error -> $error');

    _value = value;
    _isLoading = isLoading;
    _error = error;

    notifyListeners();
  }

  @protected
  void addHandler<Tevent>(void Function(Tevent event) handler) {
    _handlers[Tevent] = (Object e) => handler(e as Tevent);
  }

  @override
  void dispose() {
    _handlers.clear();
    Washington.instance._remove(this);
    super.dispose();
  }
}
