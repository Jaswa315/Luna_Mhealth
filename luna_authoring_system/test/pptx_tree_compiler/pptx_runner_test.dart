import 'package:flutter_test/flutter_test.dart';
import 'package:luna_authoring_system/pptx_tree_compiler/pptx_runner.dart';
import 'package:luna_authoring_system/helper/authoring_initializer.dart';
import 'dart:io';
import 'package:flutter/services.dart';


void main() {
  group('Tests for PptxRunner using A line.pptx', () {


    TestWidgetsFlutterBinding.ensureInitialized();

    //platform channels are not available in unit tests
    //taken from package_info_plus github (https://github.com/fluttercommunity/plus_plugins/blob/main/packages/package_info_plus/package_info_plus/test/package_info_test.dart)
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


    // mock path provider too
    const path_channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(path_channel, (MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return 'assets/test_data/'; 
      }
      return null;
    });

    tearDown(() {
      log.clear();
    });




    final pptxFile = File('test/test_assets/A line.pptx');
    // setUp(() {
    //   // Use fake path provider to account for non-mobile unit tests
    //   storageProvider = LocalStorageProvider.withPathPlatformProvider(
    //       FakePathProviderPlatform());
    // });
    test('parsePptx method initialzes title.', () async {
      await AuthoringInitializer.initializeAuthoring();
      await PptxRunner().processPptx(pptxFile, "unit_test_luna");
    });

  });
}