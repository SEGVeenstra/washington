import 'package:flutter/material.dart';

part 'united_state.dart';

typedef EventCallback = void Function(Object state);

class Washington {
  static Washington? _instance;
  static Washington get instance => _instance ??= Washington._();

  Washington._();

  final _eventListeners = <EventCallback>[];
  final states = <UnitedState>[];

  void addListener(EventCallback listener) => _eventListeners.add(listener);

  void removeListener(EventCallback listener) =>
      _eventListeners.remove(listener);

  void _add(UnitedState state) {
    states.add(state);
  }

  void _remove(UnitedState state) {
    states.remove(state);
  }

  void dispatch(Object event) {
    for (final callback in _eventListeners) {
      callback(event);
    }
    for (final state in states) {
      state._dispatchEvent(event);
    }
  }
}
