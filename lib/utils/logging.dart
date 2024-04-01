// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import 'dart:io';
import 'package:azure_application_insights/azure_application_insights.dart';
import 'package:device_info/device_info.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:package_info/package_info.dart';

/// Enum representing the calibrated severity levels for logging.
enum LunaSeverityLevel {
  /// Verbose level logging, providing detailed information.
  Verbose,

  /// Information level logging, providing general information.
  /// Used for typical trace calls.
  Information,

  /// Warning level logging, indicating potential issues.
  Warning,

  /// Error level logging, indicating errors that occurred but did not prevent the application from functioning.
  Error,

  /// Critical level logging, indicating critical errors that may result in application failure.
  /// Typically used/set by the global application exception handler
  Critical
}

/// Enum representing the result status of a logging operation.
enum LunaLoggingResult {
  /// Indicates a successful operation
  Success,

  /// Indicates a failure operation.  Used for failing methods, 5XX, and 4XX calls.
  Failure
}

/// An interface for logging events, errors, and traces.
///
/// Implementations of this interface should provide methods for logging
/// different types of messages with various severity levels and additional properties.
abstract class ILunaLogger {
  /// Logs an event with the specified name and severity level.
  ///
  /// [eventName] specifies the name of the event to log.
  /// [severity] specifies the severity level of the event.
  /// [additionalProperties] contains additional properties associated with the event.
  void logEvent(String eventName, LunaSeverityLevel severity,
      {Map<String, Object>? additionalProperties});

  /// Logs an error with the specified details.
  ///
  /// [error] specifies the error object to log.
  /// [stack] contains the stack trace associated with the error.
  /// [isFatal] indicates whether the error is fatal.
  /// [additionalProperties] contains additional properties associated with the error.
  void logError(Object error, StackTrace stack, bool isFatal,
      {Map<String, Object>? additionalProperties});

  /// Logs a trace message with the specified details.
  ///
  /// [message] specifies the message to log.
  /// [severity] specifies the severity level of the trace.
  /// [additionalProperties] contains additional properties associated with the trace.
  void logTrace(String message, LunaSeverityLevel severity,
      {Map<String, Object>? additionalProperties});
}

/// [LogManager] provides logging functionality and management for the Luna application.
///
/// The [LogManager] class is responsible for managing a list of [ILunaloggers]
/// and providing methods for logging events, errors, and traces.
/// It also allows adding, removing, and clearing loggers from the list.
///
/// You can use the [logFunction] method to wrap your calls with logging to capture
/// result, elapsed duration, and device context properties.  Alternately, you can
/// use [logTrace], [logEvent], and [logError] directly.
/// 
/// Requirements:
/// 
/// To have LogManager calls work correctly, the Flutter Widgets Binding must be
/// initialized and the Global Configuration must be loaded at some point in the
/// runtime.  This will normally happen from main.dart -> run
/// 
/// Requirements usage:
/// 
/// ```
/// WidgetsFlutterBinding.ensureInitialized();
/// await GlobalConfiguration().loadFromAsset("app_settings");
/// await LogManager.createInstance();
/// ```
class LogManager {
  static final LogManager _instance = LogManager._internal();
  late final List<ILunaLogger> _loggers;
  static bool _initialized = false;

  /// Returns a singleton instance of the LogManager if already initialized with
  /// createInstance().
  ///
  /// Throws an [Exception] if the instance is accessed before initialization.
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

  /// Creates an instance of the LogManager and initializes it.
  ///
  /// If [populateLoggers] is true, initializes loggers based on configuration.
  /// Returns the singleton instance of the LogManager.
  static Future<LogManager> createInstance(
      [bool populateLoggers = true]) async {    
    if (populateLoggers) {
      if (GlobalConfiguration().getValue<bool>('UseApplicationInsightsLogging')) {
        ILunaLogger aiLogger = await ApplicationInsightsLogger.createInstance();
        _instance._loggers.add(aiLogger);
      }
      if (GlobalConfiguration().getValue<bool>('UseDartLogging')) {
        ILunaLogger dartLogger = DartLogger();
        _instance._loggers.add(dartLogger);
      }
    }
    _initialized = true;
    return _instance;
  }

  /// Adds a logger to the list of loggers.
  ///
  /// [logger] is the logger to be added.
  void addLogger(ILunaLogger logger) {
    _loggers.add(logger);
  }

  /// Removes a logger from the list of loggers.
  ///
  /// [logger] is the logger to be removed.
  void removeLogger(ILunaLogger logger) {
    _loggers.remove(logger);
  }

  /// Clears all loggers from the list.
  void clearLoggers() {
    _loggers.clear();
  }

  /// Returns a list of loggers.
  List<ILunaLogger> getLoggers() {
    return _loggers;
  }

