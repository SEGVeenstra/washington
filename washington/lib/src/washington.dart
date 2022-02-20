import 'package:flutter/material.dart';

part 'united_state.dart';

class Washington {
  static Washington? _instance;
  static Washington get instance => _instance ??= Washington._();

  Washington._();

  final states = <UnitedState>[];

  void _add(UnitedState state) {
    states.add(state);
  }

  void _remove(UnitedState state) {
    states.remove(state);
  }

  void dispatch(Object event) {
    for (final state in states) {
      state._dispatchEvent(event);
    }
  }
}
