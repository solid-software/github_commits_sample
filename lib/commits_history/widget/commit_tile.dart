import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:github_commits_sample/util/github/model/commit.dart';

class CommitTile extends StatelessWidget {
  final Commit commit;

  const CommitTile({Key key, this.commit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final author = commit.author;
    return ListTile(
      title: Text(
        commit.message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text("By ${author.name}"),
      trailing: GestureDetector(
        onTap: () => _copyHashCode(context),
        child: Text(
          commit.shortHash ?? '',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      leading: Container(
        height: 48.0,
        width: 48.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.0),
          child: author.avatarUrl != null
              ? CachedNetworkImage(
                  imageUrl: author.avatarUrl,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )
              : Image.asset('assets/default_avatar.jpg'),
        ),
      ),
    );
  }

  void _copyHashCode(BuildContext context) async {
    await ClipboardManager.copyToClipBoard(commit.hash);

    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied to clipboard'),
      ),
    );
  }
}
