import 'package:luna_core/utils/types.dart';

/// Abstract base class for all components.
abstract class Component {
  /// Convert the component to a JSON representation (excluding the 'type' field).
  Json toJson();
}
