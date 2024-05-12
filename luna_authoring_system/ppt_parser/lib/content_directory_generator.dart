import 'dart:io';
import 'dart:ui';
import 'package:path/path.dart' as path;
import 'package:luna_mhealth_mobile/utils/logging.dart';

// Content Directory Generator provides tools and methods to generate the proper
// structure for the content module data. The generated structures are supposed
// to support holding all required assets needed to run a Luna content module
class ContentDirectoryGenerator {
  // ContentDirectoryGenerator has no data values, it's a utility class
  ContentDirectoryGenerator();

  /// Initializes the directory structure for a content module based on the provided PowerPoint file.
  ///
  /// This method performs several key operations to set up a directory structure necessary for a content module:
  /// - Checks if the specified root directory exists. If not, no directory is initialized.
  /// - Finds the PowerPoint (.pptx) file name from the provided location to name the content module directory.
  /// - Creates the necessary directory structure under the root directory. The content module data will be
  /// the same name as the powerpoint file given in the pptxLocation.
  /// - Copies the PowerPoint file into pptx subfolder.
  /// - Adds a default language directory and initializes it.
  ///
  ///
  /// Example: if we ran initializeDirectory(testassets/HelloWorld.pptx, en-US, root)
  /// Then our generated directory, assuming all parameters given are valid, would be:
  ///
  /// [pptxLocation] specifies the full path to the PowerPoint file which will be used to name and populate the module directory.
  /// [defaultLanguage] is the default language name (e.g., 'en-US') which will be the default language under module/resources/
  /// [targetRoot] is the root directory under which the content module directory structure will be created.
  ///
  /// Returns a [Future<bool>] that completes with `true` if the directory structure was initialized successfully, otherwise `false`.
  ///
  /// Throws [FileSystemException] if any file operations fail, or if the specified PowerPoint file does not exist.
  Future<bool> initializeDirectory(
      String pptxLocation, Locale defaultLanguage, String targetRoot) async {
    await LogManager()
        .logFunction('ContentDirectoryGenerator.initializeDirectory', () async {
      // Check if the target root directory exists
      final Directory targetRootDir = await Directory(targetRoot);
      if (!targetRootDir.existsSync()) {
        LogManager().logTrace(
            'The target root directory does not exist: $targetRoot',
            LunaSeverityLevel.Verbose);
        return false; // Return false immediately if the root does not exist
      }

      // Use the new method to find the PPTX file name. This will be the content module data folder name.
      String? pptxName = await _findPptxFileName(pptxLocation);
      if (pptxName == null) {
        return false;
      }

      // create the content module data directory under the root
      bool success = await _initializeFolder(pptxName, targetRoot);
      if (!success) {
        LogManager().logTrace(
            'Did not create module directory structure folders',
            LunaSeverityLevel.Verbose);
        return false;
      }

      // Attempt to copy the PPTX file and handle failure
      if (!(await _copyPPTXtoPPTXFolder(pptxLocation, pptxName, targetRoot))) {
        LogManager().logTrace(
            'Failed to copy the PPTX file.', LunaSeverityLevel.Verbose);
        return false; // Exit if the copying fails
      }

      await addLanguage("$targetRoot/$pptxName", defaultLanguage);
    });
    return true;
  }

  /// Adds a new language directory and initializes it within the specified module data location.
  ///
  /// This method performs several key operations:
  /// - Validates that the existing directory structure is appropriate for adding a new language. It checks that
  ///   the required 'pptx', 'module', and 'resources' directories exist.
  /// - Checks if a directory for the new language already exists under 'module/resources'. If it exists, the method
  ///   returns `false` to indicate that the language directory could not be added because it already exists.
  ///
  /// The first step of this method is validating that the given moduleDataLocation parameter
  /// is valid. It needs to be the content module data name, which has pptx/ and resources/ under it
  ///
  /// [moduleDataLocation] specifies the root directory of the content module where the language will be added.
  /// This should be the path to the directory containing 'pptx' and 'module/resources'.
  ///
  /// [newLanguage] is the name of the new language directory to be added (e.g., 'en-US').
  /// This will be the name of the language folder under resources/
  ///
  /// Returns a [Future<bool>] that completes with `true` if the language directory was successfully created,
  /// or `false` if any step of the process fails, including if the directory structure is not valid or if the
  /// language directory already exists.
  ///
  /// Throws [FileSystemException] if file operations fail, such as during or directory creation
  Future<bool> addLanguage(
      String moduleDataLocation, Locale newLanguage) async {
    await LogManager().logFunction('ContentDirectoryGenerator.addLanguage',
        () async {
      // Validate the existing directory structure
      if (!await _isValidContentModuleDataDirectoryStructure(
          moduleDataLocation)) {
        LogManager().logTrace(
            'Directory structure is not valid for: $moduleDataLocation',
            LunaSeverityLevel.Verbose);
        return false;
      }

      String languageLocaleAsString = newLanguage.toLanguageTag();

      // Construct the path for the new language directory under module/resources
      String newLanguagePath =
          await path.join(moduleDataLocation, 'module', 'resources', languageLocaleAsString);
      Directory newLanguageDirectory = await Directory(newLanguagePath);

      // Check if the directory for the new language already exists
      if (newLanguageDirectory.existsSync()) {
        LogManager().logTrace(
            'Language directory already exists for: $languageLocaleAsString at $newLanguagePath',
            LunaSeverityLevel.Verbose);
        return false; // Return false because the language already exists
      }

      // If you reach this point, no directory exists, and you can proceed with directory creation
      try {
        // create the folder for our new language under resources
        await newLanguageDirectory.create(recursive: true);
        return true; // Return true to indicate the operation was successful
      } catch (e) {
        LogManager().logTrace('Failed to create the language directory: $e',
            LunaSeverityLevel.Error);
        return false;
      }
    });
    return true;
  }
  
