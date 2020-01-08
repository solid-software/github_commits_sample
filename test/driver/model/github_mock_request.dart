import 'dart:convert';

class GithubMockRequest {
  final String requestUrl;
  final String responseBody;
  final int statusCode;

  GithubMockRequest({
    this.responseBody,
    this.statusCode,
    this.requestUrl,
  });

  String toJson() {
    final Map json = {
      'responseJson': responseBody,
      'statusCode': statusCode,
      'requestUrl': requestUrl,
    };

    return jsonEncode(json);
  }

  factory GithubMockRequest.fromJson(String jsonString) {
    final Map json = jsonDecode(jsonString);
    if (json == null) return null;

    return GithubMockRequest(
      responseBody: json['responseJson'],
      statusCode: json['statusCode'],
      requestUrl: json['requestUrl'],
    );
  }
}
