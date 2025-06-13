import 'package:mockito/annotations.dart';
import 'package:luna_core/models/pages/page.dart';
import 'package:luna_core/models/pages/sequence_of_pages.dart';
import 'package:luna_core/models/components/component.dart';

@GenerateMocks([
  Page,
  SequenceOfPages,
  Component,
])
void main() {}
