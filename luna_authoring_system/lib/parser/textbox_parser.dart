/// maps text boxes
Map<String, String> mapTextBoxes(dynamic jsonData) {
  final Map<String, String> textBoxMap = {};
  var slides = jsonData['Presentation']['children'];

  for (var slide in slides) {
    var slideNumber = slide['Slide']['attributes']['slide_number'].toString();
    var slideContent = slide['Slide']['children'];

    // Filter text boxes only
    var textBoxes = slideContent.where((element) => element['TextBox'] != null).toList();

    for (var i = 0; i < textBoxes.length; i++) {
      // Initialize the key
      var key = 's${slideNumber}t${i + 1}';

      // Extract text from the text box
      List<String> textSegments = [];
      var textBox = textBoxes[i]['TextBox'];
      var textBodies = textBox['children'].where((element) => element['TextBody'] != null).toList();

      for (var textBody in textBodies) {
        var paragraphs = textBody['TextBody']['children'];
        for (var paragraph in paragraphs) {
          var texts = paragraph['Paragraph']['children'];
          for (var text in texts) {
            if (text['Text'] != null) {
              textSegments.add(text['Text']['attributes']['text']);
            }
          }
        }
      }
      var texts = textSegments.join(' ');
      // Add to map
      textBoxMap[key] = texts;
    }
  }
  return textBoxMap;
}
