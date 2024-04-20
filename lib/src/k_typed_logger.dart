import 'package:talker_flutter/talker_flutter.dart';

class KTypedLogger extends TalkerLog {
  KTypedLogger(super.message, String title, [this.isJson = false])
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
