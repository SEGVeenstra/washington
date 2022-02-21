import 'package:flutter/material.dart';
import 'package:washington/washington.dart';

class CounterIncrement {}

class CounterDecrement {}

class CounterReset {}

class CounterState extends UnitedState<int> {
  CounterState() : super(0) {
    addHandler<CounterIncrement>((_) => updateState(value + 1));
    addHandler<CounterDecrement>((_) => updateState(value - 1));
    addHandler<CounterReset>((_) => updateState(0));
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
      state: CounterState(),
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
      body: Center(
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () => Washington.instance.dispatch(CounterIncrement()),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 4),
          FloatingActionButton(
            onPressed: () => Washington.instance.dispatch(CounterDecrement()),
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(height: 4),
          FloatingActionButton(
            onPressed: () => Washington.instance.dispatch(CounterReset()),
            tooltip: 'Reset',
            child: const Icon(Icons.restore),
          ),
        ],
      ),
    );
  }
}
