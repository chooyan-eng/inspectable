part of inspectable;

List<String> _parseDescription(String description) {
  final attributeMatches = RegExp(r'(?<=\().+(?=\))').allMatches(description);
  if (attributeMatches.isNotEmpty) {
    final matchString = attributeMatches.first.group(0);
    return matchString?.split(',') ?? [];
  }
  return [];
}
