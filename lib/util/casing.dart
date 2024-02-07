extension Capitalization on String {
  String toCapitalized() {
    return isNotEmpty
        ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}'
        : '';
  }
}
