import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:marj_logger/src_new/log_screen.dart';

class MLogger {
  // final _history = LogHistory();

  final List<OutputEvent> history = [];

  info(String info, [String name = 'LOG']) {
    _log(info, Level.info, name);
  }

  error(String info, [String name = 'LOG']) {
    _log(info, Level.info, name);
  }

  json(String info, [String name = 'JSON']) {
    _log(info, Level.info, name);
  }

  openLogHistory(BuildContext context) {
    log(history.length.toString());
    final logScreen = LogScreen(logHistory: history);

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => logScreen),
    );
  }

  static Function() defaultPrinter = () => PrettyPrinter(
        methodCount: 0,
        printEmojis: false,
        noBoxingByDefault: true,
      );

  _log(String log, Level l, [String name = 'LOG']) {
    final logger = Logger(
      filter: null,
      output: Output(name, onOutput: history.add),
      printer: defaultPrinter(),
    );
    logger.log(l, log);
  }
}

class Output extends LogOutput {
  Output(this.name, {required this.onOutput});

  static const bottomLeftCorner = '└';
  static const doubleDivider = '─';
  static const singleDivider = '┄';
  static const topLeftCorner = '┌';
  static const vertical = '│';

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

    log(lines.join('\n'));
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

  static String getLine(int length, Level l, String? corner, String divider) {
    if (corner != null) {
      return '${levelColors[l]}$corner${divider * (length - 1)}';
    }

    return '${levelColors[l]}${divider * length}';
  }
}
