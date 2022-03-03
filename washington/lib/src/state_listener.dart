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
      print('$this - _listener == null');
      state?.removeListener(_listener!);
      print('$this - _listener has been removed');
    }

    state = context.read<T>();
    _listener = () {
      widget._listenerCallback(context, state!);
    };
    print('_listener has been set');

    state?.addListener(_listener!);
    print('$this - _listener has been added as listener to state');
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
