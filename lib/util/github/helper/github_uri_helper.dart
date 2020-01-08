import 'package:github_commits_sample/common/config/github_config.dart';

class GithubUriHelper {
  static const _authority = "api.github.com";
  static const _reposApiPath = "repos";
  final String _repository;

  GithubUriHelper(this._repository);

  Uri getCommitsUri({
    int page = 1,
    int commitsPerPage = GithubConfig.commitsPerPage,
  }) {
    return Uri.https(
      _authority,
      "$_reposApiPath/$_repository/commits",
      {'page': '$page', 'per_page': "$commitsPerPage"},
    );
  }
}
