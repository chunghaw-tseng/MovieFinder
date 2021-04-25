import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:moviefinder/main.dart' as app;
import 'package:moviefinder/views/moviedetails_view.dart';
import 'package:moviefinder/widgets/discover/movie_element.dart';
import 'package:moviefinder/widgets/favorites/favorite_item.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      "on load show discovery movies with their vote rating on top"
      "then click on item to show the details of the item",
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    // Check that the vote count is showing
    expect(find.byKey(Key("Votes0")), findsOneWidget);
    await tester.pumpAndSettle();
    await tester.tap(find.byType((GridMovieElement)).first);
    await tester.pumpAndSettle();
    // Check that the details view is shown correctly
    expect(find.byType(MovieDetailsView), findsOneWidget);
    expect(find.byKey(Key("FavoriteBtn")), findsOneWidget);
    expect(find.text("Duration"), findsOneWidget);
    expect(find.text("Release"), findsOneWidget);
  });

  testWidgets(
      "finds searchbar and searches for spider to show new items"
      "then click on item to show the details of the item",
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    // Check that the search bar is visible
    expect(find.byKey(Key("DiscoverTextField")), findsOneWidget);
    await tester.enterText(find.byKey(Key("DiscoverTextField")), "spider-man");
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    // Make sure that the textview is working
    expect(find.text("spider-man"), findsOneWidget);
    await tester.pumpAndSettle();
    await tester.tap(find.byType((GridMovieElement)).first);
    await tester.pumpAndSettle();
    // check that the search is working when it shows relevant movies
    expect(find.byType(MovieDetailsView), findsOneWidget);
    expect(find.textContaining("spider"), findsOneWidget);
  });

  testWidgets(
      "click on an item to show information"
      "click favorite button to add to favorites and check favorites"
      "check favorites page and then delete the favorite movie from details page",
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.byType((GridMovieElement)).first);
    await tester.pumpAndSettle();
    // Test favorite button exists
    expect(find.byKey(Key("FavoriteBtn")), findsOneWidget);
    await tester.tap(find.byKey(Key("FavoriteBtn")));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    // Test that returned to discovery page
    expect(find.byKey(Key("Title")), findsOneWidget);
    await tester.tap(find.byKey(Key("FavoritePage")));
    await tester.pumpAndSettle();
    // Find favorite movie in favorite page
    expect(find.byType(FavoriteItem), findsOneWidget);
    await tester.tap(find.byType(FavoriteItem));
    await tester.pumpAndSettle();
    expect(find.byKey(Key("FavoriteBtn")), findsOneWidget);
    await tester.tap(find.byKey(Key("FavoriteBtn")));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    // Test that the favorite movie was deleted
    expect(find.byType(FavoriteItem), findsNothing);
  });

  testWidgets(
      "click on an item to show information"
      "click favorite button to add to favorites and check favorites"
      "check favorites page and then delete the favorite movie by swipe",
      (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await tester.tap(find.byType((GridMovieElement)).first);
    await tester.pumpAndSettle();
    // Check that favorite button loads
    expect(find.byKey(Key("FavoriteBtn")), findsOneWidget);
    await tester.tap(find.byKey(Key("FavoriteBtn")));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
    // Checks that returned to discover page
    expect(find.byKey(Key("Title")), findsOneWidget);
    await tester.tap(find.byKey(Key("FavoritePage")));
    await tester.pumpAndSettle();
    // Check that the movie was favorited
    expect(find.byType(FavoriteItem), findsOneWidget);
    await tester.drag(find.byType(FavoriteItem), Offset(500.0, 0.0));
    await tester.pumpAndSettle();
    // Test that the movie was deleted when swiped
    expect(find.byType(FavoriteItem), findsNothing);
  });
}
