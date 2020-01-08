import 'package:github_commits_sample/common/config/github_config.dart';
import 'package:github_commits_sample/util/github/client/github_client.dart';
import 'package:github_commits_sample/util/github/helper/github_uri_helper.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'mock/mock_github_client.dart';

void main() {
  final Uri commitsUri =
      GithubUriHelper(GithubConfig.repositoryPath).getCommitsUri();
  GithubClient githubClient;
  MockGithubClient client;

  setUp(() {
    client = MockGithubClient();

    githubClient = GithubClient(
      repositoryPath: GithubConfig.repositoryPath,
      client: client,
    );
  });

  test("Returns empty list from new repository", () async {
    when(client.get(commitsUri)).thenAnswer((_) async => Response('', 409));

    final commits = await githubClient.getCommits();

    expect(commits, isNotNull);
    expect(commits, isEmpty);
  });

  test("Returns an error on invalid response", () async {
    bool errorResponse = false;

    when(client.get(commitsUri)).thenAnswer((_) async => Response('', 400));

    await githubClient.getCommits().catchError(
      (error) {
        errorResponse = true;
      },
    );

    expect(errorResponse, true);
  });

  test("Returns a list of Commit objects if response is successful", () async {
    final commitResponse = ''
        '[{"sha": "04ed55e4fa6e550e7dedaab83afa2f568fb8d1d7",'
        '"commit": '
        '{"author": '
        '{"name": "Solid Software",'
        '"email": "hello@solid.software",'
        '"date": "2019-12-26T17:12:17Z"},'
        '"message": "Test commit message",'
        '"comment_count": 0},'
        '"author": '
        '{"avatar_url": "https://avatars2.githubusercontent.com/u/40825054?v=4"}}]';

    when(client.get(commitsUri))
        .thenAnswer((_) async => Response(commitResponse, 200));

    final commits = await githubClient.getCommits();

    expect(commits, isNotNull);
    expect(commits, isNotEmpty);
  });
}
