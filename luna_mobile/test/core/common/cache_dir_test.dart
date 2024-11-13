import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:luna_mobile/core/common/cache_dir.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// use test junk folder
const String testJunkPath = 'test/junk';

class MockPathProviderPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  //Override getTemporaryPath so that getTemporaryDirectory works outside android/ios devices
  @override
  Future<String> getTemporaryPath() async {
    return testJunkPath;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    PathProviderPlatform.instance = MockPathProviderPlatform();
  });

  group('Cache Dir Exists Tests', () {
    setUp(() async {
      await new Directory(testJunkPath).create();
    });

    test('Cache Dir Has One File', () async {
      await new File(testJunkPath + '/test_file.txt').create();
      List<String> cacheContents = await listCacheDirContents();
      expect(cacheContents.length, 1);
    });

    test('Cache Dir Has Zero Files', () async {
      List<String> cacheContents = await listCacheDirContents();
      expect(cacheContents.length, 0);
    });

    tearDown(() async {
      // clear out all files in the test folder
      await new Directory(testJunkPath).delete(recursive: true);
    });
  });
}
