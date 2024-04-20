import 'package:talker_flutter/talker_flutter.dart';

class SimpleLogFormatter implements LoggerFormatter {
  const SimpleLogFormatter();

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
