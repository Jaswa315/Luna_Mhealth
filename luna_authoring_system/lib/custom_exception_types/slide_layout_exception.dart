class SlideLayoutException implements Exception {
  final String message;
  SlideLayoutException(this.message);
  
  @override
  String toString() => 'SlideLayoutException: $message';
}