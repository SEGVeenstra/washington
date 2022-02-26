import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:washington/washington.dart';

// User Events
class CounterIncrementPressed {}

class CounterDecrementPressed {}

class CounterResetPressed {}

// CounterState Event
class CounterResetted {}

class LimitReached {}

class CounterState extends UnitedState<int> {
  final int lowerLimit;
  final int upperLimit;

  CounterState({
    required this.upperLimit,
    required this.lowerLimit,
  }) : super(0) {
    addHandler<CounterIncrementPressed>((_) {
      if (value < upperLimit) {
        updateState(value + 1);
      }
      if (value == upperLimit) {
        Washington.instance.dispatch(LimitReached());
      }
    });

    addHandler<CounterDecrementPressed>((_) {
      if (value > lowerLimit) {
        updateState(value - 1);
      }
      if (value == lowerLimit) {
        Washington.instance.dispatch(LimitReached());
      }
    });

    addHandler<CounterResetPressed>((_) {
      updateState(0);
      Washington.instance.dispatch(CounterResetted());
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
    final counterState = context.watch<CounterState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: EventListener(
        listener: (context, event) {
          if (event is CounterResetted) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Counter has been reset!')));
          }
          if (event is LimitReached) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('A limit has been reached!')));
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
                      '${state.value}',
                      style: Theme.of(context).textTheme.headline4,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (counterState.value < counterState.upperLimit)
            FloatingActionButton(
              onPressed: () =>
                  Washington.instance.dispatch(CounterIncrementPressed()),
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          const SizedBox(height: 4),
          if (counterState.value > counterState.lowerLimit)
            FloatingActionButton(
              onPressed: () =>
                  Washington.instance.dispatch(CounterDecrementPressed()),
              tooltip: 'Decrement',
              child: const Icon(Icons.remove),
            ),
          const SizedBox(height: 4),
          FloatingActionButton(
            onPressed: () =>
                Washington.instance.dispatch(CounterResetPressed()),
            tooltip: 'Reset',
            child: const Icon(Icons.restore),
          ),
        ],
      ),
    );
  }
}
