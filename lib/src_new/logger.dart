import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:marj_logger/src_new/history.dart';
import 'package:marj_logger/src_new/log_screen.dart';

enum LogLevel { info, debug, error, json }

class LogConfig {
  LogConfig({
    this.enable = true,
    this.fullHistory = false,
    this.logMethod = defLogMethod,
    this.logOnConsole = true,
    this.writeHistoryFor = const [LogLevel.info, LogLevel.error, LogLevel.json],
  });

  final bool enable;
  final bool fullHistory;
  final Function(String msg) logMethod;
  final bool logOnConsole;
  final List<LogLevel> writeHistoryFor;

  LogConfig copyWith({
    bool? enable,
    bool? fullHistory,
    Function(String msg)? logMethod,
    bool? logOnConsole,
    List<LogLevel>? writeHistoryFor,
  }) {
    return LogConfig(
      enable: enable ?? this.enable,
      fullHistory: fullHistory ?? this.fullHistory,
      logMethod: logMethod ?? this.logMethod,
      logOnConsole: logOnConsole ?? this.logOnConsole,
      writeHistoryFor: writeHistoryFor ?? this.writeHistoryFor,
    );
  }

  static defLogMethod(v) => log(v, name: '\u276f_');
}

class MLogger {
  factory MLogger([Object? obj, String name = 'LOG']) {
    _log(obj.toString(), LogLevel.debug, name);
    return _instance;
  }

  MLogger._internal();

  MLogger.initiate({
    bool? enable,
    bool? fullHistory,
    Function(String msg)? logMethod,
    bool? logOnConsole,
    List<LogLevel>? writeHistoryFor,
  }) {
    _config = _config.copyWith(
      enable: enable,
      fullHistory: fullHistory,
      logMethod: logMethod,
      logOnConsole: logOnConsole,
      writeHistoryFor: writeHistoryFor,
    );
  }

  static LogConfig _config = LogConfig();
  static final _history = LogHistory();
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
    if (!_config.enable) return;

    final logger = _buildLogger(name, l);
    logger.log(LogUtil.levelByLogLevel(l), log);
  }

  static Logger _buildLogger(
    String name,
    LogLevel l,
  ) {
    final write = _config.writeHistoryFor.contains(l) || _config.fullHistory;
    return Logger(
      filter: null,
      output: DefaultOutput(
        name: name,
        config: _config,
        onOutput: (ev) {
          if (write) _history.writeFromEvent(ev, name);
        },
      ),
      printer: defaultPrinter(),
    );
  }
}

class DefaultOutput extends LogOutput {
  DefaultOutput({
    required this.name,
    required this.onOutput,
    required this.config,
  });

  static const bottomLeftCorner = '└';
  static const doubleDivider = '─';
  static const singleDivider = '┄';
  static const topLeftCorner = '┌';
  static const vertical = '│';

  final LogConfig config;
  final String name;
  final Function(OutputEvent event) onOutput;

  @override
  void output(OutputEvent event) {
    if (config.logOnConsole) {
      String getLine(String? corner, String divider) =>
          LogUtil.getLine(120, event.level, corner, divider);

      final top = getLine(topLeftCorner, doubleDivider);
      final mid = getLine(bottomLeftCorner, singleDivider);
      final bottom = getLine(bottomLeftCorner, doubleDivider);

      final title = '$vertical [$name] :: ${event.level.name}';
      final eLines = event.lines.map((e) => '  $e');

      final lines = [top, title, mid, ...eLines, bottom];

      config.logMethod(lines.join('\n'));
    }
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
