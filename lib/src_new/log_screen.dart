import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({super.key, required this.logHistory});

  final List<OutputEvent> logHistory;
  @override
  Widget build(BuildContext context) {
    log(logHistory.map((e) => e.lines).toString());
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: logHistory.length,
        itemBuilder: (context, index) {
          final history = logHistory[index];
          return ListTile(
            title: Text(history.lines.join('\n')),
            onTap: () {},
            tileColor: levelColors[history.level],
          );
        },
      ),
    );
  }

  static final Map<Level, Color> levelColors = {
    Level.trace: Colors.grey,
    Level.debug: Colors.grey,
    Level.info: Colors.blue,
    Level.warning: Colors.orange,
    Level.error: Colors.red,
    Level.fatal: Colors.pink,
  };
}
