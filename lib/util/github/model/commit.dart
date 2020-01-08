import 'author.dart';

class Commit {
  final String message;
  final Author author;
  final String url;
  final int commentCount;
  final String hash;
  
  String get shortHash => hash?.substring(0, 7);

  Commit({
    this.message,
    this.author,
    this.url,
    this.commentCount,
    this.hash,
  });

  factory Commit.fromJson(Map<String, Object> json) {
    final Map commitJson = json['commit'] ?? {};
    final Map authorJson = json['author'] ?? {};
    return Commit(
      message: commitJson['message'],
      author: Author.fromJson(commitJson['author'], authorJson['avatar_url']),
      url: commitJson['url'],
      commentCount: commitJson['comment_count'],
      hash: json['sha']
    );
  }
}
