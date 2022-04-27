import 'package:flutter/widgets.dart' hide State;
import 'package:provider/provider.dart' hide ErrorBuilder;
import 'package:washington/washington.dart';

import 'states.dart';

typedef ValueStateBuilder<TValue> = Widget Function(
  BuildContext context,
  ValueState<TValue> state,
);

typedef GeneralStateBuilder<TValue> = Widget Function(
  BuildContext context,
  State<TValue> state,
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
class StateBuilder<T extends UnitedState<TValue>, TValue extends Object>
    extends StatelessWidget {
  final ValueStateBuilder<TValue>? _successBuilder;
  final GeneralStateBuilder<TValue>? _errorBuilder;
  final ValueStateBuilder<TValue>? _loadingBuilder;
  final GeneralStateBuilder<TValue>? _generalBuilder;

  const StateBuilder.separate({
    required ValueStateBuilder<TValue> successBuilder,
    GeneralStateBuilder<TValue>? errorBuilder,
    ValueStateBuilder<TValue>? loadingBuilder,
    Key? key,
  })  : _generalBuilder = null,
        _errorBuilder = errorBuilder,
        _loadingBuilder = loadingBuilder,
        _successBuilder = successBuilder,
        super(key: key);

  const StateBuilder({
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
      return _generalBuilder!.call(context, state);
    } else {
      assert(!state.hasError || state.hasError && _errorBuilder != null,
          'If you are planning on setting \'error\' you must provide an \'errorBuilder\'');
      assert(!state.isLoading || state.isLoading && _loadingBuilder != null,
          'If you are planning on setting \'isLoading\' you must provide an \'loadingBuilder\'');
      if (state.hasError) {
        return _errorBuilder!.call(
          context,
          state,
        );
      } else if (state.isLoading) {
        return _loadingBuilder!.call(context, state);
      }
      return _successBuilder!(context, state);
    }
  }
}
