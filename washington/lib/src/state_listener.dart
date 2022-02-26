import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:washington/washington.dart';

class StateListener<T extends UnitedState> extends StatefulWidget {
  final Widget child;
  final void Function(BuildContext context, T state) listener;
  late final void Function(BuildContext context, UnitedState state)
      _listenerCallback;

  StateListener({
    required this.child,
    required this.listener,
    Key? key,
  }) : super(key: key) {
    _listenerCallback = (context, state) => listener(context, state as T);
  }

  @override
  _StateListenerState createState() => _StateListenerState<T>();
}

class _StateListenerState<T extends UnitedState> extends State<StateListener> {
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
