import 'package:flutter/widgets.dart';
import 'package:washington/washington.dart';

class EventListener extends StatefulWidget {
  final void Function(BuildContext context, Object event) listener;
  final Widget child;

  const EventListener({
    required this.listener,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  _EventListenerState createState() => _EventListenerState();
}

class _EventListenerState extends State<EventListener> {
  void _callback(Object event) {
    widget.listener(context, event);
  }

  @override
  void initState() {
    Washington.instance.addListener(_callback);
    super.initState();
  }

  @override
  void dispose() {
    Washington.instance.removeListener(_callback);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
