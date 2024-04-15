import 'package:flutter/material.dart';
import 'presentation_parser.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PPT Parser',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PPT Parser'),
        ),
        body: ParseScreen(),
      ),
    );
  }
}

class ParseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              parsePPT();
            },
            child: Text('Parse PPT'),
          ),
        ],
      ),
    );
  }

  void parsePPT() async {
    
    String filePath = "assets/Luna_sample_module.pptx";
    PresentationParser.parsePPT(filePath);

  }
}