  /// Validates the structure of a directory intended for content module data.
  ///
  /// This method checks if all the necessary subdirectories exist within the specified directory,
  /// ensuring it has the appropriate structure to function as a content module directory.
  /// It verifies the presence of a 'pptx' directory, a 'module' directory, and a 'resources' directory
  /// under 'module'. Additionally, it checks that there is exactly one PowerPoint file in the 'pptx' directory.
  ///
  /// [moduleDataLocation] specifies the path to the content module's root directory where the structure will be validated.
  ///
  /// Returns a [Future<bool>] indicating whether the directory structure meets the expected criteria.
  /// `true` if the structure is valid, `false` otherwise.
  ///
  /// Example of a valid directory structure:
  /// ```
  /// root/
  ///   HelloWorld/
  ///     pptx/
  ///       HelloWorld.pptx
  ///     module/
  ///       resources/
  ///         en-US/
  ///          
  /// ```
  ///
  /// Example of an invalid directory structure:
  /// ```
  /// root/
  ///   HelloWorld/
  ///     pptdasdx/
  ///     modulesTest/
  /// ```
  ///
  Future<bool> _isValidContentModuleDataDirectoryStructure(
      String moduleDataLocation) async {
    // Validate the 'pptx' and 'module/resources' directories
    List<String> requiredPaths = [
      path.join(moduleDataLocation, 'pptx'),
      path.join(moduleDataLocation, 'module'),
      path.join(moduleDataLocation, 'module', 'resources')
    ];

    for (String requiredPath in requiredPaths) {
      if (!Directory(requiredPath).existsSync()) {
        LogManager().logTrace(
            'Required directory does not exist: $requiredPath',
            LunaSeverityLevel.Verbose);
        return false; // Return false if any required directory is missing
      }
    }

    // Ensure there is exactly one PPTX file in the pptx directory
    Directory pptxDir = Directory(requiredPaths[0]);
    var pptxFiles = pptxDir
        .listSync()
        .where((file) => file.path.endsWith('.pptx'))
        .toList();

    if (pptxFiles.length != 1) {
      LogManager().logTrace(
          'Expected exactly one PPTX file in the pptx directory, found ${pptxFiles.length}: ${requiredPaths[0]}',
          LunaSeverityLevel.Verbose);
      return false;
    }

    return true; // All validations passed, exactly one PPTX file exists
  }

  /// Copies a PowerPoint file to a designated location within a structured content directory.
  ///
  /// This method ensures that the target directory for copying the PowerPoint file exists before proceeding.
  /// It constructs the full path where the PowerPoint file should be copied, verifies the existence of the
  /// target directory, and then performs the copy operation. If the directory does not exist or the copy
  /// operation fails, it will return false, signaling failure.
  ///
  /// [pptxLocation] is the original location of the PowerPoint file.
  /// [pptxName] is the name of the PowerPoint file, used to construct the destination path.
  /// [targetRoot] is the base directory under which the PowerPoint file will be stored.
  ///
  /// Returns a [Future<bool>] that completes with `true` if the file was successfully copied,
  /// otherwise `false`.
  ///
  /// Throws [FileSystemException] if the copying fails due to file system related errors.
  Future<bool> _copyPPTXtoPPTXFolder(
      String pptxLocation, String pptxName, String targetRoot) async {
    String targetForPPTXCopy = path.join(targetRoot, pptxName, 'pptx');
    Directory targetDirectory = Directory(targetForPPTXCopy);

    if (!targetDirectory.existsSync()) {
      LogManager().logTrace(
          'Target directory does not exist: $targetForPPTXCopy',
          LunaSeverityLevel.Critical);
      return false;
    }

    File newPptxFile = File(path.join(targetForPPTXCopy, '$pptxName.pptx'));

    try {
      await File(pptxLocation).copy(newPptxFile.path);
      LogManager().logTrace(
          'Successfully copied the PPTX file to: ${newPptxFile.path}',
          LunaSeverityLevel.Information);
      return true;
    } catch (e) {
      LogManager().logTrace(
          'Failed to copy the PPTX file: $e', LunaSeverityLevel.Error);
      return false;
    }
  }

