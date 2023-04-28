import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:washington/washington.dart';

/// A [StateProvider] can be used to add a State object to the _widget tree_.
///
/// It's nothing more then a convinient subclass of [ChangeNotifierProvider] that
/// makes it easier to remember to use the right [Provider].
///
/// When used in a [MultiStateProvider], be sure to set [T] to the exact class
/// that you are providing so it can be found properly.
///
/// Trying to provide a [UnitedState] with a normal [Provider] would show an assert error.
class StateProvider<T extends UnitedState<Object>> extends ChangeNotifierProvider<T> {
  StateProvider({
    Widget? child,
    required T Function(BuildContext context) create,
    Key? key,
  }) : super(child: child, create: create, key: key);
}

/// A [MultiStateProvider] can be used when you want to provide multiple
/// [UnitedState] objects.
///
/// Instead of having to nest StateProviders yourself, the [MultiStateProvider]
/// will do it for you. This makes your code more readable.
class MultiStateProvider extends MultiProvider {
  MultiStateProvider({Key? key, required Widget child, required List<StateProvider<UnitedState>> stateProviders})
      : super(
          key: key,
          providers: stateProviders,
          child: child,
        );
}
