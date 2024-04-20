import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:marj_logger/src/k_typed_logger.dart';
import 'package:marj_logger/src/logger.dart';
import 'package:marj_logger/src/simple_log_formatter.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

class TalkerConfig {
  TalkerConfig({
    bool? enable,
    bool? logOnConsole,
    LogOutput? output,
    LoggerFormatter? formatter,
    this.logPrefix = '\u276f_',
    TalkerDioLoggerSettings? dioLoggerSettings,
    this.fullHistory = false,
  }) {
    _init(
      enable ?? true,
      logOnConsole ?? true,
      output,
      formatter ?? const SimpleLogFormatter(),
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

  void critical(dynamic msg, [Object? error, StackTrace? stackTrace]) {
    _talker.critical(msg, error, stackTrace);
  }

  void info(dynamic msg, [Object? error, StackTrace? stackTrace]) {
    _talker.info(msg, error, stackTrace);
  }

  void error(dynamic msg, [Object? error, StackTrace? stackTrace]) {
    _talker.error(msg, error, stackTrace);
  }

  void warning(dynamic msg, [Object? error, StackTrace? stackTrace]) {
    _talker.warning(msg, error, stackTrace);
  }

  void ex(Object exception, [StackTrace? stackTrace, dynamic msg]) {
    _talker.handle(exception, stackTrace, msg);
  }

  void typed(TalkerLog log) => _talker.logTyped(log);

  void json(response, String name) {
    simpleLog(_prettyJSON(response), name, true);
  }

  String _prettyJSON(response) {
    try {
      var encoder = const JsonEncoder.withIndent("  ");
      return encoder.convert(response);
    } catch (e) {
      simpleLog(e, '_prettyJSON');
      return response;
    }
  }

  void simpleLog(Object? obj, [String name = 'LOG', bool isJson = false]) {
    if (fullHistory) {
      typed(KTypedLogger(obj.toString(), name, isJson));
      return;
    }

    final talk = Talker(
      logger: TalkerLogger(
        formatter: const SimpleLogFormatter(),
        output: (v) => log(v, name: logPrefix),
      ),
    );
    talk.logTyped(KTypedLogger(obj.toString(), name, isJson));
  }
}
