import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:washington/washington.dart' as washington;

import 'callbacks.dart';

/// Listen to state changes
class StateListener<T extends washington.UnitedState> extends StatefulWidget {
  final Widget child;
  late final void Function(BuildContext context, washington.UnitedState state)
      _listenerCallback;

  StateListener({
    required this.child,
    required StateCallback<T> listener,
    Key? key,
  }) : super(key: key) {
    _listenerCallback = (context, state) => listener;
  }

  @override
  _StateListenerState createState() => _StateListenerState<T>();
}

class _StateListenerState<T extends washington.UnitedState>
    extends State<StateListener> {
  VoidCallback? _listener;
  T? state;

  @override
  Widget build(BuildContext context) {
    if (_listener != null) {
      state?.removeListener(_listener!);
    }

    state = context.read<T>();
    _listener = () {
      widget._listenerCallback(context, state!);
    };

    state?.addListener(_listener!);
    return widget.child;
  }

  @override
  void dispose() {
    if (_listener != null) {
      state?.removeListener(_listener!);
    }
    super.dispose();
  }
}
