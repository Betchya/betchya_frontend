// ignore_for_file: use_super_parameters

import 'package:formz/formz.dart';

enum DateOfBirthValidationError { invalid }

class DateOfBirthInput extends FormzInput<String, DateOfBirthValidationError> {
  const DateOfBirthInput.pure() : super.pure('');
  const DateOfBirthInput.dirty([String value = '']) : super.dirty(value);

  @override
  DateOfBirthValidationError? validator(String value) {
    if (value.isEmpty) return DateOfBirthValidationError.invalid;

    // Check if the date format is mm/dd/yyyy
    final dateRegExp = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    if (!dateRegExp.hasMatch(value)) {
      return DateOfBirthValidationError.invalid;
    }

    // Parse the date to validate it's a real date
    try {
      final parts = value.split('/');
      final month = int.parse(parts[0]);
      final day = int.parse(parts[1]);
      final year = int.parse(parts[2]);

      final date = DateTime(year, month, day);

      // Check if the parsed date matches the input (handles invalid dates
      // like 02/30/2023)
      if (date.month != month || date.day != day || date.year != year) {
        return DateOfBirthValidationError.invalid;
      }

      // Check if the date is not in the future
      if (date.isAfter(DateTime.now())) {
        return DateOfBirthValidationError.invalid;
      }

      // Check if the person is at least 18 years old
      final now = DateTime.now();
      final eighteenYearsAgo = DateTime(now.year - 18, now.month, now.day);
      if (date.isAfter(eighteenYearsAgo)) {
        return DateOfBirthValidationError.invalid;
      }

      return null;
    } catch (e) {
      return DateOfBirthValidationError.invalid;
    }
  }
}
