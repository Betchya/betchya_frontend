// ignore_for_file: use_super_parameters

import 'package:formz/formz.dart';

enum DOBValidationError { invalid }

class DOBInput extends FormzInput<String, DOBValidationError> {
  const DOBInput.pure() : super.pure('');
  const DOBInput.dirty([String value = '']) : super.dirty(value);

  static final RegExp _dobRegExp = RegExp(
    r'^(0[1-9]|1[0-2])/(0[1-9]|[12][0-9]|3[01])/\d{4}',
  );

  @override
  DOBValidationError? validator(String value) {
    return _dobRegExp.hasMatch(value) ? null : DOBValidationError.invalid;
  }
}
