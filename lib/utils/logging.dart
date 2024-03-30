import 'dart:io';
import 'package:azure_application_insights/azure_application_insights.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/widgets.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:package_info/package_info.dart';

enum LunaSeverityLevel { Verbose, Information, Warning, Error, Critical }

enum LunaLoggingResult { Success, Error }

abstract class LunaLogger {
  void logEvent(String eventName, LunaSeverityLevel severity,
      {Map<String, Object>? additionalProperties});
  void logError(Exception error, StackTrace stack, bool isFatal,
      {Map<String, Object>? additionalProperties});
  void logTrace(String message, LunaSeverityLevel severity,
      {Map<String, Object>? additionalProperties});
}

class LogManager {
  static final LogManager _instance = LogManager._internal();
  late final List<LunaLogger> _loggers;
  static bool _initialized = false;

  factory LogManager() {
    if (!_initialized) {
      throw Exception(
          'LogManager not initialized. Call createInstance() first.');
    }
    return _instance;
  }

  LogManager._internal() {
    _loggers = [];
  }

  static Future<LogManager> createInstance() async {
    if (GlobalConfiguration().getValue('UseApplicationInsightsLogging') == 1) {
      LunaLogger aiLogger = await ApplicationInsightsLogger.createInstance();
      _instance._loggers.add(aiLogger);
    }
    if (GlobalConfiguration().getValue('UseDartLogging') == 1) {
      LunaLogger dartLogger = DartLogger();
      _instance._loggers.add(dartLogger);
    }
    _initialized = true;
    return _instance;
  }

  void addLogger(LunaLogger logger) {
    _loggers.add(logger);
  }

  void removeLogger(LunaLogger logger) {
    _loggers.remove(logger);
  }

  void logEvent(String eventName, LunaSeverityLevel severity,
      {Map<String, Object>? additionalProperties}) {
    for (var i = 0; i < _loggers.length; i++) {
      _loggers[i].logEvent(eventName, severity,
          additionalProperties: additionalProperties);
    }
  }

  void logError(Exception error, StackTrace stack, bool isFatal,
      {Map<String, Object>? additionalProperties}) {
    for (var i = 0; i < _loggers.length; i++) {
      _loggers[i].logError(error, stack, isFatal,
          additionalProperties: additionalProperties);
    }
  }

  void logTrace(String message, LunaSeverityLevel severity,
      {Map<String, Object>? additionalProperties}) {
    for (var i = 0; i < _loggers.length; i++) {
      _loggers[i].logTrace(message, severity,
          additionalProperties: additionalProperties);
    }
  }

  // stack trace will be the line in the calling function, not the failing line from the callback
  Future<dynamic> logFunction(
      String functionName, Future<dynamic> Function() callback,
      {Map<String, Object>? additionalParameters}) async {
    additionalParameters ??= {};
    additionalParameters['functionName'] = functionName;
    final Stopwatch stopwatch = Stopwatch()..start();
    try {
      final result = await callback();
      final message = '$functionName executed successfully';
      additionalParameters['executionTimeMS'] = stopwatch.elapsedMilliseconds;
      additionalParameters['result'] = LunaLoggingResult.Success.toString();
      LogManager().logTrace(message, LunaSeverityLevel.Information,
          additionalProperties: additionalParameters);
      return result;
    } catch (error) {
      LogManager().logError(
          Exception(error), _scrubTraceLastEntry(StackTrace.current), false,
          additionalProperties: additionalParameters);
      rethrow;
    } finally {
      stopwatch.stop();
    }
  }

  StackTrace _scrubTraceLastEntry(StackTrace trace) {
    List<String> frames = trace.toString().split('\n');
    frames.removeAt(0); // Removes LogFunction frame
    frames.removeAt(0); // Removes "asynchronous pause info"
    String modifiedStackTrace = frames.join('\n');
    return StackTrace.fromString(modifiedStackTrace);
  }
}

class VersionManager {
  static String _cachedVersion = "Unknown";

  Future<String> getAppVersion() async {
    if (_cachedVersion == "Unknown") {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      _cachedVersion = packageInfo.version;
    }
    return _cachedVersion;
  }
}

class DartLogger implements LunaLogger {
  static final DartLogger _instance = DartLogger._internal();

  factory DartLogger() {
    return _instance;
  }

  DartLogger._internal() {
    _initializeLogging();
  }

  late final Logger _logger;

  void _initializeLogging() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      stdout.write('${record.level.name}: ${record.time}: ${record.message}\n');
    });

    _logger = Logger('DartLogger');
  }

  @override
  void logEvent(String eventName, LunaSeverityLevel severity,
      {Map<String, Object>? additionalProperties}) {
    _logMessage('[Event] $eventName', severity, additionalProperties);
  }

  @override
  void logError(Exception error, StackTrace stack, bool isFatal,
      {Map<String, Object>? additionalProperties}) {
    _logger.log(
        isFatal ? Level.SHOUT : Level.SEVERE,
        additionalProperties != null ? additionalProperties.toString() : '',
        '[Error] ${error.toString()}',
        stack,
        null);
  }

  @override
  void logTrace(String message, LunaSeverityLevel severity,
      {Map<String, Object>? additionalProperties}) {
    _logMessage('[Trace] $message', severity, additionalProperties);
  }

  void _logMessage(String message, LunaSeverityLevel severity,
      Map<String, Object>? additionalProperties,
      [StackTrace? stack]) {
    Level logLevel;
    logLevel = _severityFactory(severity);

    _logger.log(
      logLevel,
      message,
      additionalProperties != null ? additionalProperties.toString() : '',
    );
  }

  Level _severityFactory(LunaSeverityLevel severity) {
    switch (severity) {
      case LunaSeverityLevel.Verbose:
        return Level.FINE;
      case LunaSeverityLevel.Information:
        return Level.INFO;
      case LunaSeverityLevel.Warning:
        return Level.WARNING;
      case LunaSeverityLevel.Error:
        return Level.SEVERE;
      case LunaSeverityLevel.Critical:
        return Level.SHOUT;
      default:
        throw Exception("Invalid severity level: $severity");
    }
  }
}

