The No-Nonsense Event Driven State Management solution for Flutter.

> __WARNING__: This package is __not__ ready for __production__ projects.
> 
>Feel free to try it prototypes or experiments.

```none
DECLARATION OF INDEPENDENCE

This package was born from a personal desire for a light-weight state
management solution.

Creating my own state managment solution allowed me to adapt to my personal
needs and preferences that I've developed over my years working with Flutter.

When one would try this state management solution, one will find traces of
other well-know solutions that have inspired me.
```

# Washington

`Washington` (`class`) is the capitol of your state management. You will use `Washington` to `dispath` events for your application.

`Washington` is implimented as a _singleton_ allowing you to easily access it from anywhere in your application.

When you want to grab hold of the `Washington` _instance_ you can use the static `instance` property.

```dart
Washington.instance.dispatch(SomeEvent());
```

## UnitedStates

You will use `UnitedState` objects to manage your application's `state`.

To create these objects, all you have to do is _extend_ the `UnitedState` class and add handlers for all the events you want your `UnitedState` to act upon.

Each `UnitedState` should be responsible for a specific _area_ or _feature_ of your app. For example, you could have a `UserState`, `ProductsState` and `SettingsState`.

```dart
class UserState extends UnitedState<User?> {
    UserState() : super(null) {
        addHandler<Login>((event) => ... );
        addHandler<Logout>((event) => ... );
        ...
    }
}
```

> __ProTip__: To keep the constructor nice and clean it is recommended to create private methods in the class and add them as a handler.

### SetState

To update the state you use the `setState` function. You can set a new `value`, and you can also set the `isLoading` and `error` properties.

```dart
setState(
    User(), // the new value
    isLoading: false,
    error: null,
);
```

## Events

Events are the things that will trigger change in your application.

An event can be any object you want. You use `Washington` to dispatch these events. `Washington` will make sure that the events reach all the `UnitedState`s so they can react to it.

Because you can dispatch anything as an event, you are able to dispatch events that can be handled by multiple states at the same time allowing you to update different parts of your app with the same event.

You can dispatch a `UserLogout` event and the `UserState` can act upon this. But the `SettingsState` could also use this event to clear all the user's preferences.

```dart
class UserLogout {};

class AuthState extends UnitedState<User?> {
    AuthState() : super(null) {
        addHandler<LogoutEvent>(_clearUser);
        ...
    }

    ...
}

class SettingsState extends UnitedState<Settings?> {
    SettingsState() : super(null) {
        addHandler<LogoutEvent>(_clearSettings);
        ...
    }

    ...
}
```

> __ProTip__: You can also make a `UnitedState` emit events to create a chain reaction.
>
> This way you could clean up after a user logs out, or navigate to the _LoginPage_.

# Widgets

When using `Washington` in your Flutter application you can use a set of convenient widgets that help you build or trigger UI elements based on events and state changes.

## StateProvider

States can be scoped in the _widget tree_ by using `StateProvider`s.

```dart
StateProvider<AuthState>(
    create: (context) => AuthState(),
    child: ...
)
```

When you need to add multiple `StateProvider`s add the same level, consider using a `MultiStateProvider`. This makes your code more readable.

```dart
MultiStateProvider(
    stateProviders: [
        StateProvider<AuthState> (create: (context) => AuthState()),
        StateProvider<SettingsState> (create: (context) => SettingsState()),
    ]
)
```

## StateBuilder

To build the UI based on the state you can use `StateBuilder`s.

There are two constructors you can use, both with their own use-case.

### Default constructor
When you want to build a widget that has support for different states you might want to use the default constructor.
The `builder` will be called on every state change.

```dart
StateBuilder<AuthState,User?>(
    builder: (context, state) => ProfilePage(
        isLoading: state.isLoading,
        user: state.value,
        error: state.error,
    ),
)
```

### StateBuilder.separate
The `separate` constructor is ideal for when you want to show totally different widgets based on the state.

It gives you three seperate builder functions for _success_, _loading_ and _error_ states.

Only the `successBuilder` is required, the other two are optional. However, when `isLoading` is set to `true` or `error` is not `null`, and the corresponding builder has not been provided, an assertion error will be thrown. 

```dart
StateBuilder<AuthState,User?>.separate(
    successBuilder: (context, user) => Profile(user),
    loadingBuilder: (context) => Loading(),
    errorBuilder: (context, error) => Error(error),
)
```

## StateListener

When you need to trigger one-off actions (like navigating or showing a snackbar) 
based on state changes, you can use the `StateListener`. 

`StateListener` differs a little from `StateBuilder`.

It has a default constructor and _three_ named constructors.

### Default constructor

The default constructor requires a `builder` function that will be called on every state change. The state that's passed to this builder will contain the `value`, `isLoading` and `error` fields.

```dart
StateListener<AuthState,User?>(
    listener: (context, state) => ...,
)
```

### Named constructors

The named constructors are only called in specific cases.

```dart
StateListener<AuthState,User?>.error(
    // Will only be called when the state has an error
    errorListener: (context, state) => ...,
)

StateListener<AuthState,User?>.loading(
    // Will only be called when there is no error,
    // and loading is set to true.
    loadingListener: (context, state) => ...,
)

StateListener<AuthState,User?>.success(
    // Will only be called when there is no error,
    // and loading is set to false.
    successListener: (context, state) => ...,
)
```

## EventListener

If you want to trigger one-off actions based on the events being dispatched, instead of a state change, you can use the `EventListener`.

```dart
EventListener(
    listener: (context, event) => ...,
)
```