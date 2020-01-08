import 'package:flutter_driver/flutter_driver.dart';
import 'package:github_commits_sample/common/config/github_config.dart';
import 'package:github_commits_sample/util/github/helper/github_uri_helper.dart';

import 'model/github_mock_request.dart';

class GithubDriver {
  final FlutterDriver _driver;
  final Uri _commitRequestUri =
      GithubUriHelper(GithubConfig.repositoryPath).getCommitsUri();

  GithubDriver(this._driver);

  Future setCommitResponse(String body, int code) async {
    final mockRequest = GithubMockRequest(
      requestUrl: _commitRequestUri.toString(),
      responseBody: body,
      statusCode: code,
    );

    return _driver.requestData(mockRequest.toJson());
  }

  Future setRespondToRequests(bool respond) {
    // If should respond to requests - set default response
    if (respond) {
      return setCommitResponse("[]", 200);
    }
    return _driver.requestData(null);
  }
}
