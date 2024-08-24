bool validateNumber(String? value) {
  if (value == null || value.isEmpty) {
    return false;
  }

  final parsedValue = double.tryParse(value);
  return parsedValue != null && parsedValue > 0;
}
