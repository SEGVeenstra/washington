import 'package:flutter/widgets.dart' hide State;
import 'package:flutter/widgets.dart' as widgets show State;
import 'package:provider/provider.dart';
import 'package:washington/washington.dart';

import 'states.dart';

typedef UnitedStateListener<T> = void Function(
    BuildContext context, State<T> state);

typedef SuccessListener<T> = void Function(
    BuildContext context, SuccessState<T> state);

typedef LoadingListener<T> = void Function(
  BuildContext context,
  LoadingState<T> state,
);

typedef ErrorListener<T> = void Function(
  BuildContext context,
  ErrorState<T> state,
);

/// Listen to state changes
class StateListener<US extends UnitedState<V>, V extends Object>
    extends StatefulWidget {
  final Widget child;
  final UnitedStateListener<V>? listener;
  final SuccessListener<V>? successListener;
  final LoadingListener<V>? loadingListener;
  final ErrorListener<V>? errorListener;

  const StateListener({
    required this.child,
    required this.listener,
    Key? key,
  })  : successListener = null,
        loadingListener = null,
        errorListener = null,
        super(key: key);

  const StateListener.error({
    required this.child,
    required this.errorListener,
    Key? key,
  })  : successListener = null,
        loadingListener = null,
        listener = null,
        super(key: key);

  const StateListener.loading({
    required this.child,
    required this.loadingListener,
    Key? key,
  })  : successListener = null,
        errorListener = null,
        listener = null,
        super(key: key);

  const StateListener.success({
    required this.child,
    required this.successListener,
    Key? key,
  })  : errorListener = null,
        loadingListener = null,
        listener = null,
        super(key: key);

  @override
  _StateListenerState<US, V> createState() => _StateListenerState<US, V>();
}

class _StateListenerState<US extends UnitedState<V>, V extends Object>
    extends widgets.State<StateListener<US, V>> {
  VoidCallback? _listener;

  late US _unitedState;

  @override
  void initState() {
    super.initState();
    _unitedState = context.read<US>();
    _addListener();
  }

  @override
  void didUpdateWidget(covariant StateListener<US, V> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newUnitedState = context.read<US>();
    if (newUnitedState != _unitedState) {
      if (_listener != null) {
        _removeListener();
        _unitedState = newUnitedState;
      }
      _addListener();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newUnitedState = context.read<US>();
    if (newUnitedState != _unitedState) {
      if (_listener != null) {
        _removeListener();
        _unitedState = newUnitedState;
      }
      _addListener();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  void _addListener() {
    _listener = () {
      widget.listener?.call(
        context,
        State<V>(
          error: _unitedState.error,
          value: _unitedState.value,
          isLoading: _unitedState.isLoading,
        ),
      );
      if (_unitedState.hasError) {
        widget.errorListener?.call(
          context,
          ErrorState<V>(
            value: _unitedState.value,
            isLoading: _unitedState.isLoading,
            error: _unitedState.error!,
          ),
        );
      } else if (_unitedState.isLoading) {
        widget.loadingListener?.call(
          context,
          LoadingState<V>(
            value: _unitedState.value,
          ),
        );
      } else {
        widget.successListener?.call(
          context,
          SuccessState<V>(value: _unitedState.value),
        );
      }
    };
    _unitedState.addListener(_listener!);
  }

  void _removeListener() {
    _unitedState.removeListener(_listener!);
    _listener = null;
  }
}
