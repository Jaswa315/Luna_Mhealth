import 'package:flutter/material.dart';

class SlideNavigationControls extends StatefulWidget {
  final PageController pageController;
  final int numberOfSlides;

  SlideNavigationControls(
      {required this.pageController, required this.numberOfSlides});

  @override
  _SlideNavigationControlsState createState() =>
      _SlideNavigationControlsState();
}

class _SlideNavigationControlsState extends State<SlideNavigationControls> {
  late int currentPageIndex;

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.pageController.initialPage;
    widget.pageController.addListener(_updatePageIndex);
  }

  void _updatePageIndex() {
    if (widget.pageController.page!.round() != currentPageIndex) {
      setState(() {
        currentPageIndex = widget.pageController.page!.round();
      });
    }
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_updatePageIndex);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Previous Slide Button
        IconButton(
          icon: Icon(Icons.arrow_back,
              color: currentPageIndex > 0 ? Colors.black : Colors.grey),
          onPressed: currentPageIndex > 0
              ? () {
                  widget.pageController.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              : null,
        ),
        // Home Button
        IconButton(
          icon: Icon(Icons.restart_alt,
              color: currentPageIndex > 0 ? Colors.black : Colors.grey),
          onPressed: currentPageIndex > 0
              ? () {
                  widget.pageController.animateToPage(
                    0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              : null,
        ),
        // Next Slide Button
        IconButton(
          icon: Icon(Icons.arrow_forward,
              color: currentPageIndex < widget.numberOfSlides - 1
                  ? Colors.black
                  : Colors.grey),
          onPressed: currentPageIndex < widget.numberOfSlides - 1
              ? () {
                  widget.pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              : null,
        ),
      ],
    );
  }
}
