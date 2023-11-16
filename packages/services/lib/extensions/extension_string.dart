extension ExtensionStringN on String? {
  bool get isEmptyOrNull => this?.isEmpty ?? true;

  bool get isNotEmptyAndNotNull => this?.isNotEmpty ?? false;
}

extension ExtensionString on String {
  String toSentenceCase() {
    if (isEmpty) {
      return '';
    } else if (length == 1) {
      return toUpperCase();
    } else {
      return this[0].toUpperCase() + substring(1).toLowerCase();
    }
  }
}
