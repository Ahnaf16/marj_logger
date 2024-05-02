import 'package:flutter/material.dart';
import 'package:marj_logger/src_new/log_data.dart';
import 'package:marj_logger/src_new/logger.dart';

class LogScreen extends StatelessWidget {
  const LogScreen({super.key, required this.logHistory});

  final List<LogData> logHistory;
  static final RegExp _ansiRegExp = RegExp(r'\u001b\[[0-9;]*m');

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Builder(
        builder: (context) {
          final styles = Theme.of(context).textTheme;
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.menu_rounded),
                ),
                const SizedBox(width: 10)
              ],
            ),
            body: ListView.builder(
              itemCount: logHistory.length,
              itemBuilder: (context, index) {
                final history = logHistory[index];
                final text = history.lines
                    .map((l) => l.replaceAll(_ansiRegExp, ''))
                    .join('\n');

                final color = levelColors(history.level);

                return Card.outlined(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: color.withOpacity(.05),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: color, width: .7),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: history.name,
                                children: [
                                  TextSpan(
                                    text: ' | '
                                        '${history.time.hour.toString().padLeft(2, '0')}:'
                                        '${history.time.minute.toString().padLeft(2, '0')} '
                                        '${history.time.hour < 12 ? 'am' : 'pm'} ',
                                    style: styles.labelSmall,
                                  ),
                                ],
                              ),
                              style: styles.labelMedium,
                            ),
                            IconButton(
                              style: IconButton.styleFrom(iconSize: 18),
                              padding: const EdgeInsets.all(5),
                              constraints: const BoxConstraints(),
                              visualDensity: VisualDensity.compact,
                              onPressed: () {},
                              icon: const Icon(Icons.copy_rounded),
                            ),
                          ],
                        ),
                        Divider(height: 15, color: color.withOpacity(.4)),
                        const SizedBox(height: 3),
                        Text(
                          text,
                          style: styles.labelLarge,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Color levelColors(LogLevel l) => switch (l) {
        LogLevel.debug => Colors.grey,
        LogLevel.info => const Color(0xFF568264),
        LogLevel.error => const Color(0xFFC41E1E),
        LogLevel.json => Colors.pink,
      };
}
