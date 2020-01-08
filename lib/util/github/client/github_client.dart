import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:github_commits_sample/common/config/github_config.dart';
import 'package:github_commits_sample/util/github/exception/github_client_exception.dart';
import 'package:github_commits_sample/util/github/helper/github_uri_helper.dart';
import 'package:github_commits_sample/util/github/model/commit.dart';
import 'package:http/http.dart';

class GithubClient {
  final Client _client;
  final GithubUriHelper _uriHelper;

  GithubClient({
    Client client,
    @required String repositoryPath,
  })  : _client = client ?? Client(),
        _uriHelper = GithubUriHelper(repositoryPath);

  Future<List<Commit>> getCommits({
    int page = 1,
    int commitsPerPage = GithubConfig.commitsPerPage,
  }) async {
    final uri = _uriHelper.getCommitsUri(
      page: page,
      commitsPerPage: commitsPerPage,
    );

    final response = await _client.get(uri);

    if (response != null && response.statusCode == 200) {
      final List responseBody = jsonDecode(response.body);
      return responseBody
          .map((responseJson) => Commit.fromJson(responseJson))
          .toList();
    } else if (response != null && response.statusCode == 409) {
      return [];
    } else {
      throw GithubClientException(
          "Github Exception: Please try again or contact support.");
    }
  }
}
