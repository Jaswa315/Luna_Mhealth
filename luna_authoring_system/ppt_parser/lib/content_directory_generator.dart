import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:ppt_parser/module_text_elements.dart';
import 'package:ppt_parser/presentation_parser.dart';
import 'package:ppt_parser/presentation_tree.dart';

class ContentDirectoryGenerator {
  // Constructor can be empty if no initialization is needed
  ContentDirectoryGenerator();

  // Initializes the directory structure under the specified root
  Future<bool> initializeDirectory(
      String pptxLocation, String defaultLanguage, String targetRoot) async {
    // Check if the target root directory exists
    final Directory targetRootDir = Directory(targetRoot);
    if (!targetRootDir.existsSync()) {
      print('The target root directory does not exist: $targetRoot');
      return false; // Return false immediately if the root does not exist
    }

    // Use the new method to find the PPTX file name. This will be the content module data folder name.
    String? pptxName = _findPptxFileName(pptxLocation);
    if (pptxName == null) {
      return false;
    }

    // create the content module data directory under the root
    bool success = await _initializeFolders(pptxName, targetRoot);
    if (!success) {
      print("Did not create module directory structure folders");
      return false;
    }

    // Attempt to copy the PPTX file and handle failure
    if (!(await _copyPPTXtoPPTXFolder(pptxLocation, pptxName, targetRoot))) {
      print('Failed to copy the PPTX file.');
      return false; // Exit if the copying fails
    }

    await addLanguage("$targetRoot/$pptxName", defaultLanguage);

    return true; // If all operations succeed
  }

// Method to add a new language to the resources under the specified module data location
  Future<bool> addLanguage(
      String moduleDataLocation, String newLanguage) async {
    // Validate the existing directory structure
    if (!await _isValidContentModuleDataDirectoryStructure(
        moduleDataLocation)) {
      print('Directory structure is not valid for: $moduleDataLocation');
      return false;
    }

    // Construct the path for the new language directory under module/resources
    String newLanguagePath =
        path.join(moduleDataLocation, 'module', 'resources', newLanguage);
    Directory newLanguageDirectory = Directory(newLanguagePath);

    // Check if the directory for the new language already exists
    if (newLanguageDirectory.existsSync()) {
      print(
          'Language directory already exists for: $newLanguage at $newLanguagePath');
      return false; // Return false because the language already exists
    }

    // If you reach this point, no directory exists, and you can proceed with creation
    try {
      // create the folder for our new language under resources
      newLanguageDirectory.createSync(recursive: true);
      // generate the associated CSV file
      File pptxFile = _getFirstPptxFile("$moduleDataLocation/pptx");
      PresentationParser parser = PresentationParser(pptxFile);
      PrsNode prsTree = parser.parsePresentation();
      ModuleTextElements moduleData = ModuleTextElements(prsTree, newLanguage);
      await moduleData.generateCSV(newLanguage, newLanguagePath);
      return true; // Return true to indicate the operation was successful
    } catch (e) {
      print('Failed to create the language directory: $e');
      return false;
    }
  }

