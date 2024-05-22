// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:io';
import 'dart:core';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_core/utils/logging.dart';
import 'package:mockito/mockito.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:azure_application_insights/azure_application_insights.dart';

var log = [];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GlobalConfiguration().loadFromAsset("app_settings");

  group('LogManager Tests', () {
    test('LogManager - Singleton create fail', () async {
      expect(() {
        LogManager manager = LogManager();
      }, throwsException);
    });

    test('LogManager - AddLoggers', () async {
      LogManager lm = await LogManager.createInstance(false);
      lm.clearLoggers();
      MockLogger mockLogger = MockLogger();

      expect(lm.getLoggers().length, 0);

      lm.addLogger(mockLogger);

      expect(lm.getLoggers().length, 1);
      expect(lm.getLoggers()[0], mockLogger);
      lm.clearLoggers();
    });

    test('LogManager - ClearLoggers', () async {
      LogManager lm = await LogManager.createInstance(false);
      lm.clearLoggers();
      MockLogger mockLogger = MockLogger();

      lm.addLogger(mockLogger);
      expect(lm.getLoggers().length, 1);

      lm.removeLogger(mockLogger);
      expect(lm.getLoggers().length, 0);
      lm.clearLoggers();
    });

    test('LogManager - Create Event', overridePrint(() async {
      log.clear();
      LogManager lm = await LogManager.createInstance(false);
      lm.clearLoggers();
      MockLogger mockLogger = MockLogger();

      lm.addLogger(mockLogger);

      lm.logEvent('TestEvent', LunaSeverityLevel.Information,
          additionalProperties: {'key': 'value'});

      expect(log[0], contains('Event: TestEvent'));
      expect(log[0], contains('Severity: LunaSeverityLevel.Information'));
      expect(log[1], contains('Additional Properties: {key: value}'));
      log.clear();
      lm.clearLoggers();
    }));

    test('LogManager - Create Trace', overridePrint(() async {
      log.clear();
      LogManager lm = await LogManager.createInstance(false);
      lm.clearLoggers();
      MockLogger mockLogger = MockLogger();

      lm.addLogger(mockLogger);

      lm.logTrace('TestTrace', LunaSeverityLevel.Critical,
          additionalProperties: {'key': 'value'});

      expect(log[0], contains('Trace: TestTrace'));
      expect(log[0], contains('Severity: LunaSeverityLevel.Critical'));
      expect(log[1], 'Additional Properties: {key: value}');
      log.clear();
      lm.clearLoggers();
    }));

    test('LogManager - Create Exception', overridePrint(() async {
      log.clear();
      LogManager lm = await LogManager.createInstance(false);
      lm.clearLoggers();
      MockLogger mockLogger = MockLogger();

      lm.addLogger(mockLogger);

      lm.logError(Exception('TestError'), StackTrace.fromString('empty'), true,
          additionalProperties: {'key': 'value'});

      expect(log[0], 'Error: Exception: TestError, Is Fatal: true');
      expect(log[1], 'Stack Trace: empty');
      expect(log[2], 'Additional Properties: {key: value}');
      log.clear();
      lm.clearLoggers();
    }));

    test('LogManager - void LogFunction', overridePrint(() async {
      log.clear();
      LogManager lm = await LogManager.createInstance(false);
      lm.clearLoggers();
      MockLogger mockLogger = MockLogger();

      lm.addLogger(mockLogger);

      await lm.logFunction('testMethod', () async {
        testMethod();
      });

      expect(log[0],
          'Trace: testMethod executed successfully, Severity: LunaSeverityLevel.Information');
      expect(log[1], contains('Additional Properties'));
      expect(log[1], contains('functionName: testMethod'));
      expect(log[1], contains('executionTimeMS:'));
      expect(log[1], contains('result: LunaLoggingResult.Success'));
      log.clear();
      lm.clearLoggers();
    }));

    test('LogManager - int LogFunction', overridePrint(() async {
      log.clear();
      LogManager lm = await LogManager.createInstance(false);
      lm.clearLoggers();
      MockLogger mockLogger = MockLogger();
      int retVal = 0;

      lm.addLogger(mockLogger);

      await lm.logFunction('testMethodInt', () async {
        retVal = testMethodInt();
      });

      expect(retVal, 1);
      expect(log[0],
          'Trace: testMethodInt executed successfully, Severity: LunaSeverityLevel.Information');
      expect(log[1], contains('Additional Properties'));
      expect(log[1], contains('functionName: testMethodInt'));
      expect(log[1], contains('executionTimeMS:'));
      expect(log[1], contains('result: LunaLoggingResult.Success'));
      log.clear();
      lm.clearLoggers();
    }));

    test('LogManager - void LogFunctionSync', overridePrint(() async {
      log.clear();
      LogManager lm = await LogManager.createInstance(false);
      lm.clearLoggers();
      MockLogger mockLogger = MockLogger();

      lm.addLogger(mockLogger);

      await lm.logFunctionSync('testMethod', () {
        testMethod();
      });

      expect(log[0],
          'Trace: testMethod executed successfully, Severity: LunaSeverityLevel.Information');
      expect(log[1], contains('Additional Properties'));
      expect(log[1], contains('functionName: testMethod'));
      expect(log[1], contains('executionTimeMS:'));
      expect(log[1], contains('result: LunaLoggingResult.Success'));

      log.clear();
    }));

    test('LogManager - int LogFunctionSync', overridePrint(() async {
      log.clear();
      LogManager lm = await LogManager.createInstance(false);
      lm.clearLoggers();
      MockLogger mockLogger = MockLogger();
      int retVal = 0;

      lm.addLogger(mockLogger);

      await lm.logFunctionSync('testMethodInt', () {
        retVal = testMethodInt();
      });

      expect(retVal, 1);
      expect(log[0],
          'Trace: testMethodInt executed successfully, Severity: LunaSeverityLevel.Information');
      expect(log[1], contains('Additional Properties'));
      expect(log[1], contains('functionName: testMethodInt'));
      expect(log[1], contains('executionTimeMS:'));
      expect(log[1], contains('result: LunaLoggingResult.Success'));

      log.clear();
      lm.clearLoggers();
    }));

    test('LogManager - Error LogFunction', overridePrint(() async {
      log.clear();
      LogManager lm = await LogManager.createInstance(false);
      lm.clearLoggers();
      MockLogger mockLogger = MockLogger();

      lm.addLogger(mockLogger);

      expect(() async {
        await lm.logFunction('testErrorMethod', () async {
          testErrorMethod();
        });
      }, throwsException);

      await Future.delayed(Duration(seconds: 1));

      expect(log[0], 'Error: Exception: example method error, Is Fatal: false');
      expect(log[1], contains('Stack Trace:'));
      expect(log[2], contains('functionName: testErrorMethod'));
      expect(log[2], contains('executionTimeMS:'));
      expect(log[2], contains('result: LunaLoggingResult.Failure'));

      expect(log[3],
          'Trace: testErrorMethod execution failed, Severity: LunaSeverityLevel.Error');
      log.clear();
      lm.clearLoggers();
    }));
  });

  group('DartLogger Tests', () {
    test('Dart Console Logger - Create Event', overridePrint(() async {
      log.clear();
      final logger = DartLogger();

      logger.logEvent('TestEvent', LunaSeverityLevel.Information);

      expect(log[0], contains('[Event] TestEvent'));
      expect(log[0], contains('INFO'));
      log.clear();
    }));

    test('Dart Console Logger - Create Trace', overridePrint(() async {
      log.clear();
      final logger = DartLogger();

      logger.logTrace('Message', LunaSeverityLevel.Verbose);

      expect(log[0], contains('[Trace] Message'));
      expect(log[0], contains('FINE'));
      log.clear();
    }));

    test('Dart Console Logger - Create Error', overridePrint(() async {
      log.clear();
      final logger = DartLogger();

      logger.logError(
          Exception("error"), StackTrace.fromString("empty"), false);

      expect(log[0], contains('Exception: error'));
      expect(log[0], contains('SEVERE'));
      log.clear();
    }));
  });

  group('Application Insights Logging Tests', () {
    test('Application Insights - Constructor', () {
      ApplicationInsightsLogger.createInstance().then((createdLogger) {
        expect(createdLogger, isNotNull);
      });
    });

    test('Application Insights - Create Trace Log', () {
      final mockProcessor = MockBufferedProcessor();

      ApplicationInsightsLogger.createInstance(
              resetInstance: true, processor: mockProcessor)
          .then((createdLogger) {
        createdLogger.logTrace(
          'Test message',
          LunaSeverityLevel.Verbose,
          additionalProperties: {'key': 'value'},
        ).then((_) {
          ContextualTelemetryItem contextItem = mockProcessor.getItem();

          var result =
              contextItem.telemetryItem.serialize(context: contextItem.context);

          expect(result['baseData']['message'], 'Test message');
          expect(result['baseData']['severityLevel'], 0);
          expect(result['baseData']['properties']['key'], 'value');
        });
      });
    });

    test('Application Insights - Create Error Log', () {
      final mockProcessor = MockBufferedProcessor();

      ApplicationInsightsLogger.createInstance(
              resetInstance: true, processor: mockProcessor)
          .then((createdLogger) {
        createdLogger.logError(
          Exception("test exception"),
          StackTrace.fromString("empty"),
          false,
          additionalProperties: {'key': 'value'},
        ).then((_) {
          ContextualTelemetryItem contextItem = mockProcessor.getItem();

          var result =
              contextItem.telemetryItem.serialize(context: contextItem.context);

          expect(result['baseData']['exceptions'][0]['message'],
              'Exception: test exception');
          expect(result['baseData']['severityLevel'], 3);
          expect(result['baseData']['properties']['key'], 'value');
        });
      });
    });

    test('Application Insights - Create Event Log', () async {
      final mockProcessor = MockBufferedProcessor();

      ApplicationInsightsLogger.createInstance(
              resetInstance: true, processor: mockProcessor)
          .then((createdLogger) {
        createdLogger.logEvent(
          'test event',
          LunaSeverityLevel.Information,
          additionalProperties: {'key': 'value'},
        ).then((_) {
          ContextualTelemetryItem contextItem = mockProcessor.getItem();

          var result =
              contextItem.telemetryItem.serialize(context: contextItem.context);

          expect(result['baseData']['name'], 'test event');
          expect(result['baseData']['properties']['key'], 'value');
        });
      });
    });
  });
}

