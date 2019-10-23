import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poker_game/main.dart';
import 'package:poker_game/screens/game_page.dart';
import 'package:poker_game/screens/results_page.dart';
import 'package:poker_game/screens/start.dart';

void main() {
  testWidgets('Offline game smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(PokerGame());
    const int numOfPlayers = 2;

    await tester.tap(find.byKey(StartPage.offlineButtonKey));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(StartPage.numOfPlayersInputFieldKey),
        numOfPlayers.toString());
    expect(find.text(numOfPlayers.toString()), findsOneWidget);

    await tester.tap(find.byKey(StartPage.startGameButtonKey));
    await tester.pumpAndSettle();

    final Finder cardWidget1 =
        find.byKey(const Key(GamePage.cardsKeyString + '1'));
    await tester.tap(cardWidget1);

    await tester.tap(find.byKey(GamePage.replaceCardsButtonKey));
    await tester.tap(find.byKey(GamePage.endTurnButtonKey));
    await tester.pump();

    final Finder cardWidget3 =
        find.byKey(const Key(GamePage.cardsKeyString + '3'));
    await tester.tap(cardWidget3);
    final Finder cardWidget4 =
        find.byKey(const Key(GamePage.cardsKeyString + '4'));
    await tester.tap(cardWidget4);

    await tester.tap(find.byKey(GamePage.replaceCardsButtonKey));
    await tester.tap(find.byKey(GamePage.endTurnButtonKey));

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(ResultsPage.backToMenuButtonKey));
  });
}
