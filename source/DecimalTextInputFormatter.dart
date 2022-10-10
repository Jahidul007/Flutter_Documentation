class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;
  final int min;
  final int max;

  DecimalTextInputFormatter(
      {required this.decimalRange, required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange > 0 && '.'.allMatches(newValue.text).length <= 1) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }
      if (newValue.text.replaceAll("\$", "") == '') {
        return newValue;
      } else if (double.parse(newValue.text.replaceAll("\$", "")) < min) {
        return const TextEditingValue().copyWith(text: min.toStringAsFixed(2),);
      } else {
        return double.parse(newValue.text.replaceAll("\$", "")) > max
            ? TextEditingValue(
          text: oldValue.text,
          selection: newSelection,
          composing: TextRange.empty,
        )
            : TextEditingValue(
          text: truncated,
          selection: newSelection,
          composing: TextRange.empty,
        );
      }
    } else {
      return oldValue;
    }
  }
}