  // Function to retrieve the first .pptx file from the pptx directory
File _getFirstPptxFile(String pptxDirectoryPath) {
    // Create a directory object
    Directory pptxDir = Directory(pptxDirectoryPath);

    // Get the list of files in the directory
    List<FileSystemEntity> files = pptxDir.listSync();

    // Find the first .pptx file
    FileSystemEntity pptxFile = files.firstWhere(
        (file) => file.path.endsWith('.pptx'), 
        orElse: () => throw FileSystemException("No PPTX file found")
    );

    return File(pptxFile.path);  // Return the File object for the first .pptx file
}

// Private helper method to validate the required directory structure
Future<bool> _isValidContentModuleDataDirectoryStructure(String moduleDataLocation) async {
  // Validate the 'pptx' and 'module/resources' directories
  List<String> requiredPaths = [
    path.join(moduleDataLocation, 'pptx'),
    path.join(moduleDataLocation, 'module'),
    path.join(moduleDataLocation, 'module', 'resources')
  ];

  for (String requiredPath in requiredPaths) {
    if (!Directory(requiredPath).existsSync()) {
      print('Required directory does not exist: $requiredPath');
      return false; // Return false if any required directory is missing
    }
  }

  // Ensure there is exactly one PPTX file in the pptx directory
  Directory pptxDir = Directory(requiredPaths[0]);
  var pptxFiles = pptxDir.listSync().where((file) => file.path.endsWith('.pptx')).toList();

  if (pptxFiles.length != 1) {
    print('Expected exactly one PPTX file in the pptx directory, found ${pptxFiles.length}: ${requiredPaths[0]}');
    return false;
  }

  return true; // All validations passed, exactly one PPTX file exists
}

// This method assumes the pptx folder already exists and attempts to copy a .pptx file into it.
  Future<bool> _copyPPTXtoPPTXFolder(
      String pptxLocation, String pptxName, String targetRoot) async {
    // Construct the path where the .pptx file should be copied.
    String targetForPPTXCopy = path.join(targetRoot, pptxName, 'pptx');

    // Ensure the target directory exists before attempting to copy.
    Directory targetDirectory = Directory(targetForPPTXCopy);
    if (!targetDirectory.existsSync()) {
      print('Target directory does not exist: $targetForPPTXCopy');
      return false;
    }

    // Define the target file path within the newly verified directory.
    File newPptxFile = File(path.join(targetForPPTXCopy, '$pptxName.pptx'));

    try {
      // Copy the original .pptx file to the new location asynchronously.
      await File(pptxLocation).copy(newPptxFile.path);
      print('Successfully copied the PPTX file to: ${newPptxFile.path}');
      return true;
    } catch (e) {
      // Handle any errors that might occur during the copy process.
      print('Failed to copy the PPTX file: $e');
      return false;
    }
  }

  // Method to check if a .pptx file exists at the given path and return the file name without extension
  String? _findPptxFileName(String fullPath) {
    final file = File(fullPath);
    if (!file.existsSync()) {
      print('The specified PPTX file does not exist: $fullPath');
      return null;
    }

    // Ensure the file is a .pptx file
    if (path.extension(fullPath).toLowerCase() != '.pptx') {
      print('The specified file is not a .pptx file: $fullPath');
      return null;
    }

    // Extract the file name without the extension
    return path.basenameWithoutExtension(fullPath);
  }

  Future<bool> _initializeFolders(String folderName, String root) async {
    // Construct the path for the main directory under the root
    String mainFolderPath = path.join(root, folderName);
    Directory mainFolder = Directory(mainFolderPath);

    // Log the path to check what is being evaluated
    print(
        'Checking existence of directory at: ${mainFolder.path} (absolute path: ${mainFolder.absolute.path})');

    // Check if the folder already exists
    if (mainFolder.existsSync()) {
      print('The folder "${mainFolder.path}" already exists at "${root}".');
      return false; // If it exists, return false immediately
    }

    // If it does not exist, create the folder and its subdirectories
    try {
      // Attempt to create the main folder
      print('Creating directory at: ${mainFolder.path}');
      mainFolder.createSync(recursive: true);
      print('Successfully created directory at: ${mainFolder.path}');

      // Create the 'pptx' subdirectory
      String pptxPath = path.join(mainFolderPath, 'pptx');
      Directory(pptxPath).createSync(recursive: true);
      print('Created pptx directory at: $pptxPath');

      // Create the 'module/resources' subdirectory
      String resourcesPath = path.join(mainFolderPath, 'module', 'resources');
      Directory(resourcesPath).createSync(recursive: true);
      print('Created resources directory at: $resourcesPath');

      return true; // Return true if all directories were created successfully
    } catch (e) {
      // Handle and log any exceptions that occur during directory creation
      print('Failed to initialize folders: $e');
      return false; // Return false if there was an error during the creation process
    }
  }
}
