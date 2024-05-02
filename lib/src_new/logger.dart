import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:marj_logger/src_new/history.dart';
import 'package:marj_logger/src_new/log_screen.dart';

enum LogLevel { info, debug, error, json }

class LogConfig {
  final bool enable = true;
  final bool fullHistory = false;
  final Function(String msg) logMethod = defLogMethod;
  final bool logOnConsole = true;
  final List<LogLevel> writeHistoryFor = [
    LogLevel.info,
    LogLevel.error,
    LogLevel.json
  ];

  static defLogMethod(v) => log(v, name: '\u276f_');
}

class MLogger {
  factory MLogger([Object? obj, String name = 'LOG']) {
    _log(obj.toString(), LogLevel.debug, name);
    return _instance;
  }

  MLogger._internal();

  static final _history = LogHistory();
  static final LogConfig _config = LogConfig();
  static final MLogger _instance = MLogger._internal();

  static info(String info, [String name = 'INFO']) {
    _log(info, LogLevel.info, name);
  }

  static error(String info, [String name = 'ERROR']) {
    _log(info, LogLevel.error, name);
  }

  static json(response, [String name = 'JSON']) {
    final json = LogUtil.prettyJSON(response);
    _log(json, LogLevel.json, name);
  }

  static openLogHistory(BuildContext context) {
    final logScreen = LogScreen(logHistory: _history.history);

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => logScreen),
    );
  }

  static Function() defaultPrinter = () => PrettyPrinter(
        methodCount: 0,
        printEmojis: false,
        noBoxingByDefault: true,
      );

  static _log(String log, LogLevel l, [String name = 'LOG']) {
    final logger = _buildLogger(name, l);

    logger.log(LogUtil.levelByLogLevel(l), log);
  }

  static Logger _buildLogger(
    String name,
    LogLevel l,
  ) {
    final write = _config.writeHistoryFor.contains(l);
    return Logger(
      filter: null,
      output: Output(
        name: name,
        logMethod: _config.logMethod,
        onOutput: (ev) {
          if (write) _history.writeFromEvent(ev, name);
        },
      ),
      printer: defaultPrinter(),
    );
  }
}

class Output extends LogOutput {
  Output({
    required this.name,
    required this.onOutput,
    required this.logMethod,
  });

  static const bottomLeftCorner = '└';
  static const doubleDivider = '─';
  static const singleDivider = '┄';
  static const topLeftCorner = '┌';
  static const vertical = '│';

  final Function(String log) logMethod;
  final String name;
  final Function(OutputEvent event) onOutput;

  @override
  void output(OutputEvent event) {
    String getLine(String? corner, String divider) =>
        LogUtil.getLine(120, event.level, corner, divider);

    final top = getLine(topLeftCorner, doubleDivider);
    final mid = getLine(bottomLeftCorner, singleDivider);
    final bottom = getLine(bottomLeftCorner, doubleDivider);

    final title = '$vertical [$name] :: ${event.level.name}';
    final eLines = event.lines.map((e) => '  $e');

    final lines = [top, title, mid, ...eLines, bottom];

    logMethod(lines.join('\n'));
    onOutput(event);
  }
}

class LogUtil {
  static final Map<Level, AnsiColor> levelColors = {
    Level.trace: AnsiColor.fg(AnsiColor.grey(0.5)),
    Level.debug: const AnsiColor.none(),
    Level.info: const AnsiColor.fg(12),
    Level.warning: const AnsiColor.fg(208),
    Level.error: const AnsiColor.fg(196),
    Level.fatal: const AnsiColor.fg(199),
  };
  static Level levelByLogLevel(LogLevel l) {
    return switch (l) {
      LogLevel.info => Level.info,
      LogLevel.debug => Level.debug,
      LogLevel.error => Level.error,
      LogLevel.json => Level.fatal,
    };
  }

  static LogLevel logLevelByLevel(Level l) {
    return switch (l) {
      Level.info => LogLevel.info,
      Level.debug => LogLevel.debug,
      Level.error => LogLevel.error,
      Level.fatal => LogLevel.json,
      _ => LogLevel.debug,
    };
  }

  static String getLine(int length, Level l, String? corner, String divider) {
    if (corner != null) {
      return '${levelColors[l]}$corner${divider * (length - 1)}';
    }

    return '${levelColors[l]}${divider * length}';
  }

  static String prettyJSON(response, [Function(Object e)? onError]) {
    try {
      var encoder = const JsonEncoder.withIndent("  ");
      return encoder.convert(response);
    } catch (e) {
      onError?.call(e);
      return response;
    }
  }
}
