import 'package:flutter_test/flutter_test.dart';
import 'package:washington/src/washington.dart';

void main() {
  test('Test CounterState', () {
    final counterState = CounterState();

    counterState.addListener(() {
      // no-op
    });

    Washington.instance.dispatch(Increment());
    Washington.instance.dispatch(Increment());
    Washington.instance.dispatch(Increment());
  });
}

class Increment {}

class CounterState extends UnitedState<int> {
  CounterState() : super(0) {
    addHandler<Increment>((event) => setState(value + 1));
  }
}
