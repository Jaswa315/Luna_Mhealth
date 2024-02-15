// ignore_for_file: public_member_api_docs

import 'page.dart';

/// Represents a module in the application.
class Module {
  String title;
  String description;
  List<Page> pages = [];

  /// Constructs a new instance of the [Module] class with the given [title] and [description].
  Module({required this.title, required this.description});

  /// Adds a [page] to the module.
  void addPage(Page page) {
    pages.add(page);
  }

  /// Removes a [page] from the module.
  void removePage(Page page) {
    pages.remove(page);
  }
}