  /// Logs an event with the specified event name and severity level.
  ///
  /// [eventName] is the name of the event to be logged.
  /// [severity] is the severity level of the event.
  /// [additionalProperties] contains additional properties associated with the event log.
  ///
  /// This method iterates through all registered loggers and invokes their logEvent method
  /// to log the event with the provided name, severity level, and additional properties.
  ///
  /// Typical usage:
  /// ```
  /// LogManager lm = await LogManager.createInstance();
  /// lm.logEvent('Your Event Message', LunaSeverityLevel.Information,
  ///        additionalProperties: {'key': 'value'});
  /// ```
  void logEvent(String eventName, LunaSeverityLevel severity,
      {Map<String, Object>? additionalProperties}) {
    for (var i = 0; i < _loggers.length; i++) {
      _loggers[i].logEvent(eventName, severity,
          additionalProperties: additionalProperties);
    }
  }

  /// Logs an error with the specified error object, stack trace, and fatal indicator.
  ///
  /// [error] is the error object to be logged.
  /// [stack] is the stack trace associated with the error.
  /// [isFatal] indicates whether the error is considered fatal. isFatal = true is
  /// typically used by the global application error handler only.
  /// [additionalProperties] contains additional properties associated with the error log.
  ///
  /// This method iterates through all registered loggers and invokes their logError method
  /// to log the error with the provided stack trace, fatal indicator, and additional properties.
  ///
  /// Typical usage:
  /// ```
  /// LogManager lm = await LogManager.createInstance();
  /// final Stopwatch stopwatch = Stopwatch()..start();
  /// try{
  ///    doSomething()
  /// }
  /// catch (error, stackTrace) {
  ///    additionalParameters['result'] = LunaLoggingResult.Failure.toString();
  ///    additionalParameters['executionTimeMS'] = stopwatch.elapsedMilliseconds;
  ///    logError(error, stackTrace, false,
  ///        additionalProperties: additionalParameters);
  /// ```
  void logError(Object error, StackTrace stack, bool isFatal,
      {Map<String, Object>? additionalProperties}) {
    for (var i = 0; i < _loggers.length; i++) {
      _loggers[i].logError(error, stack, isFatal,
          additionalProperties: additionalProperties);
    }
  }

  /// Logs a trace message with the specified message and severity level.
  ///
  /// [message] is the trace message to be logged.
  /// [severity] indicates the severity level of the trace message.
  /// [additionalProperties] contains additional properties associated with the trace log.
  ///
  /// This method iterates through all registered loggers and invokes their logTrace method
  /// to log the trace message with the provided severity level and additional properties.
  ///
  /// Typical usage:
  /// ```
  /// LogManager lm = await LogManager.createInstance();
  /// lm.logTrace('Example trace message', LunaSeverityLevel.Information,
  ///    additionalProperties: {'key': 'value'});
  /// ```
  void logTrace(String message, LunaSeverityLevel severity,
      {Map<String, Object>? additionalProperties}) {
    for (var i = 0; i < _loggers.length; i++) {
      _loggers[i].logTrace(message, severity,
          additionalProperties: additionalProperties);
    }
  }

  /// Synchronously logs a message using the specified callback function.
  ///
  /// [functionName] specifies the name of the function being logged.
  /// [callback] is the function to be executed and logged.
  /// [additionalParameters] contains additional parameters associated with the log.
  ///
  /// Typical usage:
  /// ```
  /// LogManager lm = await LogManager.createInstance();
  /// lm.logFunctionSync('testMethod', () {
  ///    syncMethod();
  /// });
  /// ```
  dynamic logFunctionSync(String functionName, dynamic Function() callback,
      {Map<String, Object>? additionalParameters}) {
    try {
      final result = callback();
      logFunction(functionName, () async => result,
          additionalParameters: additionalParameters);
      return result;
    } catch (error) {
      rethrow;
    }
  }

  /// Asynchronously logs a message using the specified callback function.
  ///
  /// [functionName] specifies the name of the function being logged.
  /// [callback] is the function to be executed and logged.
  /// [additionalParameters] contains additional parameters associated with the log.
  ///
  /// Typical usage:
  /// ```
  /// (wrapping outgoing call)
  /// LogManager lm = await LogManager.createInstance();
  /// await lm.logFunctionSync('testMethod', () async {
  ///    method();
  /// });
  /// 
  /// or 
  /// 
  /// (wrapping public method)
  /// Future<Module> addModule(String moduleName, String jsonData) async {
  ///   return await LogManager().logFunction('addModule', () async {
  ///     ... normal function body ...
  ///   });
  /// }
  /// ```
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
      logTrace(message, LunaSeverityLevel.Information,
          additionalProperties: additionalParameters);
      return result;
    } catch (error, stackTrace) {
      additionalParameters['result'] = LunaLoggingResult.Failure.toString();
      additionalParameters['executionTimeMS'] = stopwatch.elapsedMilliseconds;
      logError(error, stackTrace, false,
          additionalProperties: additionalParameters);
      logTrace('$functionName execution failed', LunaSeverityLevel.Error,
          additionalProperties: additionalParameters);
      rethrow;
    } finally {
      stopwatch.stop();
    }
  }
}

