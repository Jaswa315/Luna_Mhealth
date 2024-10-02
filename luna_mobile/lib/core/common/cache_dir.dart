import 'package:path_provider/path_provider.dart';

/// List the contents of the cache directory.
Future<List<String>> listCacheDirContents() async {
  final cacheDir = await getTemporaryDirectory();
  final contents = cacheDir.listSync();
  List<String> paths = [];
  for (var fileSystemEntity in contents) {
    paths.add(fileSystemEntity.path);
  }
  return paths;
}
