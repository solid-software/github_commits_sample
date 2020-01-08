import 'dart:convert';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:github_commits_sample/util/github/model/commit.dart';
import 'package:test/test.dart';

import 'driver/driver_request_handler.dart';
import 'driver/github_driver.dart';

void main() {
  FlutterDriver driver;
  GithubDriver githubDriver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
    githubDriver = GithubDriver(driver);
  });

  setUp(() async {
    await githubDriver.setRespondToRequests(true);
    await driver.requestData(DriverRequestHandler.restartRequest);

    // Wait until application will be reloaded and fetch initial data
    await driver.waitForAbsent(find.text("Try again"));
  });

  test(
    "Show commit placeholder when there are no commits in repository",
    () async {
      await driver.waitFor(find.text("It seems like there are no commits yet"));
    },
  );

  test(
    "Show error bottom sheet on error response code and loads data after tap 'Try again'",
    () async {
      await githubDriver.setCommitResponse('', 400);

      await driver.tap(find.byType('IconButton'));

      await driver.waitFor(find.text(
          "Error loading commits. Tap 'Try again' button, if the problem persists please contact support."));
      await driver.waitFor(find.text("Try again"));

      await githubDriver.setCommitResponse('[]', 200);

      await driver.tap(find.text("Try again"));

      await driver.waitForAbsent(find.text("Try again"));
    },
  );

  test("Show error popup when no ethernet connection", () async {
    await githubDriver.setRespondToRequests(false);

    await driver.tap(find.byType("IconButton"));

    await driver.waitFor(find.text("Try again"));

    final successfulResponse = [
      {
        'sha': '04eb55e4fa6e550e7dedaab83afa2f568fb8d1d7',
        'commit': {
          'author': {
            'name': 'Solid Software',
            'email': 'hello@solid.software',
            'date': '2019-12-26T17:12:17Z'
          },
          'message': 'Another test commit message',
          'comment_count': 0
        },
      }
    ];

    await githubDriver.setCommitResponse(jsonEncode(successfulResponse), 200);

    await driver.tap(find.text("Try again"));

    await driver.waitFor(find.text('Another test commit message'));
  });

  test("Load and show commits", () async {
    final responseBody = [
      {
        'sha': '04ed55e4fa6e550e7dedaab83afa2f568fb8d1d7',
        'commit': {
          'author': {
            'name': 'Solid Software',
            'email': 'hello@solid.software',
            'date': '2019-12-26T17:12:17Z'
          },
          'message': 'Test commit message',
          'comment_count': 0
        },
        'author': {
          'avatar_url': 'https://avatars2.githubusercontent.com/u/40825054?v=4'
        }
      },
      {
        'sha': '04eb55e4fa6e550e7dedaab83afa2f568fb8d1d7',
        'commit': {
          'author': {
            'name': 'Solid Software',
            'email': 'hello@solid.software',
            'date': '2019-12-26T17:12:17Z'
          },
          'message': 'Another test commit message',
          'comment_count': 0
        },
      }
    ];

    await githubDriver.setCommitResponse(jsonEncode(responseBody), 200);

    await driver.tap(find.byType('IconButton'));

    await driver.waitFor(find.byType("CommitTile"));
    await driver.waitFor(find.text('Test commit message'));
    await driver.waitFor(find.text('By Solid Software'));
  });

  test(
    "Copy commit hash to clipboard",
    () async {
      final responseBody = [
        {
          'sha': '04eb55e4fa6e550e7dedaab83afa2f568fb8d1d7',
          'commit': {
            'author': {
              'name': 'Solid Software',
              'email': 'hello@solid.software',
              'date': '2019-12-26T17:12:17Z'
            },
            'message': 'Another test commit message',
            'comment_count': 0
          },
        }
      ];

      await githubDriver.setCommitResponse(jsonEncode(responseBody), 200);

      await driver.tap(find.byType("IconButton"));

      Commit lastCommit = Commit.fromJson(responseBody.last);

      await driver.tap(find.text(lastCommit.shortHash));
      await driver.waitFor(find.text('Copied to clipboard'));
    },
  );

  tearDownAll(() async {
    await driver.close();
  });
}
