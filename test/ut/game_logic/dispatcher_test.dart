import 'package:poker_game/game_logic/actions.dart';
import 'package:poker_game/game_logic/dispatcher.dart';
import 'package:poker_game/game_store/deck.dart';
import 'package:poker_game/game_store/game_store.dart';
import 'package:poker_game/game_store/hand.dart';
import 'package:poker_game/game_store/player.dart';
import 'package:poker_game/game_store/playing_card.dart';
import 'package:test/test.dart';

class DispatcherTester {
  final Dispatcher dispatcher = Dispatcher();
  final GameStore store = GameStore();

  void testOfflineGameStart([int numOfPlayers = 2]) {
    final List<String> playersNames = List<String>.generate(
        numOfPlayers, (int pos) => 'Player ' + pos.toString());
    dispatcher.dispatchPokerGameAction(
        store, StartOfflineGameAction(numOfPlayers, playersNames));
    expect(
        store.offlineGameState.deck.cards.length,
        Deck.numOfCards -
            store.offlineGameState.players.length * Hand.maxNumOfCards);
    for (Player player in store.offlineGameState.players) {
      expect(player.hand.cards.length, Hand.maxNumOfCards);
    }
  }

  void testTogglingCard(
      int playerIndex, PlayingCard selectedCard, bool expectedValue) {
    dispatcher.dispatchPokerGameAction(
        store, ToggleSelectedCardAction(selectedCard));
    expect(
        expectedValue,
        store.offlineGameState.players[playerIndex].hand.cards
            .firstWhere((PlayingCard card) =>
                card.color == selectedCard.color &&
                card.rank == selectedCard.rank)
            .selectedForReplace);
  }

  void testReplaceCard(
      int playerIndex, int cardIndex, PlayingCard replacedCard) {
    dispatcher.dispatchPokerGameAction(store, ReplaceCardsAction());
    expect(true, store.offlineGameState.players[playerIndex].replacedCards);
    expect(
        false,
        store.offlineGameState.players[playerIndex].hand.cards[cardIndex] ==
            replacedCard);
  }
}

void main() {
  final DispatcherTester dispatcherTester = DispatcherTester();
  group('Dispatcher', () {
    test('Offline game should start #1', () {
      dispatcherTester.testOfflineGameStart();
    });
    test('Offline game should start #2', () {
      dispatcherTester.testOfflineGameStart(4);
    });
    test('Card should be selected for replace', () {
      dispatcherTester.testOfflineGameStart();
      const int playerIndex = 0;
      const int cardIndexToReplace = 0;
      dispatcherTester.testTogglingCard(
          playerIndex,
          dispatcherTester.store.offlineGameState.players[playerIndex].hand
              .cards[cardIndexToReplace],
          true);
    });
    test('Cards should be selected/unselected for replace', () {
      dispatcherTester.testOfflineGameStart();
      const int player1Index = 0;
      const int card1IndexToReplace = 0;
      dispatcherTester.testTogglingCard(
          player1Index,
          dispatcherTester.store.offlineGameState.players[player1Index].hand
              .cards[card1IndexToReplace],
          true);
      dispatcherTester.testTogglingCard(
          player1Index,
          dispatcherTester.store.offlineGameState.players[player1Index].hand
              .cards[card1IndexToReplace],
          false);
      const int player2Index = 1;
      dispatcherTester.store.offlineGameState.currentPlayerIndex = player2Index;
      const int card2IndexToReplace = 2;
      dispatcherTester.testTogglingCard(
          player2Index,
          dispatcherTester.store.offlineGameState.players[player2Index].hand
              .cards[card2IndexToReplace],
          true);
      dispatcherTester.testTogglingCard(
          player2Index,
          dispatcherTester.store.offlineGameState.players[player2Index].hand
              .cards[card2IndexToReplace],
          false);
    });
    test('Card should be replaced', () {
      dispatcherTester.testOfflineGameStart();
      const int playerIndex = 0;
      const int cardIndexToReplace = 0;
      final PlayingCard cardToReplace = dispatcherTester.store.offlineGameState
          .players[playerIndex].hand.cards[cardIndexToReplace];
      dispatcherTester.testTogglingCard(playerIndex, cardToReplace, true);
      dispatcherTester.testReplaceCard(
          playerIndex, cardIndexToReplace, cardToReplace);
    });
  });
}
