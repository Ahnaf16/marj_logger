import 'package:flutter/material.dart';
import 'package:marj_logger/marj_logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('MARJ Logger Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () {
                Logger('This is a normal log');
              },
              child: const Text('Normal LOG'),
            ),
            FilledButton(
              onPressed: () {
                final map = {
                  'key1': 'value1',
                  'key2': 'value2',
                  'key3': {
                    'key4': 'value4',
                    'key5': ['value5', 'value6'],
                  },
                };
                Logger.json(map);
              },
              child: const Text('JSON LOG'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Logger.showHistory(context);
        },
        tooltip: 'History',
        child: const Icon(Icons.history_rounded),
      ),
    );
  }
}
