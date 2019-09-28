import 'package:poker_game/game_logic/actions.dart';
import 'package:poker_game/game_logic/dispatcher.dart';
import 'package:poker_game/game_store/deck.dart';
import 'package:poker_game/game_store/game_state.dart';
import 'package:poker_game/game_store/hand.dart';
import 'package:poker_game/game_store/player.dart';
import 'package:poker_game/game_store/playing_card.dart';
import 'package:test/test.dart';

class DispatcherTester {
  final Dispatcher dispatcher = Dispatcher();
  final GameState state = GameState();

  void testChangeNumberOfPlayers(int numOfPlayers) {
    if (GameState.minNumOfPlayers <= numOfPlayers &&
        numOfPlayers <= GameState.maxNumOfPlayers) {
      dispatcher.dispatchPokerGameAction(
          state, ChangeNumberOfPlayersAction(numOfPlayers));
      expect(state.numOfPlayers, numOfPlayers);
    } else {
      expect(
          () => dispatcher.dispatchPokerGameAction(
              state, ChangeNumberOfPlayersAction(numOfPlayers)),
          throwsA(const TypeMatcher<AssertionError>()));
    }
  }

  void testOfflineGameStart() {
    dispatcher.dispatchPokerGameAction(state, StartOfflineGameAction());
    expect(state.deck.cards.length,
        Deck.numOfCards - state.players.length * Hand.maxNumOfCards);
    for (Player player in state.players) {
      expect(player.hand.cards.length, Hand.maxNumOfCards);
    }
  }

  void testTogglingCard(
      int playerIndex, PlayingCard selectedCard, bool expectedValue) {
    dispatcher.dispatchPokerGameAction(
        state, ToggleSelectedCardAction(selectedCard));
    expect(
        expectedValue,
        state.players[playerIndex].hand.cards
            .firstWhere((PlayingCard card) =>
                card.color == selectedCard.color &&
                card.rank == selectedCard.rank)
            .selectedForReplace);
  }

  void testReplaceCard(
      int playerIndex, int cardIndex, PlayingCard replacedCard) {
    dispatcher.dispatchPokerGameAction(state, ReplaceCardsAction());
    expect(true, state.players[playerIndex].replacedCards);
    expect(false,
        state.players[playerIndex].hand.cards[cardIndex] == replacedCard);
  }
}

void main() {
  final DispatcherTester dispatcherTester = DispatcherTester();
  group('Dispatcher', () {
    test('Number of players should change', () {
      dispatcherTester.testChangeNumberOfPlayers(4);
    });
    test("Number of players shouldn't change #1", () {
      dispatcherTester.testChangeNumberOfPlayers(1);
    });
    test("Number of players shouldn't change #2", () {
      dispatcherTester.testChangeNumberOfPlayers(6);
    });
    test('Offline game should start #1', () {
      dispatcherTester.testOfflineGameStart();
    });
    test('Offline game should start #2', () {
      dispatcherTester.testChangeNumberOfPlayers(4);
      dispatcherTester.testOfflineGameStart();
    });
    test('Card should be selected for replace', () {
      dispatcherTester.testOfflineGameStart();
      const int playerIndex = 0;
      const int cardIndexToReplace = 0;
      dispatcherTester.testTogglingCard(
          playerIndex,
          dispatcherTester
              .state.players[playerIndex].hand.cards[cardIndexToReplace],
          true);
    });
    test('Cards should be selected/unselected for replace', () {
      dispatcherTester.testOfflineGameStart();
      const int player1Index = 0;
      const int card1IndexToReplace = 0;
      dispatcherTester.testTogglingCard(
          player1Index,
          dispatcherTester
              .state.players[player1Index].hand.cards[card1IndexToReplace],
          true);
      dispatcherTester.testTogglingCard(
          player1Index,
          dispatcherTester
              .state.players[player1Index].hand.cards[card1IndexToReplace],
          false);
      const int player2Index = 1;
      dispatcherTester.state.currentPlayer = player2Index;
      const int card2IndexToReplace = 2;
      dispatcherTester.testTogglingCard(
          player2Index,
          dispatcherTester
              .state.players[player2Index].hand.cards[card2IndexToReplace],
          true);
      dispatcherTester.testTogglingCard(
          player2Index,
          dispatcherTester
              .state.players[player2Index].hand.cards[card2IndexToReplace],
          false);
    });
    test('Card should be replaced', () {
      dispatcherTester.testOfflineGameStart();
      const int playerIndex = 0;
      const int cardIndexToReplace = 0;
      final PlayingCard cardToReplace = dispatcherTester
          .state.players[playerIndex].hand.cards[cardIndexToReplace];
      dispatcherTester.testTogglingCard(playerIndex, cardToReplace, true);
      dispatcherTester.testReplaceCard(
          playerIndex, cardIndexToReplace, cardToReplace);
    });
  });
}
