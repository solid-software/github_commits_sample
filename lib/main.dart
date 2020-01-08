import 'package:flutter/material.dart';
import 'package:github_commits_sample/commits_history/provider/commits_history_notifier.dart';
import 'package:github_commits_sample/commits_history/screen/commits_history_screen.dart';
import 'package:github_commits_sample/common/config/github_config.dart';
import 'package:github_commits_sample/util/github/client/github_client.dart';
import 'package:provider/provider.dart';

void main() => runApp(GitHubCommitsApp());

class GitHubCommitsApp extends StatelessWidget {
  final GithubClient _client = GithubClient(
    repositoryPath: GithubConfig.repositoryPath,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Github commits sample app',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        primaryColor: Colors.blueGrey[700],
      ),
      home: ChangeNotifierProvider(
        create: (context) => CommitsHistoryNotifier(_client),
        child: CommitsHistoryScreen(),
      ),
    );
  }
}
