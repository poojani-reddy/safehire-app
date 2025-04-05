class User {
  final String id;
  final String name;
  final List<String> badges;

  User({
    required this.id,
    required this.name,
    List<String>? badges,
  }) : badges = badges ?? [];
} 