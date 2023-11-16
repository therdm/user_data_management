import 'package:flutter/cupertino.dart';

class GraphicsUtils {
  static void closeKeyBoard(BuildContext workingContext) {
    final FocusScopeNode currentFocus = FocusScope.of(workingContext);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
