import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:washington/washington.dart';

class StateBuilder<T extends UnitedState> extends StatelessWidget {
  const StateBuilder({
    required this.builder,
    this.child,
    Key? key,
  }) : super(key: key);

  final Widget? child;

  final Widget Function(BuildContext context, T state, Widget? child) builder;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<T>();
    return builder(context, state, child);
  }
}
