import 'dart:io';
import 'package:cross_file/src/types/interface.dart';
import 'package:flutter/material.dart';

import '../utils/image_compression.dart'; // Adjust the import path

class TestImageCompressionPage extends StatefulWidget {
  @override
  _TestImageCompressionPageState createState() =>
      _TestImageCompressionPageState();
}

class _TestImageCompressionPageState extends State<TestImageCompressionPage> {
  File? _originalImage;
  File? _compressedImage;

  void _compressImage() async {
    // Hardcoded file path for demonstration
    String imagePath = 'assets/images/image5.png'; // file path
    _originalImage = File(imagePath);

    XFile? compressedFile =
        await ImageCompression.compressImage(_originalImage!);
    setState(() {
      _compressedImage = compressedFile as File?;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Image Compression')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (_originalImage != null) Image.file(_originalImage!),
          if (_compressedImage != null) Image.file(_compressedImage!),
          ElevatedButton(
            onPressed: _compressImage,
            child: Text('Compress Image'),
          ),
        ],
      ),
    );
  }
}
