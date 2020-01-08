import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:github_commits_sample/common/config/github_config.dart';
import 'package:github_commits_sample/util/github/client/github_client.dart';
import 'package:github_commits_sample/util/github/model/commit.dart';
import 'package:provider/provider.dart';

class CommitsHistoryNotifier with ChangeNotifier {
  final GithubClient _client;
  final List<Commit> commits = [];

  bool _hasError = false;
  bool _hasNextPage = true;

  bool get hasNextPage => _hasNextPage && !_hasError;

  bool get hasError => _hasError;

  CommitsHistoryNotifier(this._client);

  static CommitsHistoryNotifier of(BuildContext context) =>
      Provider.of<CommitsHistoryNotifier>(context, listen: false);

  void loadNextPage() async {
    final nextPageIndex = commits.length ~/ GithubConfig.commitsPerPage + 1;

    final List<Commit> nextPageCommits =
        await _client.getCommits(page: nextPageIndex).catchError((error) {
      _hasError = true;
    });

    if (_hasError || nextPageCommits == null) {
      notifyListeners();
      return;
    }

    _hasNextPage = !(nextPageCommits.length < GithubConfig.commitsPerPage);

    commits.addAll(nextPageCommits);
    notifyListeners();
  }

  void retry() {
    _hasError = false;
    notifyListeners();
    loadNextPage();
  }

  void refresh() {
    commits.clear();
    _hasError = false;
    _hasNextPage = true;
    notifyListeners();
  }
}
