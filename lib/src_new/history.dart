import 'package:logger/logger.dart';

class LogHistory implements History {
  LogHistory({List<OutputEvent>? history}) {
    if (history != null) _history.addAll(history);
  }

  final _history = <OutputEvent>[];

  @override
  void clean() {
    _history.clear();
  }

  @override
  List<OutputEvent> get history => _history;

  @override
  void write(OutputEvent data) {
    if (limit <= _history.length) _history.removeAt(0);

    _history.add(data);
  }

  int get limit => 100;
}

abstract class History {
  List<OutputEvent> get history;

  void clean();

  void write(OutputEvent data);
}
