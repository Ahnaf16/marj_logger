import 'package:marj_logger/src_new/logger.dart';

class LogData {
  LogData({
    required this.name,
    required this.level,
    required this.lines,
    required this.time,
  });

  final LogLevel level;
  final List<String> lines;
  final String name;
  final DateTime time;
}
