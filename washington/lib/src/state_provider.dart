import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:washington/washington.dart';

class StateProvider<T extends UnitedState<Object>> extends StatefulWidget {
  final T state;
  final Widget child;

  const StateProvider({
    required this.child,
    required this.state,
    Key? key,
  }) : super(key: key);

  @override
  State createState() => _StateProviderState<T>();

  static T of<T>(BuildContext context) {
    final state = Provider.of<T>(context);

    assert(state == null, 'No StateProvider found for $T');

    return state!;
  }
}

class _StateProviderState<T extends UnitedState<Object>>
    extends State<StateProvider<T>> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => widget.state,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    widget.state.dispose();
    super.dispose();
  }
}
