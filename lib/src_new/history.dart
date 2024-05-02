import 'package:logger/logger.dart';
import 'package:marj_logger/marj_logger.dart';
import 'package:marj_logger/src_new/log_data.dart';

class LogHistory implements History {
  LogHistory({List<LogData>? history}) {
    if (history != null) _history.addAll(history);
  }

  final _history = <LogData>[];

  @override
  void clean() {
    _history.clear();
  }

  @override
  List<LogData> get history => _history;

  @override
  void write(LogData data) {
    if (limit <= _history.length) _history.removeAt(0);

    _history.add(data);
  }

  void writeFromEvent(OutputEvent ev, String name) {
    final data = LogData(
      level: LogUtil.logLevelByLevel(ev.level),
      lines: ev.lines,
      name: name,
      time: DateTime.now(),
    );
    write(data);
  }

  int get limit => 100;
}

abstract class History {
  List<LogData> get history;

  void clean();

  void write(LogData data);
}
