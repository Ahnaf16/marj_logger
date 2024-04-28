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
              onPressed: () {
                Logger('This is a normal log');
              },
              label: 'Normal LOG',
            ),
            Button(
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
              label: 'JSON LOG',
            ),
            Button(
                label: 'Critical',
                onPressed: () => Logger.critical('Critical')),
            Button(label: 'Error', onPressed: () => Logger.error('Error')),
            Button(
                label: 'Warning', onPressed: () => Logger.warning('Warning')),
            Button(label: 'Info', onPressed: () => Logger.info('Info')),
            Button(
              label: 'M LOG',
              onPressed: () => MLogger().info('LOG\nLOG2', 'M LOG'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MLogger().openLogHistory(context);
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
