/// IBuilder is a generic interface for implementing builder patterns.
/// It ensures that all builder classes provide a `build()` method that
/// returns an instance of the desired type.
///
/// This interface is used by:
/// - `ComponentBuilder`
/// - `LineBuilder`
/// - `PageBuilder`
/// - `ModuleBuilder`
abstract class IBuilder<T> {
  T build();
}
