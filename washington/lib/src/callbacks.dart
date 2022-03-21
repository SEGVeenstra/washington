import 'package:flutter/widgets.dart' hide State;

import '../washington.dart';

typedef SuccessBuilder<TValue> = Widget Function(
  BuildContext context,
  SuccessState<TValue> state,
);

typedef ErrorBuilder<TValue> = Widget Function(
  BuildContext context,
  ErrorState<TValue> state,
);

typedef GeneralStateBuilder<TValue> = Widget Function(
  BuildContext context,
  State<TValue> state,
);

typedef StateCallback<T extends UnitedState> = void Function(
    BuildContext context, T state);