// need to mock and create a second buffer for access
class MockBufferedProcessor extends Mock implements BufferedProcessor {
  List<ContextualTelemetryItem> _buffer = [];

  @override
  void process({
    required List<ContextualTelemetryItem> contextualTelemetryItems,
  }) {
    _buffer.add(contextualTelemetryItems[0]);
  }

  ContextualTelemetryItem getItem() {
    int retry = 0;

    // internally async process call somewhere, will do a retry loop
    while (_buffer.isEmpty && retry < 5) {
      sleep(Duration(seconds: 1));
      retry += 1;
    }

    return _buffer[0];
  }
}

// from https://stackoverflow.com/questions/14764323/how-do-i-mock-or-verify-a-call-to-print-in-dart-unit-tests
void Function() overridePrint(void testFn()) => () {
      var spec = new ZoneSpecification(print: (_, __, ___, String msg) {
        // Add to log instead of printing to stdout
        log.add(msg);
      });
      return Zone.current.fork(specification: spec).run<void>(testFn);
    };

class MockLogger implements ILunaLogger {
  @override
  void logEvent(String eventName, LunaSeverityLevel severity,
      {Map<String, Object>? additionalProperties}) {
    print('Event: $eventName, Severity: $severity');
    if (additionalProperties != null) {
      print('Additional Properties: $additionalProperties');
    }
  }

  @override
  void logError(Object error, StackTrace stack, bool isFatal,
      {Map<String, Object>? additionalProperties}) {
    print('Error: $error, Is Fatal: $isFatal');
    print('Stack Trace: $stack');
    if (additionalProperties != null) {
      print('Additional Properties: $additionalProperties');
    }
  }

  @override
  void logTrace(String message, LunaSeverityLevel severity,
      {Map<String, Object>? additionalProperties}) {
    print('Trace: $message, Severity: $severity');
    if (additionalProperties != null) {
      print('Additional Properties: $additionalProperties');
    }
  }
}

void testMethod() {}

int testMethodInt() {
  return 1;
}

void testErrorMethod() {
  throw Exception("example method error");
}
