part of 'washington.dart';

typedef StateHandler = void Function(Object event);

class UnitedState<T> extends ChangeNotifier {
  final _handlers = <Type, StateHandler>{};
  T _value;
  T get value => _value;

  UnitedState(T initialValue) : _value = initialValue {
    Washington.instance._add(this);
  }

  void _dispatchEvent(Object event) {
    final handler = _handlers[event.runtimeType];
    handler?.call(event);
  }

  void updateState(T value) {
    _value = value;
    notifyListeners();
  }

  void addHandler<Event>(StateHandler handler) {
    _handlers[Event] = handler;
  }

  void destroy() {
    _handlers.clear();
    Washington.instance._remove(this);
  }
}
