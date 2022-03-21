import 'package:flutter/material.dart';

part 'united_state.dart';

typedef EventCallback = void Function(Object event);

/// Global event dispatcher and state uniter.
///
/// Use Washington to globally dispatch events to all instantiated UnitedStates.
///
/// You can  also add listeners to receive the events that are being dispatched.
class Washington {
  static Washington? _instance;

  /// Get the global instance of [Washington].
  static Washington get instance => _instance ??= Washington._();

  /// Get the global instance of Washington.
  ///
  /// Short notation for `Washington.instance`.
  static Washington get i => instance;

  /// Get the global instance of Washington.
  ///
  /// Short notation for `Washington.instance`.
  static Washington get dc => instance;

  Washington._();

  final _eventListeners = <EventCallback>{};

  /// Add a listener.
  void addListener(EventCallback listener) => _eventListeners.add(listener);

  /// Remove a listener.
  void removeListener(EventCallback listener) =>
      _eventListeners.remove(listener);

  /// Dispatch an [event] to all listeners.
  void dispatch(Object event) {
    debugPrint('DISPATCH EVENT -> $event');
    for (final callback in _eventListeners) {
      callback(event);
    }
  }

  /// Reset [Washington] by clearing all listeners and the instance.
  @visibleForTesting
  void reset() {
    _eventListeners.clear();
    _instance = null;
  }

  /// Feed an instance to be used by [Washington].
  @visibleForTesting
  void feedInstance(Washington instance) {
    _instance = instance;
  }
}
