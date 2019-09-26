import 'poker_deck.dart';
import 'poker_player.dart';

class PokerGameState {
  PokerDeck deck;
  List<PokerPlayer> players;
  int currentPlayer;
  HandOutStrategy handOutStrategy;
  static const int numOfPlayers = 2;

  PokerGameState(this.players,
      [this.handOutStrategy = HandOutStrategy.oneByOneCard])
      : deck = PokerDeck.initial();

  factory PokerGameState.initial() => PokerGameState(List<PokerPlayer>.generate(
      numOfPlayers, (int index) => PokerPlayer(index),
      growable: false));
}

enum HandOutStrategy { oneByOneCard, allCardsAtOnce }
