import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Poker game', () {
    final SerializableFinder offlineButtonFinder =
        find.byValueKey('OFFLINE_BUTTON_KEY');
    final SerializableFinder numOfPlayersInputFieldFinder =
        find.byValueKey('NUM_OF_PLAYERS_INPUT_FIELD_KEY');
    final SerializableFinder startGameButtonFinder =
        find.byValueKey('START_GAME_BUTTON_KEY');
    final SerializableFinder cardWidget1Finder = find.byValueKey('CARDS_KEY_2');
    final SerializableFinder cardWidget2Finder = find.byValueKey('CARDS_KEY_4');
    final SerializableFinder replaceCardsButtonFinder =
        find.byValueKey('REPLACE_CARDS_BUTTON_KEY');
    final SerializableFinder endTurnButtonFinder =
        find.byValueKey('END_TURN_BUTTON_KEY');
    final SerializableFinder backToMenuButtonFinder =
        find.byValueKey('BACK_TO_MENU_BUTTON_KEY');

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test('Play offline poker game', () async {
      await driver.tap(offlineButtonFinder);
      await driver.tap(numOfPlayersInputFieldFinder);
      await driver.enterText('3');
      await driver.tap(startGameButtonFinder);

      await driver.tap(cardWidget1Finder);
      await driver.tap(cardWidget2Finder);
      await driver.tap(replaceCardsButtonFinder);
      await driver.tap(endTurnButtonFinder);

      await driver.tap(cardWidget2Finder);
      await driver.tap(replaceCardsButtonFinder);
      await driver.tap(endTurnButtonFinder);

      await driver.tap(replaceCardsButtonFinder);
      await driver.tap(endTurnButtonFinder);

      await driver.tap(backToMenuButtonFinder);
    });
  });
}
