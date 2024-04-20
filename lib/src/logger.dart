import 'package:flutter/material.dart';
import 'package:marj_logger/src/simple_log_formatter.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'talker_config.dart';

typedef LogOutput = void Function(dynamic msg);

class Logger {
  Logger([Object? obj, String name = 'LOG']) {
    _config.simpleLog(obj, name);
  }

  static void critical(
    dynamic msg, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _config.critical(msg, error, stackTrace);
  }

  static void error(
    dynamic msg, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _config.error(msg, error, stackTrace);
  }

  static void ex(
    Object exception, [
    StackTrace? stackTrace,
    dynamic msg,
  ]) {
    _config.ex(exception, stackTrace, msg);
  }

  static void info(
    dynamic msg, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _config.info(msg, error, stackTrace);
  }

  static void json(response, [String name = 'JSON']) {
    _config.json(response, name);
  }

  static void warning(
    dynamic msg, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _config.warning(msg, error, stackTrace);
  }

  static void openHistory(BuildContext context) {
    _config.openLogHistory(context);
  }

  static TalkerConfig _config = TalkerConfig();

  static void configure({
    bool enable = true,
    bool logOnConsole = true,
    void Function(dynamic)? output,
    LoggerFormatter formatter = const SimpleLogFormatter(),
    String logPrefix = '\u276f_',
    TalkerDioLoggerSettings? dioLoggerSettings,
    bool fullHistory = false,
  }) {
    _config = TalkerConfig(
      enable: enable,
      logOnConsole: logOnConsole,
      output: output,
      formatter: formatter,
      dioLoggerSettings: dioLoggerSettings,
      fullHistory: fullHistory,
      logPrefix: logPrefix,
    );
  }
}
