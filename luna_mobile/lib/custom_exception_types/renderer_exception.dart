class RendererException implements Exception {
  final String message;
  final dynamic cause;

  RendererException(this.message, [this.cause]);

  @override
  String toString() => 'RendererException: $message${cause != null ? ' (Caused by: $cause)' : ''}';
}