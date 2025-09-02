import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/helper/authoring_initializer.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_runner.dart';
import 'package:luna_authoring_system/providers/validation_issues_store.dart';
import 'package:luna_core/storage/module_resource_factory.dart';
import 'package:path/path.dart';
import 'package:luna_authoring_system/builder/module_constructor.dart';
import 'package:luna_core/models/module.dart';

void main() {
  group('Tests for PptxRunner using A line.pptx', () {
    const testDir = 'test/output';

    TestWidgetsFlutterBinding.ensureInitialized();

    const channel = MethodChannel('dev.fluttercommunity.plus/package_info');
    final log = <MethodCall>[];

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'getAll':
            return <String, dynamic>{
              'appName': 'Luna',
              'buildNumber': '1',
              'packageName': 'luna.core',
              'version': '1.0',
              'installerStore': null,
            };
          default:
            assert(false);
            return null;
        }
      },
    );

    const path_channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(path_channel, (MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return testDir;
      }
      return null;
    });

    tearDown(() async {
      // If it exists, clean it up between tests.
      if (await Directory(testDir).exists()) {
        await Directory(testDir).delete(recursive: true);
      }
      log.clear();
    });

    final pptxFile = File('test/test_assets/A line.pptx');

    test('Process PPTX makes a luna file.', () async {
      const fileName = 'unit_test_luna';
      final filePath = join(testDir, "$fileName.luna");
      final store = ValidationIssuesStore();

      await AuthoringInitializer.initializeAuthoring();

      // Build PPTX tree 
      final tree = await PptxRunner(store).buildTree(pptxFile.path, fileName);

      // Build Module from tree
      final Module module = await ModuleConstructor(tree).constructLunaModule();

      //Save module explicitly
      await ModuleResourceFactory.addModule(fileName, jsonEncode(module.toJson()));


      expect(await File(filePath).exists(), true);
    });
  });
}
