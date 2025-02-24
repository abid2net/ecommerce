enum ProductCategory {
  electronics,
  clothing,
  books,
  food,
  automotive,
  furniture,
  tyres,
  toys,
  tools,
  other;

  String get displayName => name[0].toUpperCase() + name.substring(1);
}
