/// IBuilder is a generic interface for implementing builder patterns.
/// It ensures that all builder classes provide a `build()` method that
/// returns an instance of the desired type.
abstract class IBuilder<T> {
  T build();
}
