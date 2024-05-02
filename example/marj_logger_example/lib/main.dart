import 'package:flutter/material.dart';
import 'package:marj_logger/marj_logger.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.configure();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
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
            Button(
              label: 'No history',
              onPressed: () {
                MLogger('No history', 'M LOG');
              },
            ),
            Button(
              label: 'History',
              onPressed: () {
                MLogger.info('History', 'M LOG');
              },
            ),
            Button(
              label: 'Error',
              onPressed: () {
                MLogger.error('ERROR', 'M LOG');
              },
            ),
            Button(
              label: 'JSON',
              onPressed: () {
                MLogger.json(jsonData);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MLogger.openLogHistory(context);
        },
        tooltip: 'History',
        child: const Icon(Icons.history_rounded),
      ),
    );
  }
}

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final void Function()? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: onPressed,
          child: Text(label),
        ),
      ),
    );
  }
}

final jsonData = {
  "name": "John",
  "age": 30,
  "address": {
    "street": "Main St",
    "city": "New York",
    "state": "NY",
    "zip": "10001"
  }
};
