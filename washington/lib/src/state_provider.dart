import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:washington/washington.dart';

class StateProvider<T extends UnitedState<Object>> extends StatelessWidget {
  final T state;
  final Widget child;

  const StateProvider({
    required this.child,
    required this.state,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => state,
      child: child,
    );
  }

  static T of<T>(BuildContext context) {
    final state = Provider.of<T>(context);

    assert(state == null, 'No StateProvider found for $T');

    return state!;
  }
}
