import 'package:flutter/material.dart';
import 'package:luna_mhealth_mobile/views/dynamic_template.dart';

class NavigationUtil {
  static void navigateToDynamicTemplate(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DynamicTemplate(),
    ));
  }

  static void navigateBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  // Additional navigation functions as needed...
}
