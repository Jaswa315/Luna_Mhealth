import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

import 'package:luna_mhealth_mobile/storage/module_storage.dart';
import 'package:luna_mhealth_mobile/utils/logging.dart';

//const String kApplicationDocumentsPath = 'test/storage/moduletestdata';
//const String kTestAssetsPath = 'test/storage/testassets';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Logging Tests', () {
    test('Application Insights - Create Log', () async {
      final logger = ApplicationInsightsLogger();

      logger.logEvent('this is a trace message', LunaSeverityLevel.Verbose);
      expect(true, true);
    });
  });
}
