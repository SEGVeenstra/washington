<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

The Non-Nonsense Event Driven State Management solution for Flutter.

## Washington

`Washington` is the capitol of your state management. You will use `Washington` to `dispath` events for your application.

```dart
Washington.instance.dispatch(SomeEvent());
```

### UnitedStates

You use `UnitedState` objects to manager your application's `state`.

To create these objects, all you have to do is extend the `UnitedState` class and add handlers for all the events you want your `UnitedState` to act upon.

Each `UnitedState` should be responsible for a specific _area_ of your app. For example, you could have a `UserState`, `ProductsState` and `SettingsState`.

sample:

```dart
class UserState extends UnitedState<User?> {
    UserState() : super(null) {
        addHandler<Login>((event) => ... );
        addHandler<Logout>((event) => ... );
        ...
    }
}
```

### Events

An event can be any object you want. You use `Washington` to dispatch these events. `Washington` will make sure that the events reach all the `UnitedState`s so they can do their thing.

Because you can dispatch anything as an event, you are able to dispatch events that can be handled by multiple states at the same time.

You can dispatch a `UserLogout` event and the `UserState` can act upon this. But the `SettingsState` could also use this event to clear all the user's preferences.

## Widgets

To use `Washington` in your Flutter application you can use a set of conviniet widgets that help you build or trigger UI elements based on events and state changes.

### StateProvider

States can be scoped in the _widget tree_ by using `StateProviders`.

...

### StateBuilder

To build the UI based on the current state you can use `StateBuilder`.

...

### Statelistener

When you need to trigger one-off actions (like navigating or showing a snackbar) based on state changes, you can use the 'StateListener'. 

...

### EventListen

If you want to trigger one-off actions but based on the events being dispatched, instead of a state change, you can use the EventListener.

...