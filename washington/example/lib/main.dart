import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:washington/washington.dart';

// User Events
// These are the actions we expect to recieve from the UI.
class CounterIncrementPressed {}

class CounterDecrementPressed {}

class CounterResetPressed {}

class CounterRandomPressed {}

// CounterState Event
// These will be dispatched by our state object to notify other States or
// EventListeners.
class CounterResetted {}

class LimitReached {}

// Extend UnitedState to create a CounterState
class CounterState extends UnitedState<int> {
  // You can use fields but they should always be final.
  // If it's part of the (changing) state, it should be part of the `value`.
  final int lowerLimit;
  final int upperLimit;

  bool get canIncrement => !isLoading && value < upperLimit;
  bool get canDecrement => !isLoading && value > lowerLimit;
  bool get canReset => !isLoading && value != 0;
  bool get canRandom => !isLoading;

  CounterState({
    required this.upperLimit,
    required this.lowerLimit,
  }) : super(0) {
    // Add handlers to handle incomming events.
    // Pro tip: use tear-offs to get a nice clean list of handlers.
    addHandler<CounterIncrementPressed>(_increment);
    addHandler<CounterDecrementPressed>(_decrement);
    addHandler<CounterResetPressed>(_reset);
    addHandler<CounterRandomPressed>(_random);
  }

  void _increment(CounterIncrementPressed event) {
    // Here we do some logic checks and set the new State when needed.
    if (value < upperLimit) {
      setState(value + 1);
    }
    // When the value reached the upperLimit, we dispatch the LimitReached event.
    if (value == upperLimit) {
      dispatch(LimitReached());
    }
  }

  void _decrement(CounterDecrementPressed event) {
    if (value > lowerLimit) {
      setState(value - 1);
    }
    if (value == lowerLimit) {
      dispatch(LimitReached());
    }
  }

  void _reset(CounterResetPressed event) {
    setState(0);
    dispatch(CounterResetted());
  }

  void _random(CounterRandomPressed event) {
    setState(value, isLoading: true);
    Future.delayed(const Duration(seconds: 1), () {
      final newValue = Random().nextInt(upperLimit);
      setState(newValue);
    });
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StateProvider(
      state: CounterState(lowerLimit: 0, upperLimit: 5),
      child: MaterialApp(
        title: 'Washington Demo',
        theme: ThemeData(primarySwatch: Colors.purple),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          Expanded(
            child: EventListener(
              listener: (context, event) {
                if (event is CounterResetted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Counter has been reset!')));
                }
                if (event is LimitReached) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('A limit has been reached!')));
                }
              },
              child: StateListener<CounterState>(
                listener: (context, state) {
                  if (state.value >= 10) {
                    Washington.instance.dispatch(CounterResetPressed());
                  }
                },
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'You have pushed the button this many times:',
                      ),
                      StateBuilder<CounterState>(
                        builder: (context, state, _) {
                          return Text(
                            '${state.isLoading ? 'loading...' : state.value}',
                            style: Theme.of(context).textTheme.headline4,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Expanded(child: Controls()),
        ],
      ),
    );
  }
}

class Controls extends StatelessWidget {
  const Controls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counterState = context.watch<CounterState>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: counterState.canIncrement
                  ? () =>
                      Washington.instance.dispatch(CounterIncrementPressed())
                  : null,
              icon: const Icon(Icons.add),
              label: const Text('Increment'),
            ),
            ElevatedButton.icon(
              onPressed: counterState.canDecrement
                  ? () =>
                      Washington.instance.dispatch(CounterDecrementPressed())
                  : null,
              icon: const Icon(Icons.remove),
              label: const Text('Decrement'),
            ),
            ElevatedButton.icon(
              onPressed: counterState.canReset
                  ? () => Washington.instance.dispatch(CounterResetPressed())
                  : null,
              icon: const Icon(Icons.restore),
              label: const Text('Reset'),
            ),
            ElevatedButton.icon(
              onPressed: counterState.canRandom
                  ? () => Washington.instance.dispatch(CounterRandomPressed())
                  : null,
              icon: const Icon(Icons.refresh),
              label: const Text('Random'),
            ),
          ],
        ),
      ),
    );
  }
}
