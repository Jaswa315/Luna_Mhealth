import 'dart:io';
import 'package:path/path.dart' as p;

/// Class to handle input arguments.
class PptxInputHandler {
  static const int numberOfArguments = 2;

  static File processInputs(List<String> arguments) {
    if (arguments.length != numberOfArguments) {
      throw ArgumentError(
        'Usage: flutter run ./lib/main.dart -a <pptx_file_path> -a <module_name>',
      );
    }

    return _getPptxFile(arguments[0]);
  }

  static File _getPptxFile(String pptxFilePath) {
    final fileExtension = p.extension(pptxFilePath);
    final pptxFile = File(pptxFilePath);

    if (fileExtension.toLowerCase() != '.pptx') {
      throw ArgumentError(
        'Invalid file extension: $fileExtension. Only .pptx files are allowed.',
      );
    }

    if (!pptxFile.existsSync()) {
      throw ArgumentError('PPTX file at $pptxFilePath does not exist.');
    }

    return pptxFile;
  }
}
