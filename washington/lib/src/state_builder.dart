import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:washington/washington.dart';

typedef SuccessBuilder<TValue> = Widget Function(
  BuildContext context,
  _SuccessState<TValue> state,
);

typedef LoadingBuilder<TValue> = Widget Function(
  BuildContext context,
  _LoadingState<TValue> state,
);

typedef ErrorBuilder<TValue> = Widget Function(
  BuildContext context,
  _ErrorState<TValue> state,
);

typedef GeneralStateBuilder<TValue> = Widget Function(
  BuildContext context,
  _State<TValue> state,
);

/// A Widget that allows you to define specific builders for specific states.
///
/// This Widget will check the state for you and call the specific builder.
/// The order in which the builders are called are as follows:
///
/// if hasError -> errorBuilder
/// else if isLoading -> loadingBuilder
/// else -> successBuilder
///
/// Only the successBuilder is required. If your State does not use the isLoading
/// or error properties, you can ommit the optional builders.
///
/// If you do pass an error, but have not declared an errorBuilder, this widget
/// will throw an assertion error.
class StateBuilder<T extends UnitedState, TValue> extends StatelessWidget {
  final SuccessBuilder<TValue>? _successBuilder;
  final ErrorBuilder<TValue>? _errorBuilder;
  final LoadingBuilder<TValue>? _loadingBuilder;
  final GeneralStateBuilder<TValue>? _generalBuilder;

  const StateBuilder({
    required SuccessBuilder<TValue> successBuilder,
    ErrorBuilder<TValue>? errorBuilder,
    LoadingBuilder<TValue>? loadingBuilder,
    Key? key,
  })  : _generalBuilder = null,
        _errorBuilder = errorBuilder,
        _loadingBuilder = loadingBuilder,
        _successBuilder = successBuilder,
        super(key: key);

  const StateBuilder.single({
    required GeneralStateBuilder<TValue> builder,
    Key? key,
  })  : _generalBuilder = builder,
        _errorBuilder = null,
        _loadingBuilder = null,
        _successBuilder = null,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<T>();

    if (_generalBuilder != null) {
      return _generalBuilder!.call(
          context,
          _State(
            error: state.error,
            value: state.value as TValue,
            isLoading: state.isLoading,
          ));
    } else {
      assert(!state.hasError || state.hasError && _errorBuilder != null,
          'If you are planning on setting \'error\' you must provide an \'errorBuilder\'');
      assert(!state.isLoading || state.isLoading && _loadingBuilder != null,
          'If you are planning on setting \'isLoading\' you must provide an \'loadingBuilder\'');
      if (state.hasError) {
        return _errorBuilder!.call(
          context,
          _ErrorState(error: state.error!, value: state.value as TValue, isLoading: state.isLoading),
        );
      } else if (state.isLoading) {
        return _loadingBuilder!.call(context, _LoadingState(value: state.value as TValue));
      }
      return _successBuilder!(context, _SuccessState(value: state.value as TValue));
    }
  }
}

class _SuccessState<TValue> {
  final TValue value;

  const _SuccessState({required this.value});
}

class _LoadingState<TValue> {
  final TValue value;

  const _LoadingState({required this.value});
}

class _ErrorState<TValue> {
  final TValue value;
  final Object error;
  final bool isLoading;

  const _ErrorState({
    required this.error,
    required this.value,
    required this.isLoading,
  });
}

class _State<TValue> {
  final TValue value;
  final Object? error;
  final bool isLoading;

  bool get hasError => error != null;

  const _State({
    required this.error,
    required this.value,
    required this.isLoading,
  });
}
