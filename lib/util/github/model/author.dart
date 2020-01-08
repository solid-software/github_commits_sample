class Author {
  final String name;
  final String email;
  final DateTime date;
  final String avatarUrl;

  Author({
    this.name,
    this.email,
    this.date,
    this.avatarUrl,
  });

  factory Author.fromJson(Map<String, Object> json, String avatarUrl) {
    return Author(
      name: json['name'],
      email: json['email'],
      date: DateTime.tryParse(json['date']),
      avatarUrl: avatarUrl,
    );
  }
}
