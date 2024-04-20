#

## A wrapper over the [talker_flutter](https://pub.dev/packages/talker_flutter) package to help with consol logging

 This package was created for Internal uses of our MARJ Dev Team. This is a simple wrapper over the existing [talker_flutter](https://pub.dev/packages/talker_flutter) and [talker_dio_logger](https://pub.dev/packages/talker_dio_logger) by [Stanislav Ilin](https://github.com/Frezyx), simplifying some functionality and reusability across deferent projects.

## Get Started

Follow these steps to the coolest experience in error handling

### Add dependency

```yaml
dependencies:
  marj_logger: latest
```

### To use

You can use Logger instance everywhere in your app.

```dart
import 'package:marj_logger/marj_logger.dart';

  // logs data and does not save in history unless Logger.configure.fullHistory is set to true
  Logger('log simple data');

  // Just logs
  Logger.info('some info');
  Logger.warning('A warning 😥');
  Logger.error('Error')
  Logger.critical('Critical Error')

  // Handling Exception's and Error's
  try {
    throw Exception('Some Error/Exception ❌');
  } catch (e, st) {
    Logger.ex(e, st,'error');
  }

  final map = {
                'key1': 'value1',
                'key2': 'value2',
                'key3': {
                  'key4': 'value4',
                  'key5': ['value5', 'value6'],
                },
            };

    // Prints pretty JSON and does not save in history unless Logger.configure.fullHistory is set to true
    Logger.json(map);

    // open the page containing all log history
    Logger.openHistory(context);
  
```

### Configure the Logger

You can configure the Logger by

```dart
import 'package:marj_logger/marj_logger.dart';

void main() {

  Logger.configure(
    
    // Enable logging
    enable: true,

    // Prints the log on consol
    logOnConsole: true,
    // Output function

    output: (msg) => print(msg),
    // Use full history or not
    fullHistory: true,

    // If Logger.configure.output is not defend this will be the Log.name 
    logPrefix: 'LOG',
  );

  runApp(const MyApp());
}
  
```
