import 'dart:convert';
import 'dart:typed_data';
import 'dart:collection';
import 'dart:io';
import 'dart:ui';


// Handles localization tasks by managing a map of localized strings indexed by UIDs.
// This class is responsible for parsing CSV data into a map for efficient lookup of localized strings.
// The primary task of ModuleTextStrings is to parse CSV data to map UIDs to their corresponding localized strings and 
// provide a method (getString) to retrieve these strings based on their UIDs. 
// This is important for displaying the correct localized text in the application based on user settings or system locale.
class LocalizedText extends IterableBase<String> {
  final Map<int, String> _localizedStrings = {};
  Locale _locale;
  int _idCounter = 1;

  // Default constructor with optional locale parameter
  // Fallback to English if locale is null
  //
  // We can initialize LocalizedText with the actual device locale. 
  // In a Flutter app, we could pass the locale from the widget like this:
  // var textLocalizer = LocalizedText(Localizations.localeOf(context));
  //
  LocalizedText([Locale? locale]) : _locale = locale ?? Locale('en', ''); 

 // Constructor that initializes from CSV data with optional locale parameter
  LocalizedText.fromCsv(Uint8List csvBytes, [Locale? locale]) : _locale = locale ?? Locale('en', '') {
    _parseCsvToMap(csvBytes);
  }

  // Locale getter
  Locale get locale => _locale;

  // Locale setter 
  set locale(Locale newLocale) {
    _locale = newLocale;
  }

  // Iterable interface implementation
  @override
  Iterator<String> get iterator => _localizedStrings.values.iterator;

  // Adding isEmpty getter for tests 
  bool get isEmpty => _localizedStrings.isEmpty;

  // Parses CSV formatted data to populate the localization map
  // @Param csvBytes : A byte array representing CSV data. This data should be encoded in UTF-8 format.
  // This function updates the internal map [_localizedStrings] by mapping UIDs to their corresponding localized texts
  void _parseCsvToMap(Uint8List csvBytes) {
    String csvString = utf8.decode(csvBytes);
    List<String> rows = csvString.split('\n');
    for (var row in rows.skip(1)) {
      var columns = row.split(',');
      if (columns.length >= 3) {
        // Parse the UID from the first column
        int? uid = int.tryParse(columns[0].trim());
        // Improve error handling by throwing an exception if parsing fails, 
        // which will alert the caller to the problem instead of continuing in a bad state
        if (uid == null) {
          throw FormatException('Failed to parse UID from the row: $row');
        }
        // Trim and store the localized text from the third column
        String localizedText = columns[2].trim();
        _localizedStrings[uid] = localizedText;
      }
      else {
        throw FormatException('Invalid row format: $row');
      }
    }
  }

  // Getter for specific string by UID
  // Retrieves a localized string by its UID
  // Returns the localized string associated with the provided UID, if found.
  // "Text not found" if the UID does not exist in the localization map.
  String getString(int uid) {
    return _localizedStrings[uid] ?? "Text not found";
  }

  // Setter that adds or changes a string and returns its UID
  int addString(String toAdd) {
    int id = _idCounter++;
    _localizedStrings[id] = toAdd;
    return id;
  }

  // Generate the CSV string from the internal map
  String generateCsvContent() {
    StringBuffer csvBuffer = StringBuffer();
    csvBuffer.writeln("UID,localizedText"); 
    _localizedStrings.forEach((uid, text) {
      csvBuffer.writeln("$uid,$text");
    });
    return csvBuffer.toString();
  }
  
  // Return the CSV data as bytes
  Uint8List getCsvBytes() {
    String csvContent = generateCsvContent();
    return Uint8List.fromList(utf8.encode(csvContent));
  }

  // Method to write CSV data to a file
  Future<void> writeCsvToFile(String filePath) async {
    String csvContent = generateCsvContent();
    File file = File(filePath);
    await file.writeAsString(csvContent);
  }
}