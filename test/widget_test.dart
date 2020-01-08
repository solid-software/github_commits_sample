// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_commits_sample/main.dart';

void main() {
  testWidgets(
    "Has an icon button with the refresh icon on screen",
    (WidgetTester tester) async {
      await tester.pumpWidget(GitHubCommitsApp());

      expect(find.byType(IconButton), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    },
  );

  testWidgets(
    "The progress indicator appears after app start on initial data loading",
    (WidgetTester tester) async {
      await tester.pumpWidget(GitHubCommitsApp());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    "Shows loading indicator after tap on refresh button",
    (WidgetTester tester) async {
      await tester.pumpWidget(GitHubCommitsApp());

      await tester.tap(find.byIcon(Icons.refresh));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );
}
