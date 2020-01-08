import 'package:flutter/material.dart';
import 'package:github_commits_sample/commits_history/provider/commits_history_notifier.dart';
import 'package:github_commits_sample/commits_history/widget/commit_tile.dart';
import 'package:github_commits_sample/commits_history/widget/error_bottom_sheet.dart';
import 'package:infinite_widgets/infinite_widgets.dart';
import 'package:provider/provider.dart';

class CommitsHistoryScreen extends StatefulWidget {
  @override
  _CommitsHistoryScreenState createState() => _CommitsHistoryScreenState();
}

class _CommitsHistoryScreenState extends State<CommitsHistoryScreen> {
  CommitsHistoryNotifier commitNotifier;

  @override
  Widget build(BuildContext context) {
    return Consumer<CommitsHistoryNotifier>(
        builder: (context, notifier, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('GitHub commits sample'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: CommitsHistoryNotifier.of(context).refresh,
            ),
          ],
        ),
        body: Builder(
          builder: (context) {
            if (notifier.commits.isEmpty && !notifier.hasNextPage) {
              return _CommitsPlaceholder();
            }

            return InfiniteListView(
              itemCount: notifier.commits.length,
              itemBuilder: (context, index) => CommitTile(
                commit: notifier.commits[index],
              ),
              nextData: notifier.loadNextPage,
              hasNext: notifier.hasNextPage,
            );
          },
        ),
        bottomSheet: _getBottomSheet(notifier.hasError),
      );
    });
  }

  Widget _getBottomSheet(bool hasError) {
    if (!hasError) return null;

    return ErrorBottomSheet();
  }
}

class _CommitsPlaceholder extends StatelessWidget {
  const _CommitsPlaceholder({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'It seems like there are no commits yet',
        style: TextStyle(
          fontSize: 18.0,
          color: Colors.grey,
        ),
      ),
    );
  }
}
