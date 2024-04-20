import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';

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
