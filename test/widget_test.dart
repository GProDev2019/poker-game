import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poker_game/main.dart';
import 'package:poker_game/screens/offline_game_page.dart';
import 'package:poker_game/screens/results_page.dart';
import 'package:poker_game/screens/start.dart';

void main() {
  testWidgets('Offline game smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(PokerGame());
    const int numOfPlayers = 2;
    await tester.enterText(
        find.byKey(StartPage.passwordInputFieldKey), numOfPlayers.toString());
    expect(find.text(numOfPlayers.toString()), findsOneWidget);

    await tester.tap(find.byKey(StartPage.offlineButtonKey));
    await tester.pumpAndSettle();

    final Finder cardWidget1 =
        find.byKey(Key(OfflineGamePage.cardsKey.toString() + '1'));
    await tester.tap(cardWidget1);
    final Finder cardWidget2 =
        find.byKey(Key(OfflineGamePage.cardsKey.toString() + '2'));
    await tester.tap(cardWidget2);

    await tester.tap(find.byKey(OfflineGamePage.replaceCardsButtonKey));
    await tester.tap(find.byKey(OfflineGamePage.endTurnButtonKey));
    await tester.pump();

    final Finder cardWidget3 =
        find.byKey(Key(OfflineGamePage.cardsKey.toString() + '3'));
    await tester.tap(cardWidget3);
    final Finder cardWidget4 =
        find.byKey(Key(OfflineGamePage.cardsKey.toString() + '4'));
    await tester.tap(cardWidget4);

    await tester.tap(find.byKey(OfflineGamePage.replaceCardsButtonKey));
    await tester.tap(find.byKey(OfflineGamePage.endTurnButtonKey));

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(ResultsPage.backToMenuButton));
  });
}
