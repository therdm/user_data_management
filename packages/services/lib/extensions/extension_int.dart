
extension ExtensionInt on int {
  String tryDoubleDigit() {
    if (this > 9 || this < -9) {
      return toString();
    } else if(this >= 0) {
      return '0$this';
    } else {
      return '$this'.replaceAll('-', '-0');
    }
  }
}