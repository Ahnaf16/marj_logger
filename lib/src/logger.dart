import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

typedef LogOutput = void Function(dynamic msg);

class TalkerConfig {
  TalkerConfig({
    bool enable = true,
    bool logOnConsole = true,
    LogOutput? output,
    LoggerFormatter formatter = const _SimpleLogFormatter(),
    this.logPrefix = '\u276f_',
    TalkerDioLoggerSettings? dioLoggerSettings,
    this.fullHistory = false,
  }) {
    _init(
      enable,
      logOnConsole,
      output,
      formatter,
      dioLoggerSettings,
    );
  }

  final bool fullHistory;
  final String logPrefix;

  late final TalkerDioLoggerSettings _dioLoggerSettings;
  late final Talker _talker;

  TalkerDioLogger get dioLogger {
    return TalkerDioLogger(
      talker: _talker,
      settings: _dioLoggerSettings,
    );
  }

  openLogHistory(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TalkerScreen(
          talker: _talker,
          theme: const TalkerScreenTheme(
            backgroundColor: Colors.black,
            cardColor: Colors.black45,
          ),
        ),
      ),
    );
  }

  void _init(
    bool enable,
    bool logOnConsole,
    LogOutput? output,
    LoggerFormatter formatter,
    TalkerDioLoggerSettings? dioLoggerSettings,
  ) {
    _talker = Talker(
      logger: TalkerLogger(
        output: output ?? (v) => log(v, name: logPrefix),
        formatter: formatter,
      ),
      settings: TalkerSettings(
        useConsoleLogs: logOnConsole,
        enabled: enable,
      ),
    );

    _dioLoggerSettings = dioLoggerSettings ??
        TalkerDioLoggerSettings(
          printRequestData: false,
          responseFilter: (response) => response.statusCode != 200,
          requestPen: AnsiPen()..xterm(87),
        );
  }
}

class Logger {
  Logger([Object? obj, String name = 'LOG']) {
    _log(obj, name);
  }

  Logger.init({TalkerConfig? talkerConfig}) {
    _talkerConfig = talkerConfig ?? TalkerConfig();
  }

  static TalkerConfig _talkerConfig = TalkerConfig();

  static json(response, [String name = 'JSON']) {
    _log(_prettyJSON(response), name, true);
  }

  static void critical(dynamic msg, [Object? error, StackTrace? stackTrace]) {
    _talkerConfig._talker.critical(msg, error, stackTrace);
  }

  static void info(dynamic msg, [Object? error, StackTrace? stackTrace]) {
    _talkerConfig._talker.info(msg, error, stackTrace);
  }

  static void error(dynamic msg, [Object? error, StackTrace? stackTrace]) {
    _talkerConfig._talker.error(msg, error, stackTrace);
  }

  static void debug(dynamic msg, [Object? error, StackTrace? stackTrace]) {
    _talkerConfig._talker.debug(msg, error, stackTrace);
  }

  static void verbose(dynamic msg, [Object? error, StackTrace? stackTrace]) {
    _talkerConfig._talker.verbose(msg, error, stackTrace);
  }

  static void warning(dynamic msg, [Object? error, StackTrace? stackTrace]) {
    _talkerConfig._talker.warning(msg, error, stackTrace);
  }

  static void ex(Object exception, [StackTrace? stackTrace, dynamic msg]) {
    _talkerConfig._talker.handle(exception, stackTrace, msg);
  }

  static String _prettyJSON(response) {
    try {
      var encoder = const JsonEncoder.withIndent("  ");
      return encoder.convert(response);
    } catch (e) {
      _log(e, '_prettyJSON');
      return response;
    }
  }

  static void _log(Object? obj, [String name = 'LOG', bool isJson = false]) {
    Talker talk;

    if (_talkerConfig.fullHistory) {
      talk = _talkerConfig._talker;
    } else {
      talk = Talker(
        logger: TalkerLogger(
          formatter: const _SimpleLogFormatter(),
          output: (v) => log(v, name: _talkerConfig.logPrefix),
        ),
      );
    }
    talk.logTyped(_TypedLogger(obj.toString(), name, isJson));
  }
}

class _SimpleLogFormatter implements LoggerFormatter {
  const _SimpleLogFormatter();

  @override
  String fmt(LogDetails details, TalkerLoggerSettings settings) {
    final underline = ConsoleUtils.getUnderline(
      settings.maxLineWidth,
      lineSymbol: settings.lineSymbol,
    );
    final topLine = ConsoleUtils.getTopline(
      settings.maxLineWidth,
      lineSymbol: settings.lineSymbol,
    );

    final msg = details.message?.toString() ?? '';

    final msgBorderedLines = msg.split('\n').map((e) => '  $e');

    if (!settings.enableColors) {
      return '$topLine\n$msg\n$underline';
    }

    var lines = [topLine, ...msgBorderedLines, underline];
    lines = lines.map((e) => details.pen.write(e)).toList();
    final coloredMsg = lines.join('\n');
    return coloredMsg;
  }
}

class SimpleRouteLogger extends TalkerLog {
  SimpleRouteLogger({
    required Route route,
    bool isPush = true,
  }) : super(_createMessage(route, isPush));

  @override
  String generateTextMessage() {
    return '[$title]  $displayMessage';
  }

  @override
  String get key => TalkerLogType.route.key;

  @override
  AnsiPen get pen => AnsiPen()..xterm(38);

  static String _createMessage(
    Route<dynamic> route,
    bool isPush,
  ) {
    final buffer = StringBuffer();
    buffer.write(isPush ? 'Open' : 'Close');
    buffer.write(' route named ');
    buffer.write(route.settings.name ?? 'null');

    final args = route.settings.arguments;
    if (args != null) {
      buffer.write('\nArguments: $args');
    }
    return buffer.toString();
  }
}

class _TypedLogger extends TalkerLog {
  _TypedLogger(super.message, String title, [this.isJson = false])
      : super(title: title);

  final bool isJson;

  @override
  String generateTextMessage() {
    return '[$title]  $displayMessage$displayStackTrace';
  }

  @override
  AnsiPen? get pen {
    if (isJson) return AnsiPen()..green();
    return super.pen;
  }
}
