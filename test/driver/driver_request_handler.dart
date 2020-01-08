import 'dart:async';

import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

import '../mock/mock_github_client.dart';
import 'model/github_mock_request.dart';

class DriverRequestHandler {
  static const String restartRequest = "restart";
  final MockGithubClient _client;
  final StreamController<bool> _restartAppController =
      StreamController.broadcast();

  Stream<bool> get restartAppStream => _restartAppController.stream;

  DriverRequestHandler(this._client);

  Future<String> requestHandler(String request) async {
    if (request == restartRequest) {
      _restartAppController.add(true);
      return null;
    }

    reset(_client);

    final GithubMockRequest driverRequest = GithubMockRequest.fromJson(request);
    if (driverRequest == null) return null;

    final requestUri = Uri.parse(driverRequest.requestUrl);
    when(_client.get(requestUri)).thenAnswer(
      (_) => Future.value(
          Response(driverRequest.responseBody, driverRequest.statusCode)),
    );

    return null;
  }

  void close() {
    _restartAppController.close();
  }
}
