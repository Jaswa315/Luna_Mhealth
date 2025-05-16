import 'package:mockito/annotations.dart';
import 'package:luna_mobile/states/module_state.dart';
import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/models/pages/sequence_of_pages.dart';
import 'package:luna_core/models/components/component.dart';
import 'package:luna_mobile/renderers/irenderer.dart';
import 'package:luna_mobile/controllers/page_navigation_controller.dart';

@GenerateMocks([
  ModuleState,
  Page,
  SequenceOfPages,
  Component,
  IRenderer,
  PageNavigationController,
])
void main() {}
