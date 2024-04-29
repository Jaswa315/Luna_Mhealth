import 'package:path_provider/path_provider.dart';

/// List the contents of the cache directory.
Future<void> listCacheDirContents() async {
  final cacheDir = await getTemporaryDirectory();
  final contents = cacheDir.listSync();
  for (var fileSystemEntity in contents) {
    print(fileSystemEntity.path);
  }
}
