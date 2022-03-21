import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:washington/washington.dart';

/// A [StateProvider] can be used to add a State object to the _widget tree_.
///
/// It's nothing more then a convinient subclass of [ChangeNotifierProvider] that
/// makes it easier to remember to use the right [Provider].
///
/// Trying to provide a [UnitedState] with a normal [Provider] would show an assert error.
class StateProvider<T extends UnitedState<Object>>
    extends ChangeNotifierProvider<T> {
  StateProvider({
    required Widget? child,
    required T Function(BuildContext context) create,
    Key? key,
  }) : super(child: child, create: create, key: key);
}
