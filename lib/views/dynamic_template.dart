import 'package:flutter/material.dart';
import 'package:luna_mhealth_mobile/utils/constants.dart';

import '../models/component_model.dart';
import '../models/slide_model.dart';
import '../services/json_parser_service.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/slide_navigation_controls.dart';

class DynamicTemplate extends StatefulWidget {
  const DynamicTemplate({Key? key}) : super(key: key);

  @override
  _DynamicTemplateState createState() => _DynamicTemplateState();
}

class _DynamicTemplateState extends State<DynamicTemplate> {
  final JsonParserService _jsonParserService = JsonParserService();
  List<Slide> slides = [];
  bool isLoading = true;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadSlides();
  }

  Future<void> _loadSlides() async {
    try {
      String jsonString =
          await _jsonParserService.readJsonFile(AppConstants.testJsonFilePath);
      slides = await _jsonParserService.parseJsonToSlides(jsonString);
    } catch (e) {
      print('Error loading slides: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Luna',
        showBackButton: true,
        showSoundToggle: true,
        isSoundOn: false,
        showSettings: true,
        actions: [
          SlideNavigationControls(
              pageController: _pageController, numberOfSlides: slides.length)
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: slides.length,
                    itemBuilder: (context, index) => _buildSlide(slides[index]),
                  ),
                ),
              ],
            ),
    );
  }

  /// Builds UI for each slide.
  Widget _buildSlide(Slide slide) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: slide.components
            .map((component) => _buildComponent(component))
            .toList(),
      ),
    );
  }

  /// Builds UI for each component in a slide.
  Widget _buildComponent(Component component) {
    switch (component.type) {
      case 'text':
        return Text(component.text ?? '');
      case 'image':
        return Image.asset(
          component.imageUrl ?? '',
          width: component.width,
          height: component.height,
        );
      default:
        return const SizedBox.shrink(); // Handle unknown component types
    }
  }

  @override
  void dispose() {
    _pageController.dispose(); // Properly dispose of the PageController
    super.dispose();
  }
}
