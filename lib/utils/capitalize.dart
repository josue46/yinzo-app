extension Capitalized on String {
  String titleCase() {
    // Check if the string is empty
    if (isEmpty) {
      return this;
    }
    // Check if the first character is a letter
    final RegExp pattern = RegExp(r'^[a-zA-Z]');
    if (!pattern.hasMatch(this[0])) {
      return this;
    }
    String newString = this[0].toUpperCase() + substring(1);
    return newString;
  }
}
