import 'package:github_commits_sample/common/config/github_config.dart';
import 'package:github_commits_sample/util/github/helper/github_uri_helper.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

class MockGithubClient extends Mock implements Client {
  MockGithubClient() {
    // Set default response for commit requests
    when(this.get(GithubUriHelper(GithubConfig.repositoryPath).getCommitsUri()))
        .thenAnswer((_) => Future.value(Response("[]", 200)));
  }
}
