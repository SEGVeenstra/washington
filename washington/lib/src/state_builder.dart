import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:washington/washington.dart';

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
class StateValueBuilder<T extends UnitedState, TValue> extends StatelessWidget {
  final Widget Function(BuildContext context, _SuccessState<TValue> state)
      successBuilder;
  final Widget Function(BuildContext context, _ErrorState<TValue> state)?
      errorBuilder;
  final Widget Function(BuildContext context, _SuccessState<TValue> state)?
      loadingBuilder;

  const StateValueBuilder({
    required this.successBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<T>();
    assert(!state.hasError || state.hasError && errorBuilder != null,
        'If you are planning on setting \'error\' you must provide an \'errorBuilder\'');
    assert(!state.isLoading || state.isLoading && loadingBuilder != null,
        'If you are planning on setting \'isLoading\' you must provide an \'loadingBuilder\'');
    if (state.hasError) {
      return errorBuilder!.call(
        context,
        _ErrorState(
            error: state.error!,
            value: state.value as TValue,
            isLoading: state.isLoading),
      );
    } else if (state.isLoading) {
      return loadingBuilder!
          .call(context, _SuccessState(value: state.value as TValue));
    }
    return successBuilder(context, _SuccessState(value: state.value as TValue));
  }
}

class _SuccessState<TValue> {
  final TValue value;

  const _SuccessState({required this.value});
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

class StateBuilder<T extends UnitedState> extends StatelessWidget {
  final Widget Function(BuildContext context, T state) builder;

  const StateBuilder({
    required this.builder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<T>();
    return builder(context, state);
  }
}
