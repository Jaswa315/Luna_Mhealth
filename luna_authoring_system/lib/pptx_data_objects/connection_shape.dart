import 'package:luna_authoring_system/pptx_data_objects/shape.dart';
import 'package:luna_authoring_system/pptx_data_objects/shape_type.dart';
import 'package:luna_authoring_system/pptx_data_objects/transform.dart';
import 'package:luna_core/utils/emu.dart';

/// The ConnectionShape represents the connectors in the PowerPoint.
/// weight represents the thickness of the connector.
class ConnectionShape implements Shape {
  EMU weight;
  static EMU defaultHalfLineWeight = EMU(6350);

  @override
  Transform transform;

  ConnectionShape(this.weight, this.transform);

  @override
  ShapeType get type => ShapeType.connection;
}