/// Provides version-related functionality for the application.
///
/// The VersionManager class is responsible for retrieving the current
/// version of the application.
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

/// A simple console logger implementation that logs messages using the Dart 
/// logging package.
/// 
/// /// Recommend not using directly.  Use LogManager instead.
class DartLogger implements ILunaLogger {
  static final DartLogger _instance = DartLogger._internal();

  /// Factory constructor returning the singleton instance of [DartLogger].
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
      print('${record.level.name}: ${record.time}: ${record.message}:\n');
      if (record.error != null && record.stackTrace != null) {
        print('${record.error}: \n${record.stackTrace}\n');
      }
    });

    _logger = Logger('DartLogger');
  }

  @override
  void logEvent(String eventName, LunaSeverityLevel severity,
      {Map<String, Object>? additionalProperties}) {
    _logMessage('[Event] $eventName', severity);
  }

  @override
  void logError(Object error, StackTrace stack, bool isFatal,
      {Map<String, Object>? additionalProperties}) {
    if (isFatal) {
      _logger.severe(error.toString(), error, stack);
    } else {
      _logger.severe(error.toString(), error, stack);
    }
  }

  @override
  void logTrace(String message, LunaSeverityLevel severity,
      {Map<String, Object>? additionalProperties}) {
    _logMessage('[Trace] $message', severity);
  }

  void _logMessage(String message, LunaSeverityLevel severity) {
    Level logLevel;
    logLevel = _severityFactory(severity);

    _logger.log(logLevel, message, [null, null, null]);
  }

  /// Maps a [LunaSeverityLevel] to a corresponding Dart Logger [Level].
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

/// A logger implementation that logs messages to Azure Application Insights
/// 
/// Note: Must call createInstance() before using the class.
/// 
/// Recommend not using directly.  Use LogManager instead.
class ApplicationInsightsLogger implements ILunaLogger {
  static final ApplicationInsightsLogger _instance =
      ApplicationInsightsLogger._internal();

  late Client _client;
  late BufferedProcessor _processor;
  late TelemetryClient _telemetryClient;
  static bool _initialized = false;

  /// Factory constructor returning the singleton instance of [ApplicationInsightsLogger].
  /// 
  /// Will throw an [Exception] if createInstance() is not called first.
  factory ApplicationInsightsLogger() {
    if (!_initialized) {
      throw Exception('Logger not initialized. Call createInstance() first.');
    }
    return _instance;
  }

  ApplicationInsightsLogger._internal();

  /// Initializes the logger with the provided HTTP client and processor.
  ///
  /// If [resetInstance] is `true`, the logger instance is reset with a new TelemetryContext.
  /// 
  /// [Client] and [BufferedProcessor] can be passed in to augment or mock default 
  /// behaviors.
  static Future<ApplicationInsightsLogger> createInstance(
      {bool resetInstance = false,
      Client? client,
      BufferedProcessor? processor}) async {
    if (!_initialized || resetInstance) {
      await _instance._init(client: client, processor: processor);
      _initialized = true;
    }
    return _instance;
  }

  /// Initializes the logger with the provided HTTP client and processor.
  Future<void> _init({Client? client, BufferedProcessor? processor}) async {
    _client = client ?? Client();
    // Note: We might want to change this or make a separate client to a
    // non-buffered processor for immediate errors later.
    _processor = processor ??
        BufferedProcessor(
          next: TransmissionProcessor(
            instrumentationKey:
                GlobalConfiguration().getValue('AppInsightsInstrumentationKey'),
            // ToDo: Cow telemetry work goes here
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

  @override
  Future<void> logError(Object error, StackTrace stack, bool isFatal,
      {Map<String, Object>? additionalProperties}) async {
    _telemetryClient.trackError(
      severity: isFatal ? Severity.critical : Severity.error,
      error: error,
      stackTrace: stack,
      timestamp: DateTime.now().toUtc(),
      additionalProperties: additionalProperties ?? {},
    );
  }

  /// Maps a [LunaSeverityLevel] to a corresponding [Severity] for Application Insights.
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

  /// Initializes the device context for telemetry data.
  /// 
  /// Will set Device Type, Model, osVersion, etc.  /// 
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
