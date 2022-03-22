import 'package:flutter/widgets.dart';
import 'package:washington/washington.dart' as washington;

/// The EventListener is a convinient widget that allows you to listen
/// to events that [Washington] dispatches.
class EventListener extends StatefulWidget {
  /// A callback that is called whenever [Washington] dispatches a new event.
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
    washington.Washington.instance.addListener(_callback);
    super.initState();
  }

  @override
  void dispose() {
    washington.Washington.instance.removeListener(_callback);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
