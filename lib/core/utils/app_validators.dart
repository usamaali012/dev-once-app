import 'package:flutter/services.dart';

/// # NumberInputFormatter
/// A [TextInputFormatter] that allows only numeric digits in the input.
class NumberInputFormatter extends TextInputFormatter {
  /// Formats the input to allow only numeric digits.
  ///
  /// [oldValue] The previous value of the text input.
  /// [newValue] The new value to be formatted.
  ///
  /// Returns a new [TextEditingValue] with only numeric characters.
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Allow only numeric digits by removing any non-digit characters
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

/// # ThousandsFormatter
/// A [TextInputFormatter] that formats the input to include thousands separators.
class ThousandsFormatter extends TextInputFormatter {
  /// Formats the input by adding thousands separators.
  ///
  /// [oldValue] The previous value of the text input.
  /// [newValue] The new value to be formatted.
  ///
  /// Returns a new [TextEditingValue] with thousands separators added to the input.
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // Regular expression to insert commas for thousands separators
    final regExp = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    final newString = newValue.text.replaceAllMapped(regExp, (Match match) => '${match[1]},');
    return newValue.copyWith(text: newString);
  }
}

/// # PositiveNonDecimalInputFormatter
/// A [TextInputFormatter] that allows only positive non-decimal numbers as input.
class PositiveNonDecimalInputFormatter extends TextInputFormatter {
  /// Formats the input to allow only positive non-decimal numbers.
  ///
  /// [oldValue] The previous value of the text input.
  /// [newValue] The new value to be formatted.
  ///
  /// Returns a new [TextEditingValue] if the new input is a positive integer.
  /// If the input does not match the required format, it returns the old value.
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;
    if (newText.isEmpty) {
      return newValue;
    }

    // Regular expression to ensure the input is a positive integer
    final regex = RegExp(r'^[0-9]\d*$');
    if (regex.hasMatch(newText)) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}
