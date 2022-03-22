import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:washington/washington.dart' as washington;

typedef UnitedStateListener<T> = void Function(
    BuildContext context, washington.BasicState<T> state);

typedef SuccessListener<T> = void Function(
    BuildContext context, washington.SuccessState<T> state);

typedef LoadingListener<T> = void Function(
  BuildContext context,
  washington.LoadingState<T> state,
);

typedef ErrorListener<T> = void Function(
  BuildContext context,
  washington.ErrorState<T> state,
);

/// Listen to state changes
class StateListener<US extends washington.UnitedState<V>, V extends Object>
    extends StatefulWidget {
  final Widget child;
  final UnitedStateListener<V>? listener;
  final SuccessListener<V>? successListener;
  final LoadingListener<V>? loadingListener;
  final ErrorListener<V>? errorListener;

  const StateListener({
    required this.child,
    required this.successListener,
    this.loadingListener,
    this.errorListener,
    Key? key,
  })  : listener = null,
        super(key: key);

  const StateListener.single({
    required this.child,
    required this.listener,
    Key? key,
  })  : successListener = null,
        loadingListener = null,
        errorListener = null,
        super(key: key);

  @override
  _StateListenerState<US, V> createState() => _StateListenerState<US, V>();
}

class _StateListenerState<US extends washington.UnitedState<V>,
    V extends Object> extends State<StateListener<US, V>> {
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

  // @override
  // Widget build(BuildContext context) {
  //   if (_listener != null) {
  //     stateRef?.removeListener(_listener!);
  //   }

  //   final state = context.read<T>();
  //   stateRef = state;

  //   if (widget.listener != null) {
  //     _listener = () {
  //       (widget as StateListener<T, TValue>).listener!.call(
  //             context,
  //             washington.BasicState<TValue>(
  //               error: state.error,
  //               value: state.value,
  //               isLoading: state.isLoading,
  //             ),
  //           );
  //     };
  //   } else {
  //     assert(!state.hasError || state.hasError && widget.errorListener != null,
  //         'If you are planning on setting \'error\' you must provide an \'errorListener\'');
  //     assert(
  //         !state.isLoading || state.isLoading && widget.loadingListener != null,
  //         'If you are planning on setting \'isLoading\' you must provide an \'loadingListener\'');

  //     _listener = () {
  //       if (state.hasError) {
  //         widget.errorListener!.call(
  //           context,
  //           washington.ErrorState<TValue>(
  //             value: state.value,
  //             isLoading: state.isLoading,
  //             error: state.error!,
  //           ),
  //         );
  //       } else if (state.isLoading) {
  //         widget.loadingListener!.call(
  //           context,
  //           washington.LoadingState<TValue>(
  //             value: state.value,
  //           ),
  //         );
  //       } else {
  //         widget.successListener!.call(
  //           context,
  //           washington.SuccessState<TValue>(value: state.value),
  //         );
  //       }
  //     };
  //   }

  //   state.addListener(_listener!);
  //   return widget.child;
  // }

  @override
  void dispose() {
    _removeListener();
    super.dispose();
  }

  void _addListener() {
    _listener = () {
      if (widget.listener != null) {
        widget.listener!.call(
          context,
          washington.BasicState<V>(
            error: _unitedState.error,
            value: _unitedState.value,
            isLoading: _unitedState.isLoading,
          ),
        );
      } else {
        assert(
            !_unitedState.hasError ||
                _unitedState.hasError && widget.errorListener != null,
            'If you are planning on setting \'error\' you must provide an \'errorListener\'');
        assert(
            !_unitedState.isLoading ||
                _unitedState.isLoading && widget.loadingListener != null,
            'If you are planning on setting \'isLoading\' you must provide an \'loadingListener\'');

        if (_unitedState.hasError) {
          widget.errorListener!.call(
            context,
            washington.ErrorState<V>(
              value: _unitedState.value,
              isLoading: _unitedState.isLoading,
              error: _unitedState.error!,
            ),
          );
        } else if (_unitedState.isLoading) {
          widget.loadingListener!.call(
            context,
            washington.LoadingState<V>(
              value: _unitedState.value,
            ),
          );
        } else {
          widget.successListener!.call(
            context,
            washington.SuccessState<V>(value: _unitedState.value),
          );
        }
      }
    };
    _unitedState.addListener(_listener!);
  }

  void _removeListener() {
    _unitedState.removeListener(_listener!);
    _listener == null;
  }
}