  /// Checks if a specified .pptx file exists at a given path and extracts the file name without its extension.
  /// This is a helper function used in initialize directory to retrieve the PPTX file name from the given pptx path
  ///
  /// This method verifies the existence of a file at the given path and ensures that it has a '.pptx'
  /// extension. It is particularly used to validate and handle PowerPoint files which are central to
  /// initializing the content directory structure.
  ///
  /// [fullPath] is the path where the PowerPoint file is supposed to be located.
  ///
  /// Returns the file name without the extension if found and valid, otherwise returns `null`.
  ///
  /// Throws [FileSystemException] if the file does not exist or is not a valid PowerPoint file.
  String? _findPptxFileName(String fullPath) {
    final file = File(fullPath);
    if (!file.existsSync()) {
      LogManager().logTrace('The specified PPTX does not exist: $fullPath',
          LunaSeverityLevel.Verbose);
      return null;
    }

    // Ensure the file is a .pptx file
    if (path.extension(fullPath).toLowerCase() != '.pptx') {
      LogManager().logTrace('The specified file is not a .pptx file: $fullPath',
          LunaSeverityLevel.Verbose);
      return null;
    }

    // Extract the file name without the extension
    return path.basenameWithoutExtension(fullPath);
  }

  /// Initializes the specified folder structure under a given root directory for storing module content.
  ///
  /// This method attempts to create the main directory and its essential subdirectories ('pptx' and 'module/resources')
  /// under the specified root. It first checks if the main directory already exists to avoid duplication. If it doesn't
  /// exist, the method proceeds to create it along with the necessary subdirectories.
  ///
  /// [folderName] is the name of the main directory to be created under the [root] directory.
  /// [root] is the root directory under which the new directory structure will be initialized.
  ///
  /// Returns a [Future<bool>] indicating whether the directories were successfully created. Returns `true` if successful,
  /// or `false` if an error occurred or the directories already exist.
  ///
  /// Usage example: Initializing folders for a module called "HelloWorld" would set up directories
  /// for storing its PowerPoint file and resources.
  Future<bool> _initializeFolder(String folderName, String root) async {
    // Construct the path for the main directory under the root
    String mainFolderPath = path.join(root, folderName);
    Directory mainFolder = Directory(mainFolderPath);

    // Log the path to check what is being evaluated
    LogManager().logTrace(
        'Checking existence of directory at: ${mainFolder.path} (absolute path: ${mainFolder.absolute.path})',
        LunaSeverityLevel.Information);

    // Check if the folder already exists
    if (mainFolder.existsSync()) {
      LogManager().logTrace(
          'The folder "${mainFolder.path}" already exists at "${root}".',
          LunaSeverityLevel.Critical);
      return false; // If it exists, return false immediately
    }

    // If it does not exist, create the folder and its subdirectories
    try {
      // Attempt to create the main folder
      LogManager().logTrace('Creating directory at: ${mainFolder.path}',
          LunaSeverityLevel.Information);
      mainFolder.createSync(recursive: true);
      LogManager().logTrace(
          'Successfully created directory at: ${mainFolder.path}',
          LunaSeverityLevel.Information);

      // Create the 'pptx' subdirectory
      String pptxPath = path.join(mainFolderPath, 'pptx');
      Directory(pptxPath).createSync(recursive: true);
      LogManager().logTrace('Created pptx directory at: $pptxPath',
          LunaSeverityLevel.Information);

      // Create the 'module/resources' subdirectory
      String resourcesPath = path.join(mainFolderPath, 'module', 'resources');
      Directory(resourcesPath).createSync(recursive: true);
      LogManager().logTrace('Created resources directory at: $resourcesPath',
          LunaSeverityLevel.Information);

      return true; // Return true if all directories were created successfully
    } catch (e, stacktrace) {
      // Handle and log any exceptions that occur during directory creation
      LogManager().logError(
          'Failed to initialize folders: $e', stacktrace, false);
      return false; // Return false if there was an error during the creation process
    }
  }
}

