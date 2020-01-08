import 'package:flutter/material.dart';
import 'package:github_commits_sample/commits_history/provider/commits_history_notifier.dart';

class ErrorBottomSheet extends StatelessWidget {
  const ErrorBottomSheet({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              "Error loading commits. Tap 'Try again' button, if the problem persists please contact support.",
              maxLines: 2,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          FlatButton(
            child: Text(
              "Try again",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: CommitsHistoryNotifier.of(context).retry,
          ),
        ],
      ),
    );
  }
}