class ApplicationInsightsLogger implements LunaLogger {
  static final ApplicationInsightsLogger _instance =
      ApplicationInsightsLogger._internal();

  late final Client _client;
  late final BufferedProcessor _processor;
  late final TelemetryClient _telemetryClient;
  static bool _initialized = false;

  factory ApplicationInsightsLogger() {
    if (!_initialized) {
      throw Exception('Logger not initialized. Call createInstance() first.');
    }
    return _instance;
  }

  ApplicationInsightsLogger._internal();

  static Future<ApplicationInsightsLogger> createInstance() async {
    if (!_initialized) {
      await _instance._init();
      _initialized = true;
    }
    return _instance;
  }

  Future<void> _init() async {
    _client = Client();
    // Note: We might want to change this or make a separate client to a
    // non-buffered processor for immediate errors later.
    _processor = BufferedProcessor(
      next: TransmissionProcessor(
        instrumentationKey:
            GlobalConfiguration().getValue('AppInsightsInstrumentationKey'),
        httpClient: _client,
        timeout: const Duration(seconds: 10),
      ),
    );
    _telemetryClient = TelemetryClient(processor: _processor);
    await _initDeviceContext();
  }

  @override
  Future<void> logTrace(String message, LunaSeverityLevel severity,
      {Map<String, Object>? additionalProperties}) async {
    _telemetryClient.trackTrace(
        message: message,
        severity: _severityFactory(severity),
        timestamp: DateTime.now().toUtc(),
        additionalProperties: additionalProperties ?? {});
  }

  @override
  Future<void> logEvent(String eventName, LunaSeverityLevel severity,
      {Map<String, Object>? additionalProperties}) async {
    _telemetryClient.trackEvent(
        name: eventName,
        timestamp: DateTime.now().toUtc(),
        additionalProperties: additionalProperties ?? {});
  }

  Future<void> logError(Exception error, StackTrace stack, bool isFatal,
      {Map<String, Object>? additionalProperties}) async {
    _telemetryClient.trackError(
      severity: isFatal ? Severity.critical : Severity.error,
      error: error,
      stackTrace: stack,
      timestamp: DateTime.now().toUtc(),
      additionalProperties: additionalProperties ?? {},
    );
  }

  Severity _severityFactory(LunaSeverityLevel lunaSeverity) {
    switch (lunaSeverity) {
      case LunaSeverityLevel.Verbose:
        return Severity.verbose;
      case LunaSeverityLevel.Information:
        return Severity.information;
      case LunaSeverityLevel.Warning:
        return Severity.warning;
      case LunaSeverityLevel.Error:
        return Severity.error;
      case LunaSeverityLevel.Critical:
        return Severity.critical;
      default:
        throw Exception("Invalid severity level: $lunaSeverity");
    }
  }

  Future<void> _initDeviceContext() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    DeviceContext deviceContext = _telemetryClient.context.device;

    _telemetryClient.context.applicationVersion = VersionManager._cachedVersion;

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceContext.id = androidInfo.androidId;
      deviceContext.model = androidInfo.model;
      deviceContext.osVersion = androidInfo.version.toString();
      deviceContext.oemName = androidInfo.manufacturer;
      deviceContext.locale = Platform.localeName;
      deviceContext.type = 'Android';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceContext.id = iosInfo.identifierForVendor;
      deviceContext.model = iosInfo.model;
      deviceContext.osVersion = iosInfo.systemVersion;
      deviceContext.oemName = iosInfo.name;
      deviceContext.locale = Platform.localeName;
      deviceContext.type = 'iOS';
    } else {
      deviceContext.id = Platform.localHostname;
      deviceContext.model = Platform.operatingSystem;
      deviceContext.osVersion = Platform.operatingSystemVersion;
      deviceContext.locale = Platform.localeName;
      String deviceType = "Unknown";
      String deviceOemName = "Unknown";
      if (Platform.isWindows) {
        deviceType = "Windows";
      } else if (Platform.isMacOS) {
        deviceType = "MacOS";
        deviceOemName = "Apple";
      } else if (Platform.isLinux) {
        deviceType = "Linux";
      }
      deviceContext.type = deviceType;
      deviceContext.oemName = deviceOemName;
    }
  }
}

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("app_settings");
  LogManager lm = await LogManager.createInstance();

  await lm.logFunction('exampleMethod', () async {
    exampleMethod();
  });

  await lm.logFunction('exampleEvent', () async {
    exampleEvent();
  });

  try {
    await lm.logFunction('exampleErrorMethod', () async {
      exampleErrorMethod();
    });
  } catch (error) {}
}

void exampleMethod() {
  print('this is my method');
}

void exampleEvent() {
  print('this is my event');
}

void exampleErrorMethod() {
  print('this is my error method');
  throw Exception("Oops, I did it again!");
}
