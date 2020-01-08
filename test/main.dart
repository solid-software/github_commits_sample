import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:github_commits_sample/commits_history/provider/commits_history_notifier.dart';
import 'package:github_commits_sample/commits_history/screen/commits_history_screen.dart';
import 'package:github_commits_sample/common/config/github_config.dart';
import 'package:github_commits_sample/util/github/client/github_client.dart';
import 'package:provider/provider.dart';

import 'driver/driver_request_handler.dart';
import 'mock/mock_github_client.dart';

void main() {
  final MockGithubClient _client = MockGithubClient();
  final DriverRequestHandler handler = DriverRequestHandler(_client);

  enableFlutterDriverExtension(handler: handler.requestHandler);

  runApp(GithubCommitsTestApp(
    client: _client,
    handler: handler,
  ));
}

class GithubCommitsTestApp extends StatefulWidget {
  final MockGithubClient client;
  final DriverRequestHandler handler;

  const GithubCommitsTestApp({Key key, this.client, this.handler})
      : super(key: key);

  @override
  _GithubCommitsTestAppState createState() => _GithubCommitsTestAppState();
}

class _GithubCommitsTestAppState extends State<GithubCommitsTestApp> {
  GithubClient _client;

  @override
  void initState() {
    _client = GithubClient(
      repositoryPath: GithubConfig.repositoryPath,
      client: widget.client,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: widget.handler.restartAppStream,
      builder: (context, snapshot) {
        return MaterialApp(
          key: UniqueKey(),
          home: ChangeNotifierProvider(
            create: (context) => CommitsHistoryNotifier(_client),
            child: CommitsHistoryScreen(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    widget.handler.close();
    super.dispose();
  }
}
